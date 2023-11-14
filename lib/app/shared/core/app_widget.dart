import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/shared/app_constants/app_constants.dart';
import 'package:innominatus_ai/app/shared/app_constants/localdb_constants.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';
import 'package:innominatus_ai/app/shared/routes/app_routing.dart';

import '../utils/validator_utils.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = GetIt.I.get<PrefsImpl>();
    final hasShowedSplashScreen = prefs.get(
      LocalDBConstants.hasShowedSplashScreen,
    );
    return MaterialApp(
      routes: AppRouting().routes(),
      initialRoute: hasShowedSplashScreen != null
          ? AppRoutes.homePage
          : AppRoutes.splashPage,
      debugShowCheckedModeBanner: false,
      locale: getLocale(context, AppLocalizations.supportedLocales),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

Locale? getLocale(BuildContext context, List<Locale> locales) {
  final String language = Localizations.localeOf(context).languageCode;
  if (ValidatorUtils.hasSupportedLanguage(language)) {
    return null;
  }
  return locales
      .where((e) => e.languageCode == LanguageConstants.english)
      .first;
}
