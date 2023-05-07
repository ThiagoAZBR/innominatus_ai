import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:innominatus_ai/app/core/app_widget.dart';
import 'package:innominatus_ai/app/core/containers/app_container.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/study_roadmap.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/subjects_local_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/core/text_constants/localdb_constants.dart';
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
  Hive.registerAdapter(StudyRoadmapAdapter());
  Hive.registerAdapter(SubTopicAdapter());
  Hive.registerAdapter(SubjectsLocalDBAdapter());
  Hive.registerAdapter(SubjectItemLocalDBAdapter());
  // Hive Instances
  await Hive.openBox(LocalDBConstants.studyRoadmap);
  await Hive.openBox(LocalDBConstants.subjects);
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
