import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:innominatus_ai/app/shared/core/app_widget.dart';
import 'package:innominatus_ai/app/shared/containers/app_container.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/study_plan_db.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/subjects_local_db.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/subjects_with_subtopics_local_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/shared/localDB/localdb_constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Create Instances for App
  await Hive.initFlutter();
  Hive.registerAdapter(SharedSubjectsLocalDBAdapter());
  Hive.registerAdapter(SharedSubjectItemLocalDBAdapter());
  Hive.registerAdapter(SubjectsWithSubtopicsLocalDBAdapter());
  Hive.registerAdapter(SubjectItemLocalDBAdapter());
  Hive.registerAdapter(StudyPlanLocalDBAdapter());
  // Hive Instances
  await Hive.openBox(LocalDBConstants.sharedFieldsOfStudy);
  await Hive.openBox(LocalDBConstants.subjectsWithSubtopics);
  await Hive.openBox(LocalDBConstants.studyPlan);
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton(sharedPreferences);

  AppContainer().setup();

  runApp(
    const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: AppWidget(),
    ),
  );
}
