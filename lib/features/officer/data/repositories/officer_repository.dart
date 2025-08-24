import 'package:grampulse/features/officer/domain/models/issue_model.dart';
import 'package:grampulse/features/officer/domain/models/officer_issue_model.dart';
import 'package:grampulse/features/officer/domain/models/officer_models.dart';
import 'package:grampulse/features/officer/domain/models/resolution_model.dart';

class OfficerRepository {
  // This would normally connect to a service or backend
  // For now, we'll simulate data
  
  Future<List<OfficerIssueModel>> getOfficerIssues() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    return _generateMockIssues();
  }
  
  Future<List<OfficerIssueModel>> filterOfficerIssues(
    List<OfficerIssueModel> issues, 
    Map<String, dynamic> filters,
  ) async {
    // Simulate filtering
    await Future.delayed(const Duration(milliseconds: 300));
    
    return issues.where((issue) {
      // Status filter
      if (filters.containsKey('status') && 
          filters['status'] != null &&
          filters['status'].isNotEmpty &&
          !filters['status'].contains(issue.status)) {
        return false;
      }
      
      // Category filter
      if (filters.containsKey('category') && 
          filters['category'] != null &&
          filters['category'].isNotEmpty &&
          issue.category != filters['category']) {
        return false;
      }
      
      // SLA filter
      if (filters.containsKey('sla')) {
        final slaFilter = filters['sla'] as String?;
        if (slaFilter == 'overdue' && issue.slaRemaining.inSeconds > 0) {
          return false;
        } else if (slaFilter == 'withinSLA' && issue.slaRemaining.inSeconds <= 0) {
          return false;
        }
      }
      
      // Date range filter
      if (filters.containsKey('dateRange') && 
          filters['dateRange'] != null) {
        final dateRange = filters['dateRange'] as Map<String, DateTime>?;
        if (dateRange != null) {
          final startDate = dateRange['start'];
          final endDate = dateRange['end'];
          
          if (startDate != null && issue.dateReported.isBefore(startDate)) {
            return false;
          }
          
          if (endDate != null && issue.dateReported.isAfter(endDate)) {
            return false;
          }
        }
      }
      
      return true;
    }).toList();
  }
  
  Future<void> updateIssueStatus(String issueId, OfficerIssueStatus newStatus) async {
    // This would call an API to update the status
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In a real implementation, this would update the database
    return;
  }

  // New methods for the incident details and resolution features
  Future<IssueModel> getIssueById(String issueId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock data for now
    return IssueModel(
      id: issueId,
      title: 'Water Leakage on Main Street',
      description: 'There is a significant water leak on Main Street near the intersection with Oak Avenue. Water has been flowing continuously for the past 48 hours, causing damage to the road surface.',
      location: 'Main Street & Oak Avenue',
      latitude: 12.9716,
      longitude: 77.5946,
      category: 'Water Supply',
      submittedBy: 'Raj Kumar',
      dateReported: DateTime.now().subtract(const Duration(days: 3)),
      status: 'in_progress',
      urgency: 3,
      media: [
        MediaModel(
          id: '1',
          url: 'https://images.unsplash.com/photo-1523531294919-4bcd7c65e216',
          type: 'image',
          uploadedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        MediaModel(
          id: '2',
          url: 'https://images.unsplash.com/photo-1574219123379-5275260a0863',
          type: 'image',
          uploadedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    );
  }
  
  Future<List<WorkOrderModel>> getWorkOrdersForIssue(String issueId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Mock data
    return [
      WorkOrderModel(
        id: 'WO-1001',
        title: 'Repair Water Pipeline',
        description: 'Dig up the affected area, identify the source of the leak, and replace the damaged section of pipe.',
        status: 'in_progress',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        assignedTo: 'Plumbing Team A',
        estimatedCost: 15000,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        issueId: issueId,
      ),
      WorkOrderModel(
        id: 'WO-1002',
        title: 'Road Surface Repair',
        description: 'After pipeline repair, repair the damaged road surface at the site of the leak.',
        status: 'created',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        assignedTo: 'Road Works Team B',
        estimatedCost: 8000,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        issueId: issueId,
      ),
    ];
  }
  
  Future<List<TimelineEntryModel>> getTimelineForIssue(String issueId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock timeline data
    final now = DateTime.now();
    return [
      TimelineEntryModel(
        id: 'TL-1',
        status: 'open',
        description: 'Issue reported by citizen',
        timestamp: now.subtract(const Duration(days: 3)),
      ),
      TimelineEntryModel(
        id: 'TL-2',
        status: 'assigned',
        description: 'Assigned to Water Department',
        timestamp: now.subtract(const Duration(days: 2, hours: 12)),
        updatedBy: 'System',
      ),
      TimelineEntryModel(
        id: 'TL-3',
        status: 'in_progress',
        description: 'Inspection team dispatched',
        timestamp: now.subtract(const Duration(days: 2)),
        updatedBy: 'Supervisor Ravi',
      ),
      TimelineEntryModel(
        id: 'TL-4',
        status: 'in_progress',
        description: 'Inspection completed. Work order created for pipe repair.',
        timestamp: now.subtract(const Duration(days: 1, hours: 6)),
        updatedBy: 'Inspector Suresh',
      ),
    ];
  }
  
  Future<List<WorkOrderModel>> createWorkOrder(WorkOrderModel workOrder) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    // In a real app, this would add the work order to the database
    // For now, return an updated list
    final currentWorkOrders = await getWorkOrdersForIssue(workOrder.issueId);
    return [...currentWorkOrders, workOrder];
  }
  
  Future<List<WorkOrderModel>> deleteWorkOrder(String issueId, String workOrderId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In a real app, this would remove the work order from the database
    // For now, return an updated list without the deleted work order
    final currentWorkOrders = await getWorkOrdersForIssue(issueId);
    return currentWorkOrders.where((wo) => wo.id != workOrderId).toList();
  }
  
  Future<List<TimelineEntryModel>> addCommentToIssue(
    String issueId, 
    String comment,
  ) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In a real app, this would add a comment to the database
    // For now, return an updated timeline with the new comment
    final currentTimeline = await getTimelineForIssue(issueId);
    
    final newEntry = TimelineEntryModel(
      id: 'TL-${currentTimeline.length + 1}',
      status: 'comment',
      description: comment,
      timestamp: DateTime.now(),
      updatedBy: 'Current Officer', // In a real app, this would be the logged-in user
    );
    
    return [...currentTimeline, newEntry];
  }
  
  Future<IssueModel> resolveIssue(String issueId, ResolutionModel resolution) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // In a real app, this would update the issue in the database
    // For now, return an updated issue object
    final issue = await getIssueById(issueId);
    
    return issue.copyWith(
      status: 'resolved',
      resolution: resolution,
    );
  }
  
  // Generate mock data for demonstration
  List<OfficerIssueModel> _generateMockIssues() {
    final now = DateTime.now();
    
    return List.generate(20, (index) {
      final issuePriorities = [
        IssuePriority.low, 
        IssuePriority.medium, 
        IssuePriority.high, 
        IssuePriority.critical
      ];
      
      final issueStatuses = [
        OfficerIssueStatus.open,
        OfficerIssueStatus.inProgress,
        OfficerIssueStatus.assigned,
        OfficerIssueStatus.resolved,
        OfficerIssueStatus.closed,
        OfficerIssueStatus.reopened,
      ];
      
      final issueCategories = [
        'Water Supply',
        'Electricity',
        'Roads',
        'Sanitation',
        'Public Safety',
      ];
      
      final random = index % issuePriorities.length;
      final statusRandom = index % issueStatuses.length;
      final categoryRandom = index % issueCategories.length;
      
      // Generate a date between today and 30 days ago
      final daysAgo = index % 30;
      final reportDate = now.subtract(Duration(days: daysAgo));
      
      // Generate SLA remaining (some overdue, some within SLA)
      final slaHours = (index % 3 == 0) ? -24 * (index % 5) : 24 * ((5 - index % 5));
      
      return OfficerIssueModel(
        id: 'ISSUE-${1000 + index}',
        title: 'Issue ${index + 1}: ${issueCategories[categoryRandom]} Problem',
        description: 'This is a detailed description of the ${issueCategories[categoryRandom]} issue that was reported.',
        category: issueCategories[categoryRandom],
        location: 'Location ${index + 1}, Ward ${(index % 10) + 1}',
        status: issueStatuses[statusRandom],
        priority: issuePriorities[random],
        dateReported: reportDate,
        lastUpdated: index % 2 == 0 ? reportDate.add(const Duration(days: 1)) : null,
        reportedBy: 'Citizen ${1000 + index}',
        assignedTo: index % 3 == 0 ? 'Officer ${100 + (index % 5)}' : null,
        slaRemaining: Duration(hours: slaHours),
        attachments: index % 4 == 0 ? ['photo_${index}_1.jpg', 'photo_${index}_2.jpg'] : null,
      );
    });
  }
}
