import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:grampulse/core/presentation/constants/spacing.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';
import 'package:grampulse/features/officer/domain/models/officer_models.dart';

class WorkOrderSection extends StatelessWidget {
  final List<WorkOrderModel> workOrders;
  final VoidCallback onCreateWorkOrder;
  final Function(WorkOrderModel) onViewWorkOrder;
  
  const WorkOrderSection({
    super.key,
    required this.workOrders,
    required this.onCreateWorkOrder,
    required this.onViewWorkOrder,
  });
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(Spacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.workOrders,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onCreateWorkOrder,
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(l10n.createWorkOrder),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xs,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            
            if (workOrders.isEmpty)
              Center(
                child: Text(
                  l10n.noWorkOrders,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: workOrders.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final workOrder = workOrders[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      workOrder.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Spacing.xs),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: WorkOrderModel.getStatusColor(workOrder.status).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                WorkOrderModel.getStatusLabel(context, workOrder.status),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: WorkOrderModel.getStatusColor(workOrder.status),
                                ),
                              ),
                            ),
                            const SizedBox(width: Spacing.sm),
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: Spacing.xs),
                            Text(
                              DateFormat('dd MMM yyyy').format(workOrder.dueDate),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.xs),
                        if (workOrder.estimatedCost != null)
                          Text(
                            l10n.estimatedCost(workOrder.estimatedCost!.toString()),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => onViewWorkOrder(workOrder),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
