import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/features/officer/data/repositories/officer_repository.dart';
import 'package:grampulse/features/officer/domain/models/issue_model.dart';
import 'package:grampulse/features/officer/presentation/bloc/incident_details/incident_details_bloc.dart';
import 'package:grampulse/features/officer/presentation/bloc/incident_details/incident_details_event.dart';
import 'package:grampulse/features/officer/presentation/screens/incident_details_screen.dart';
import 'package:grampulse/features/officer/presentation/screens/resolution_evidence_screen.dart';

class OfficerRoutes {
  static const String incidentDetails = '/officer/incident-details';
  static const String resolutionEvidence = '/officer/resolution-evidence';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case incidentDetails:
        final args = settings.arguments as Map<String, dynamic>;
        final issueId = args['issueId'] as String;
        
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => IncidentDetailsBloc(
              repository: context.read<OfficerRepository>(),
            )..add(LoadIncidentDetailsEvent(issueId)),
            child: const IncidentDetailsScreen(),
          ),
        );
        
      case resolutionEvidence:
        final args = settings.arguments as Map<String, dynamic>;
        final issue = args['issue'] as IssueModel;
        
        return MaterialPageRoute(
          builder: (context) => ResolutionEvidenceScreen(issue: issue),
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
