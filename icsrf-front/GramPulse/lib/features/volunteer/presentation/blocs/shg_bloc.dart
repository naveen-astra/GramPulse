import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class SHGEvent extends Equatable {
  const SHGEvent();

  @override
  List<Object> get props => [];
}

class LoadSHGDashboard extends SHGEvent {
  const LoadSHGDashboard();
}

class LoadSHGList extends SHGEvent {
  const LoadSHGList();
}

class SelectSHG extends SHGEvent {
  final String shgId;
  
  const SelectSHG(this.shgId);
  
  @override
  List<Object> get props => [shgId];
}

class LoadGovernmentSchemes extends SHGEvent {
  const LoadGovernmentSchemes();
}

class LoadCommunityDiscussions extends SHGEvent {
  final String shgId;
  
  const LoadCommunityDiscussions(this.shgId);
  
  @override
  List<Object> get props => [shgId];
}

class GuideToScheme extends SHGEvent {
  final String shgId;
  final String schemeId;
  
  const GuideToScheme(this.shgId, this.schemeId);
  
  @override
  List<Object> get props => [shgId, schemeId];
}

class VerifySchemeApplication extends SHGEvent {
  final String applicationId;
  
  const VerifySchemeApplication(this.applicationId);
  
  @override
  List<Object> get props => [applicationId];
}

// States
abstract class SHGState extends Equatable {
  const SHGState();

  @override
  List<Object> get props => [];
}

class SHGInitial extends SHGState {
  const SHGInitial();
}

class SHGLoading extends SHGState {
  const SHGLoading();
}

class SHGDashboardLoaded extends SHGState {
  final List<SelfHelpGroup> shgList;
  final List<GovernmentScheme> availableSchemes;
  final SHGStats stats;
  
  const SHGDashboardLoaded({
    required this.shgList,
    required this.availableSchemes,
    required this.stats,
  });
  
  @override
  List<Object> get props => [shgList, availableSchemes, stats];
}

class SHGDetailsLoaded extends SHGState {
  final SelfHelpGroup shg;
  final List<CommunityDiscussion> discussions;
  final List<GovernmentScheme> eligibleSchemes;
  
  const SHGDetailsLoaded({
    required this.shg,
    required this.discussions,
    required this.eligibleSchemes,
  });
  
  @override
  List<Object> get props => [shg, discussions, eligibleSchemes];
}

class SHGError extends SHGState {
  final String message;
  
  const SHGError(this.message);
  
  @override
  List<Object> get props => [message];
}

// Data Models
class SelfHelpGroup {
  final String id;
  final String name;
  final int memberCount;
  final double totalSavings;
  final DateTime formedDate;
  final String village;
  final List<SavingRecord> savingsHistory;
  final List<Activity> activities;
  final double participationRate;
  final String status;
  
  const SelfHelpGroup({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.totalSavings,
    required this.formedDate,
    required this.village,
    required this.savingsHistory,
    required this.activities,
    required this.participationRate,
    required this.status,
  });
}

class SavingRecord {
  final DateTime date;
  final double amount;
  final int membersContributed;
  
  const SavingRecord({
    required this.date,
    required this.amount,
    required this.membersContributed,
  });
}

class Activity {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final int participantCount;
  final String type; // meeting, training, loan_disbursement, etc.
  
  const Activity({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.participantCount,
    required this.type,
  });
}

class GovernmentScheme {
  final String id;
  final String name;
  final String description;
  final List<String> benefits;
  final List<String> eligibilityCriteria;
  final double maxLoanAmount;
  final double interestRate;
  final String applicationProcess;
  final DateTime deadline;
  final String category; // microfinance, skill_development, agriculture, etc.
  
  const GovernmentScheme({
    required this.id,
    required this.name,
    required this.description,
    required this.benefits,
    required this.eligibilityCriteria,
    required this.maxLoanAmount,
    required this.interestRate,
    required this.applicationProcess,
    required this.deadline,
    required this.category,
  });
}

class CommunityDiscussion {
  final String id;
  final String title;
  final String message;
  final String authorName;
  final DateTime timestamp;
  final int replies;
  final String category; // general, schemes, savings, concerns
  
  const CommunityDiscussion({
    required this.id,
    required this.title,
    required this.message,
    required this.authorName,
    required this.timestamp,
    required this.replies,
    required this.category,
  });
}

class SHGStats {
  final int totalSHGs;
  final int activeSHGs;
  final double totalSavings;
  final int schemesApplied;
  final int schemesApproved;
  final double averageParticipation;
  
  const SHGStats({
    required this.totalSHGs,
    required this.activeSHGs,
    required this.totalSavings,
    required this.schemesApplied,
    required this.schemesApproved,
    required this.averageParticipation,
  });
}

// BLoC
class SHGBloc extends Bloc<SHGEvent, SHGState> {
  SHGBloc() : super(const SHGInitial()) {
    on<LoadSHGDashboard>(_onLoadSHGDashboard);
    on<LoadSHGList>(_onLoadSHGList);
    on<SelectSHG>(_onSelectSHG);
    on<LoadGovernmentSchemes>(_onLoadGovernmentSchemes);
    on<LoadCommunityDiscussions>(_onLoadCommunityDiscussions);
    on<GuideToScheme>(_onGuideToScheme);
    on<VerifySchemeApplication>(_onVerifySchemeApplication);
  }

  Future<void> _onLoadSHGDashboard(LoadSHGDashboard event, Emitter<SHGState> emit) async {
    emit(const SHGLoading());
    
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock SHG data
      final shgList = [
        SelfHelpGroup(
          id: '1',
          name: 'Mahila Shakti Samuh',
          memberCount: 12,
          totalSavings: 45000.0,
          formedDate: DateTime(2022, 3, 15),
          village: 'Rampur',
          savingsHistory: [
            SavingRecord(date: DateTime.now().subtract(const Duration(days: 30)), amount: 3600.0, membersContributed: 12),
            SavingRecord(date: DateTime.now().subtract(const Duration(days: 60)), amount: 3400.0, membersContributed: 11),
            SavingRecord(date: DateTime.now().subtract(const Duration(days: 90)), amount: 3600.0, membersContributed: 12),
          ],
          activities: [
            Activity(
              id: '1',
              title: 'Monthly Savings Collection',
              date: DateTime.now().subtract(const Duration(days: 5)),
              description: 'Regular monthly savings collection and meeting',
              participantCount: 12,
              type: 'meeting',
            ),
            Activity(
              id: '2',
              title: 'Skill Development Training',
              date: DateTime.now().subtract(const Duration(days: 15)),
              description: 'Training on tailoring and handicrafts',
              participantCount: 10,
              type: 'training',
            ),
          ],
          participationRate: 91.7,
          status: 'Active',
        ),
        SelfHelpGroup(
          id: '2',
          name: 'Swayam Sahayata Samuh',
          memberCount: 15,
          totalSavings: 62000.0,
          formedDate: DateTime(2021, 8, 20),
          village: 'Krishnanagar',
          savingsHistory: [
            SavingRecord(date: DateTime.now().subtract(const Duration(days: 30)), amount: 4500.0, membersContributed: 15),
            SavingRecord(date: DateTime.now().subtract(const Duration(days: 60)), amount: 4200.0, membersContributed: 14),
            SavingRecord(date: DateTime.now().subtract(const Duration(days: 90)), amount: 4500.0, membersContributed: 15),
          ],
          activities: [
            Activity(
              id: '3',
              title: 'Microfinance Loan Meeting',
              date: DateTime.now().subtract(const Duration(days: 3)),
              description: 'Discussion about loan applications under PM SVANidhi',
              participantCount: 14,
              type: 'meeting',
            ),
          ],
          participationRate: 93.3,
          status: 'Active',
        ),
        SelfHelpGroup(
          id: '3',
          name: 'Gram Vikas Mandal',
          memberCount: 10,
          totalSavings: 28000.0,
          formedDate: DateTime(2023, 1, 10),
          village: 'Sundarpur',
          savingsHistory: [
            SavingRecord(date: DateTime.now().subtract(const Duration(days: 30)), amount: 2800.0, membersContributed: 10),
            SavingRecord(date: DateTime.now().subtract(const Duration(days: 60)), amount: 2600.0, membersContributed: 9),
          ],
          activities: [
            Activity(
              id: '4',
              title: 'Group Formation Training',
              date: DateTime.now().subtract(const Duration(days: 10)),
              description: 'Basic training on SHG operations and bookkeeping',
              participantCount: 10,
              type: 'training',
            ),
          ],
          participationRate: 85.0,
          status: 'New',
        ),
      ];
      
      final availableSchemes = [
        GovernmentScheme(
          id: '1',
          name: 'PM SVANidhi (Street Vendor Loan)',
          description: 'Micro-credit facility for street vendors and small businesses',
          benefits: [
            'Collateral-free loan up to ₹50,000',
            'Low interest rates',
            'Digital payment incentives',
            'Working capital support'
          ],
          eligibilityCriteria: [
            'Active SHG member for 6+ months',
            'Regular savings history',
            'Valid business activity proof',
            'Aadhaar and bank account'
          ],
          maxLoanAmount: 50000.0,
          interestRate: 7.0,
          applicationProcess: 'Apply through SHG coordinator or online portal',
          deadline: DateTime.now().add(const Duration(days: 45)),
          category: 'microfinance',
        ),
        GovernmentScheme(
          id: '2',
          name: 'Deendayal Antyodaya Yojana (DAY-NULM)',
          description: 'Skill development and livelihood enhancement for women',
          benefits: [
            'Free skill training programs',
            'Employment assistance',
            'Enterprise development support',
            'Financial literacy training'
          ],
          eligibilityCriteria: [
            'Women from BPL families',
            'Age 18-45 years',
            'SHG membership required',
            'Basic education preferred'
          ],
          maxLoanAmount: 100000.0,
          interestRate: 5.5,
          applicationProcess: 'Through Block Development Office',
          deadline: DateTime.now().add(const Duration(days: 60)),
          category: 'skill_development',
        ),
        GovernmentScheme(
          id: '3',
          name: 'Mahila Kisan Sashaktikaran Pariyojana (MKSP)',
          description: 'Women farmer empowerment and agricultural support',
          benefits: [
            'Agricultural training and tools',
            'Seed and fertilizer support',
            'Market linkage assistance',
            'Climate-resilient practices'
          ],
          eligibilityCriteria: [
            'Women engaged in agriculture',
            'Land ownership or cultivation rights',
            'SHG membership for 1+ year',
            'Participation in training programs'
          ],
          maxLoanAmount: 75000.0,
          interestRate: 4.0,
          applicationProcess: 'Through Agriculture Extension Officer',
          deadline: DateTime.now().add(const Duration(days: 30)),
          category: 'agriculture',
        ),
      ];
      
      final stats = const SHGStats(
        totalSHGs: 3,
        activeSHGs: 2,
        totalSavings: 135000.0,
        schemesApplied: 8,
        schemesApproved: 6,
        averageParticipation: 90.0,
      );
      
      emit(SHGDashboardLoaded(
        shgList: shgList,
        availableSchemes: availableSchemes,
        stats: stats,
      ));
    } catch (e) {
      emit(SHGError('Failed to load SHG dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onLoadSHGList(LoadSHGList event, Emitter<SHGState> emit) async {
    add(const LoadSHGDashboard());
  }

  Future<void> _onSelectSHG(SelectSHG event, Emitter<SHGState> emit) async {
    emit(const SHGLoading());
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Find the selected SHG from the current state
      if (state is SHGDashboardLoaded) {
        final currentState = state as SHGDashboardLoaded;
        final selectedSHG = currentState.shgList.firstWhere((shg) => shg.id == event.shgId);
        
        // Mock community discussions
        final discussions = [
          CommunityDiscussion(
            id: '1',
            title: 'Loan Application for Small Business',
            message: 'I want to apply for a loan to start a small tailoring business. Can someone guide me through the process?',
            authorName: 'Sunita Devi',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            replies: 3,
            category: 'schemes',
          ),
          CommunityDiscussion(
            id: '2',
            title: 'Monthly Savings Increase Proposal',
            message: 'Should we increase our monthly savings amount from ₹300 to ₹400? This will help us reach our group goals faster.',
            authorName: 'Kamala Singh',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            replies: 7,
            category: 'savings',
          ),
          CommunityDiscussion(
            id: '3',
            title: 'Training Session Feedback',
            message: 'The handicraft training was very helpful. When is the next session scheduled?',
            authorName: 'Meera Sharma',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            replies: 2,
            category: 'general',
          ),
        ];
        
        // Eligible schemes for this SHG
        final eligibleSchemes = currentState.availableSchemes;
        
        emit(SHGDetailsLoaded(
          shg: selectedSHG,
          discussions: discussions,
          eligibleSchemes: eligibleSchemes,
        ));
      }
    } catch (e) {
      emit(SHGError('Failed to load SHG details: ${e.toString()}'));
    }
  }

  Future<void> _onLoadGovernmentSchemes(LoadGovernmentSchemes event, Emitter<SHGState> emit) async {
    // Implementation for loading government schemes
  }

  Future<void> _onLoadCommunityDiscussions(LoadCommunityDiscussions event, Emitter<SHGState> emit) async {
    // Implementation for loading community discussions
  }

  Future<void> _onGuideToScheme(GuideToScheme event, Emitter<SHGState> emit) async {
    // Implementation for guiding SHG to a specific scheme
  }

  Future<void> _onVerifySchemeApplication(VerifySchemeApplication event, Emitter<SHGState> emit) async {
    // Implementation for verifying scheme applications
  }
}
