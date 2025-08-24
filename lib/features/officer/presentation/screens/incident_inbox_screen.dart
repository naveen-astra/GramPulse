import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/core/constants/spacing.dart';
import 'package:grampulse/core/presentation/widgets/loading_indicator.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';
import 'package:grampulse/features/map/domain/models/category_model.dart';
import 'package:grampulse/features/officer/domain/models/officer_issue_model.dart';
import 'package:grampulse/features/officer/models/officer_issue_model.dart' as list_model;
import 'package:grampulse/features/officer/presentation/bloc/incident_inbox/incident_inbox_bloc.dart';
import 'package:grampulse/features/officer/presentation/bloc/incident_inbox/incident_inbox_event.dart';
import 'package:grampulse/features/officer/presentation/bloc/incident_inbox/incident_inbox_state.dart';
import 'package:grampulse/features/officer/presentation/widgets/batch_action_bar.dart';
import 'package:grampulse/features/officer/presentation/widgets/filter_panel.dart';
import 'package:grampulse/features/officer/presentation/widgets/incident_kanban_view.dart';
import 'package:grampulse/features/officer/presentation/widgets/incident_list_view.dart';

class IncidentInboxScreen extends StatefulWidget {
  const IncidentInboxScreen({super.key});

  @override
  State<IncidentInboxScreen> createState() => _IncidentInboxScreenState();
}

class _IncidentInboxScreenState extends State<IncidentInboxScreen> {
  bool _isFilterPanelExpanded = false;
  bool _isKanbanView = false;
  Set<String> _selectedIncidentIds = {};

  @override
  void initState() {
    super.initState();
    // Load incidents when screen initializes
    context.read<IncidentInboxBloc>().add(LoadIncidentsEvent());
  }

  void _toggleFilterPanel() {
    setState(() {
      _isFilterPanelExpanded = !_isFilterPanelExpanded;
    });
  }

  void _toggleViewMode() {
    setState(() {
      _isKanbanView = !_isKanbanView;
    });
  }

  void _onIncidentSelected(String id, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedIncidentIds.add(id);
      } else {
        _selectedIncidentIds.remove(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIncidentIds.clear();
    });
  }

  void _onBatchAction(String action) {
    final bloc = context.read<IncidentInboxBloc>();
    
    switch (action) {
      case 'assign':
        bloc.add(AssignSelectedIncidentsEvent(_selectedIncidentIds.toList()));
        break;
      case 'update_status':
        // Show a dialog to select the status
        _showStatusUpdateDialog();
        break;
      case 'export':
        bloc.add(ExportSelectedIncidentsEvent(_selectedIncidentIds.toList()));
        break;
    }
  }

  void _showStatusUpdateDialog() {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectStatus),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: OfficerIssueStatus.values.map((status) => 
            ListTile(
              title: Text(status.localizedString(context)),
              onTap: () {
                Navigator.pop(context);
                context.read<IncidentInboxBloc>().add(
                  UpdateSelectedIncidentsStatusEvent(
                    _selectedIncidentIds.toList(),
                    status,
                  ),
                );
              },
            ),
          ).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.incidentInbox),
        actions: [
          // Filter button
          IconButton(
            icon: Icon(
              _isFilterPanelExpanded ? Icons.filter_list_off : Icons.filter_list,
              color: _isFilterPanelExpanded 
                ? Theme.of(context).colorScheme.primary 
                : null,
            ),
            onPressed: _toggleFilterPanel,
            tooltip: l10n.toggleFilters,
          ),
          // View toggle button
          IconButton(
            icon: Icon(
              _isKanbanView ? Icons.view_list : Icons.view_kanban,
            ),
            onPressed: _toggleViewMode,
            tooltip: _isKanbanView ? l10n.switchToList : l10n.switchToKanban,
          ),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<IncidentInboxBloc>().add(LoadIncidentsEvent());
            },
            tooltip: l10n.refresh,
          ),
          const SizedBox(width: Spacing.sm),
        ],
      ),
      body: BlocBuilder<IncidentInboxBloc, IncidentInboxState>(
        builder: (context, state) {
          if (state is IncidentInboxInitial || state is IncidentInboxLoading) {
            return const Center(
              child: LoadingIndicator(),
            );
          }
          
          if (state is IncidentInboxError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: Spacing.md),
                  ElevatedButton(
                    onPressed: () {
                      context.read<IncidentInboxBloc>().add(LoadIncidentsEvent());
                    },
                    child: Text(l10n.tryAgain),
                  ),
                ],
              ),
            );
          }
          
          if (state is IncidentInboxLoaded) {
            return Column(
              children: [
                // Filter panel - collapsible
                if (_isFilterPanelExpanded)
                  FilterPanel(
                    filters: state.filters ?? {},
                    categories: [
                      CategoryModel(
                        id: 'water', 
                        name: 'Water Supply',
                        iconCode: 'water_drop',
                        color: Colors.blue,
                      ),
                      CategoryModel(
                        id: 'electricity', 
                        name: 'Electricity',
                        iconCode: 'bolt',
                        color: Colors.yellow,
                      ),
                      CategoryModel(
                        id: 'roads', 
                        name: 'Roads',
                        iconCode: 'road',
                        color: Colors.grey,
                      ),
                      CategoryModel(
                        id: 'sanitation', 
                        name: 'Sanitation',
                        iconCode: 'delete',
                        color: Colors.green,
                      ),
                      CategoryModel(
                        id: 'safety', 
                        name: 'Public Safety',
                        iconCode: 'shield',
                        color: Colors.red,
                      ),
                    ],
                    onApplyFilters: (filters) {
                      context.read<IncidentInboxBloc>().add(
                        FilterIncidentsEvent(filters),
                      );
                    },
                    onResetFilters: () {
                      context.read<IncidentInboxBloc>().add(
                        FilterIncidentsEvent({}),
                      );
                    },
                  ),
                
                // Main content - list or kanban view
                Expanded(
                  child: _isKanbanView 
                    ? IncidentKanbanView(
                        issues: state.issues.map((issue) {
                          final categoryModel = CategoryModel(
                            id: 'category-${issue.category.toLowerCase()}',
                            name: issue.category,
                            iconCode: 'label',
                            color: Colors.blue,
                          );
                          
                          return list_model.OfficerIssueModel(
                            id: issue.id,
                            title: issue.title,
                            description: issue.description,
                            category: categoryModel,
                            status: issue.status.toString().split('.').last,
                            priority: issue.priority.toString().split('.').last,
                            createdAt: issue.dateReported,
                            slaDueAt: DateTime.now().add(issue.slaRemaining),
                            slaPercentage: issue.slaRemaining.inSeconds > 0 ? 0.5 : 1.0,
                            location: issue.location,
                          );
                        }).toList(),
                        onTap: (issue) {
                          // Navigate to issue details
                        },
                        onStatusChange: (issue, newStatus) {
                          final status = OfficerIssueStatus.values.firstWhere(
                            (s) => s.toString().split('.').last == newStatus,
                            orElse: () => OfficerIssueStatus.open,
                          );
                          context.read<IncidentInboxBloc>().add(
                            UpdateIncidentStatusEvent(issue.id, status),
                          );
                        },
                      )
                    : IncidentListView(
                        issues: state.issues.map((issue) {
                          final categoryModel = CategoryModel(
                            id: 'category-${issue.category.toLowerCase()}',
                            name: issue.category,
                            iconCode: 'label',
                            color: Colors.blue,
                          );
                          
                          return list_model.OfficerIssueModel(
                            id: issue.id,
                            title: issue.title,
                            description: issue.description,
                            category: categoryModel,
                            status: issue.status.toString().split('.').last,
                            priority: issue.priority.toString().split('.').last,
                            createdAt: issue.dateReported,
                            slaDueAt: DateTime.now().add(issue.slaRemaining),
                            slaPercentage: issue.slaRemaining.inSeconds > 0 ? 0.5 : 1.0,
                            location: issue.location,
                          );
                        }).toList(),
                        sortField: state.sortColumn ?? 'createdAt',
                        sortAscending: state.isAscending,
                        onTap: (issue) {
                          // Navigate to issue details
                        },
                        onQuickAction: (issue, action) {
                          // Handle quick actions
                        },
                        onSort: (field, ascending) {
                          context.read<IncidentInboxBloc>().add(
                            SortIncidentsEvent(field, ascending),
                          );
                        },
                        selectedIds: _selectedIncidentIds,
                        onSelect: _onIncidentSelected,
                      ),
                ),
                
                // Batch action bar - appears when items are selected
                if (_selectedIncidentIds.isNotEmpty)
                  BatchActionBar(
                    selectedCount: _selectedIncidentIds.length,
                    onClearSelection: _clearSelection,
                    onBatchAction: _onBatchAction,
                  ),
              ],
            );
          }
          
          // Default fallback
          return Center(
            child: Text(l10n.noIncidents),
          );
        },
      ),
    );
  }
}
