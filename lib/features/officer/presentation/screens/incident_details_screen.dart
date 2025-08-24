import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/core/presentation/constants/spacing.dart';
import 'package:grampulse/core/presentation/widgets/app_bar_with_back_button.dart';
import 'package:grampulse/core/presentation/widgets/loading_indicator.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:grampulse/features/officer/domain/models/issue_model.dart';
import 'package:grampulse/features/officer/domain/models/officer_issue_model.dart';
import 'package:grampulse/features/officer/domain/models/officer_models.dart';
import 'package:grampulse/features/officer/presentation/bloc/incident_details/incident_details_bloc.dart';
import 'package:grampulse/features/officer/presentation/bloc/incident_details/incident_details_event.dart';
import 'package:grampulse/features/officer/presentation/bloc/incident_details/incident_details_state.dart';
import 'package:grampulse/features/officer/presentation/widgets/resolution_evidence_section.dart';
import 'package:grampulse/features/officer/presentation/widgets/work_order_section.dart';

class IncidentDetailsScreen extends StatefulWidget {
  const IncidentDetailsScreen({
    super.key,
  });

  @override
  State<IncidentDetailsScreen> createState() => _IncidentDetailsScreenState();
}

class _IncidentDetailsScreenState extends State<IncidentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocBuilder<IncidentDetailsBloc, IncidentDetailsState>(
      builder: (context, state) {
        if (state is IncidentDetailsLoading) {
          return Scaffold(
            appBar: AppBarWithBackButton(
              title: l10n.incidentDetails,
            ),
            body: const Center(child: LoadingIndicator()),
          );
        }
        
        if (state is IncidentDetailsError) {
          return Scaffold(
            appBar: AppBarWithBackButton(
              title: l10n.incidentDetails,
            ),
            body: Center(
              child: Text(l10n.errorLoadingIncident(state.message)),
            ),
          );
        }
        
        if (state is IncidentDetailsLoaded) {
          return _buildLoadedScreen(context, state);
        }
        
        if (state is WorkOrderUpdating || 
            state is StatusUpdating || 
            state is CommentAdding) {
          return Scaffold(
            appBar: AppBarWithBackButton(
              title: l10n.incidentDetails,
            ),
            body: const Center(child: LoadingIndicator()),
          );
        }
        
        return Scaffold(
          appBar: AppBarWithBackButton(
            title: l10n.incidentDetails,
          ),
          body: Center(child: Text(l10n.waitingForData)),
        );
      },
    );
  }
  
  Widget _buildLoadedScreen(
    BuildContext context,
    IncidentDetailsLoaded state,
  ) {
    final l10n = AppLocalizations.of(context);
    final issue = state.issue;
    
    return Scaffold(
      appBar: AppBarWithBackButton(
        title: l10n.incidentDetails,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'status') {
                _showStatusChangeDialog(context, issue.status);
              } else if (value == 'comment') {
                _showCommentDialog(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'status',
                child: Row(
                  children: [
                    const Icon(Icons.edit_note, size: 20),
                    const SizedBox(width: Spacing.sm),
                    Text(l10n.changeStatus),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'comment',
                child: Row(
                  children: [
                    const Icon(Icons.comment, size: 20),
                    const SizedBox(width: Spacing.sm),
                    Text(l10n.addComment),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<IncidentDetailsBloc>().add(
                LoadIncidentDetailsEvent(issue.id),
              );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIncidentHeader(context, issue),
              _buildIncidentDetails(context, issue),
              _buildTimelineSection(context, state.timeline),
              
              ResolutionEvidenceSection(
                resolution: issue.resolution,
                onAddResolution: () {
                  Navigator.pushNamed(
                    context,
                    '/officer/resolution-evidence',
                    arguments: {'issue': issue},
                  ).then((value) {
                    if (value != null) {
                      context.read<IncidentDetailsBloc>().add(
                            LoadIncidentDetailsEvent(issue.id),
                          );
                    }
                  });
                },
              ),
              
              WorkOrderSection(
                workOrders: state.workOrders,
                onCreateWorkOrder: () {
                  _showCreateWorkOrderDialog(context);
                },
                onViewWorkOrder: (workOrder) {
                  // Navigate to work order details screen
                },
              ),
              
              const SizedBox(height: Spacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildIncidentHeader(BuildContext context, IssueModel issue) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            issue.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: Spacing.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(issue.status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(context, issue.status),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Icon(
                Icons.category_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                issue.category,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                DateFormat('dd MMM yyyy').format(issue.dateReported),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentDetails(BuildContext context, IssueModel issue) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      margin: const EdgeInsets.all(Spacing.md),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              issue.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: Spacing.md),
            const Divider(),
            const SizedBox(height: Spacing.md),
            
            // Location details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.location,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        issue.location,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (issue.adminArea != null) ...[
                        const SizedBox(height: Spacing.xs),
                        Text(
                          issue.adminArea!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: Spacing.xs),
                      Text(
                        '${issue.latitude.toStringAsFixed(6)}, ${issue.longitude.toStringAsFixed(6)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: Spacing.md),
            const Divider(),
            const SizedBox(height: Spacing.md),
            
            // Reporter details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.person_outline),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.reportedBy,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        issue.submittedBy,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        l10n.dateReported(DateFormat('dd MMM yyyy').format(issue.dateReported)),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            if (issue.media.isNotEmpty) ...[
              const SizedBox(height: Spacing.md),
              const Divider(),
              const SizedBox(height: Spacing.md),
              
              // Photos
              Text(
                l10n.attachedPhotos,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: Spacing.sm),
              _buildPhotoGrid(context, issue.media),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(BuildContext context, List<MediaModel> media) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: media.length,
        itemBuilder: (context, index) {
          final mediaItem = media[index];
          
          return Container(
            margin: const EdgeInsets.only(right: Spacing.sm),
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTap: () {
                  // Show full image
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(),
                        body: Center(
                          child: InteractiveViewer(
                            maxScale: 5.0,
                            minScale: 0.5,
                            child: Image.network(mediaItem.url),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Image.network(
                  mediaItem.url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineSection(
    BuildContext context,
    List<TimelineEntryModel> timeline,
  ) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      margin: const EdgeInsets.all(Spacing.md),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.timeline,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Spacing.md),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timeline.length,
              itemBuilder: (context, index) {
                final entry = timeline[index];
                final isLast = index == timeline.length - 1;
                
                return _buildTimelineItem(context, entry, isLast);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    TimelineEntryModel entry,
    bool isLast,
  ) {
    final dotColor = _getStatusColorForTimeline(entry.status);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatTimelineStatus(context, entry.status),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                entry.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: Spacing.xs),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(entry.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (entry.updatedBy != null) ...[
                    const SizedBox(width: Spacing.sm),
                    Icon(
                      Icons.person_outline,
                      size: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.updatedBy!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
              if (!isLast) const SizedBox(height: Spacing.md),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateWorkOrderDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final assignedToController = TextEditingController();
    final costController = TextEditingController();
    DateTime? dueDate = DateTime.now().add(const Duration(days: 7));
    
    final formKey = GlobalKey<FormState>();
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.createWorkOrder),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: l10n.title,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.fieldRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Spacing.md),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.fieldRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Spacing.md),
                    TextFormField(
                      controller: assignedToController,
                      decoration: InputDecoration(
                        labelText: l10n.assignTo,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.fieldRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Spacing.md),
                    TextFormField(
                      controller: costController,
                      decoration: InputDecoration(
                        labelText: 'Estimated Cost',
                        border: const OutlineInputBorder(),
                        prefixText: '₹ ',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: Spacing.md),
                    Text(l10n.dueDate),
                    const SizedBox(height: Spacing.xs),
                    InkWell(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: dueDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        
                        if (selectedDate != null) {
                          setState(() => dueDate = selectedDate);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(Spacing.sm),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dueDate != null 
                                  ? DateFormat('dd MMM yyyy').format(dueDate!) 
                                  : l10n.selectDate,
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    Navigator.of(context).pop(true);
                  }
                },
                child: Text(l10n.create),
              ),
            ],
          );
        },
      ),
    );
    
    if (result == true && context.mounted) {
      final double? estimatedCost = costController.text.isEmpty
          ? null
          : double.tryParse(costController.text);
      
      if (dueDate != null) {
        context.read<IncidentDetailsBloc>().add(
              CreateWorkOrderEvent(
                title: titleController.text,
                description: descriptionController.text,
                assignedTo: assignedToController.text,
                dueDate: dueDate!,
                estimatedCost: estimatedCost,
              ),
            );
      }
    }
  }
  
  Future<void> _showStatusChangeDialog(BuildContext context, String currentStatus) async {
    final l10n = AppLocalizations.of(context);
    
    final statuses = [
      'pending',
      'in_progress',
      'resolved',
      'rejected',
    ];
    
    String selectedStatus = currentStatus;
    
    // Convert string status to OfficerIssueStatus enum
    OfficerIssueStatus _stringToStatus(String status) {
      switch (status.toLowerCase()) {
        case 'pending':
          return OfficerIssueStatus.open;
        case 'in_progress':
          return OfficerIssueStatus.inProgress;
        case 'resolved':
          return OfficerIssueStatus.resolved;
        case 'rejected':
          return OfficerIssueStatus.closed;
        default:
          return OfficerIssueStatus.open;
      }
    }
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.changeStatus),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: statuses.map((status) {
                return RadioListTile<String>(
                  title: Text(_getStatusText(context, status)),
                  value: status,
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedStatus = value);
                    }
                  },
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.update),
              ),
            ],
          );
        },
      ),
    );
    
    if (result == true && context.mounted && selectedStatus != currentStatus) {
      context.read<IncidentDetailsBloc>().add(
            UpdateIncidentStatusEvent(_stringToStatus(selectedStatus)),
          );
    }
  }
  
  Future<void> _showCommentDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final commentController = TextEditingController();
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addComment),
        content: TextField(
          controller: commentController,
          decoration: InputDecoration(
            hintText: l10n.enterComment,
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.add),
          ),
        ],
      ),
    );
    
    if (result == true && 
        context.mounted && 
        commentController.text.trim().isNotEmpty) {
      context.read<IncidentDetailsBloc>().add(
            AddCommentEvent(commentController.text.trim()),
          );
    }
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.amber;
      case 'in_progress':
      case 'inprogress':
      case 'in progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context);
    
    switch (status.toLowerCase()) {
      case 'pending':
        return l10n.pending;
      case 'in_progress':
      case 'inprogress':
      case 'in progress':
        return l10n.inProgress;
      case 'resolved':
        return l10n.resolved;
      case 'rejected':
        return l10n.rejected;
      default:
        return status;
    }
  }
  
  Color _getStatusColorForTimeline(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.amber;
      case 'assigned':
        return Colors.purple;
      case 'in_progress':
      case 'inprogress':
      case 'in progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'rejected':
      case 'cancelled':
      case 'canceled':
        return Colors.red;
      case 'comment':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatTimelineStatus(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context);
    
    switch (status.toLowerCase()) {
      case 'open':
        return l10n.statusOpen;
      case 'assigned':
        return l10n.statusAssigned;
      case 'in_progress':
      case 'inprogress':
      case 'in progress':
        return l10n.statusInProgress;
      case 'resolved':
        return l10n.statusResolved;
      case 'rejected':
        return l10n.statusRejected;
      case 'cancelled':
      case 'canceled':
        return l10n.statusCancelled;
      case 'comment':
        return l10n.statusComment;
      default:
        return status;
    }
  }
}
