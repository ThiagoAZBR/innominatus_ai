import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:innominatus_ai/app/shared/app_constants/app_constants.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/shared/containers/app_container.dart';
import 'app/shared/core/app_widget.dart';
import 'app/shared/localDB/adapters/fields_of_study_local_db.dart';
import 'app/shared/localDB/adapters/shared_fields_of_study_local_db.dart';
import 'app/shared/localDB/localdb_constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // TODO: Update setup with IOS, when possible
  await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.info);
  final configuration = PurchasesConfiguration(AppConstants.revenueCatApiKey);
  await Purchases.configure(configuration);

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
  Hive.registerAdapter(SharedFieldsOfStudyLocalDBAdapter());
  Hive.registerAdapter(SharedFieldOfStudyItemLocalDBAdapter());
  Hive.registerAdapter(FieldsOfStudyLocalDBAdapter());
  Hive.registerAdapter(FieldOfStudyItemLocalDBAdapter());
  Hive.registerAdapter(SubjectItemLocalDBAdapter());
  Hive.registerAdapter(ClassItemLocalDBAdapter());
  // Hive Instances
  await Hive.openBox<SharedFieldsOfStudyLocalDB>(
    LocalDBConstants.sharedFieldsOfStudy,
  );
  await Hive.openBox<FieldsOfStudyLocalDB>(
    LocalDBConstants.fieldsOfStudy,
  );
  await Hive.openBox<FieldsOfStudyLocalDB>(
    LocalDBConstants.studyPlan,
  );
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
