import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grampulse/firebase_options.dart';
import 'package:grampulse/app/app.dart';
import 'package:grampulse/core/presentation/theme/theme.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';
import 'package:grampulse/features/officer/data/repositories/officer_repository.dart';
import 'package:grampulse/features/officer/presentation/bloc/incident_inbox/incident_inbox_bloc.dart';
import 'package:grampulse/features/officer/presentation/screens/incident_inbox_screen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:grampulse/debug_firebase_test.dart';
// import 'package:grampulse/features/auth/utils/firebase_phone_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  
  // Register Hive adapters
  // TODO: Register Hive adapters here
  
  // Initialize Firebase safely with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      print('✅ Firebase already initialized, continuing...');
    } else {
      print('❌ Firebase initialization error: $e');
      rethrow;
    }
  }
  
  // Run Firebase debug tests
  // await FirebaseDebugTest.testFirebaseConfiguration();
  // await FirebasePhoneAuthTest.testPhoneAuthConfiguration();
  
  // Set status bar color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  
  // Use this for regular app flow
  runApp(const App());
  
  // Uncomment this to test the Officer Incident Inbox screen
  // runApp(const OfficerModuleApp());
}

class OfficerModuleApp extends StatelessWidget {
  const OfficerModuleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GramPulse - Officer Module',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('hi', ''), // Hindi
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: BlocProvider(
        create: (context) => IncidentInboxBloc(
          repository: OfficerRepository(),
        ),
        child: const IncidentInboxScreen(),
      ),
    );
  }
}
