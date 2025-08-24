enum OfficerIssueStatus {
  pending,
  assigned,
  inProgress,
  resolved,
  rejected,
  cancelled,
  reopened,
}

extension OfficerIssueStatusExtension on OfficerIssueStatus {
  String toStringValue() {
    switch (this) {
      case OfficerIssueStatus.pending:
        return 'pending';
      case OfficerIssueStatus.assigned:
        return 'assigned';
      case OfficerIssueStatus.inProgress:
        return 'in_progress';
      case OfficerIssueStatus.resolved:
        return 'resolved';
      case OfficerIssueStatus.rejected:
        return 'rejected';
      case OfficerIssueStatus.cancelled:
        return 'cancelled';
      case OfficerIssueStatus.reopened:
        return 'reopened';
    }
  }
  
  static OfficerIssueStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OfficerIssueStatus.pending;
      case 'assigned':
        return OfficerIssueStatus.assigned;
      case 'in_progress':
        return OfficerIssueStatus.inProgress;
      case 'resolved':
        return OfficerIssueStatus.resolved;
      case 'rejected':
        return OfficerIssueStatus.rejected;
      case 'cancelled':
        return OfficerIssueStatus.cancelled;
      case 'reopened':
        return OfficerIssueStatus.reopened;
      default:
        return OfficerIssueStatus.pending;
    }
  }
}
