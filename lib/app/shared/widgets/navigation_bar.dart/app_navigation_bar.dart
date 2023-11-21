import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:innominatus_ai/app/shared/app_constants/app_assets.dart';
import 'package:innominatus_ai/app/shared/containers/study_plan_container.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';
import 'package:innominatus_ai/app/shared/themes/app_color.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../utils/language_utils.dart';

class AppNavigationBar extends StatelessWidget {
  final bool? showNavigationBar;
  final AppController appController;

  const AppNavigationBar({
    Key? key,
    this.showNavigationBar,
    required this.appController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RxBuilder(
      builder: (_) => Visibility(
        visible: _showNavigationBar(
          showNavigationBar,
          appController.hasStudyPlan,
        ),
        child: NavigationBar(
          onDestinationSelected: (index) {
            final String? routeName = ModalRoute.of(context)?.settings.name;
            if (routeName != null) {
              if (routeName != AppRoutes.homePage) {
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
                Navigator.popAndPushNamed(context, AppRoutes.homePage);
              }
              _handleNavigation(
                index,
                appController.pageIndex,
                routeName,
              );
              appController.pageIndex = index;
            }
          },
          destinations:
              getNavigationPages(appController.isUserPremium, context),
          selectedIndex: appController.pageIndex,
          backgroundColor: AppColors.primary,
          elevation: 3,
        ),
      ),
    );
  }
}

List<Widget> getNavigationPages(bool isUserPremium, BuildContext context) {
  return isUserPremium
      ? [
          NavigationDestination(
            icon: const Icon(Icons.home_rounded),
            label: LocalizationUtils.I(context).appWidgetsHomeIcon,
          ),
          NavigationDestination(
            icon: const Icon(Icons.school_rounded),
            label: LocalizationUtils.I(context).appWidgetsStudyPlanIcon,
          )
        ]
      : [
          NavigationDestination(
            icon: const Icon(Icons.home_rounded),
            label: LocalizationUtils.I(context).appWidgetsHomeIcon,
          ),
          NavigationDestination(
            icon: const Icon(Icons.school_rounded),
            label: LocalizationUtils.I(context).appWidgetsStudyPlanIcon,
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              AppAssets.chaosIOLogo,
              width: 32,
            ),
            label: LocalizationUtils.I(context).appWidgetsPremiumIcon,
          ),
        ];
}

void _handleNavigation(int newIndex, int lastIndex, String actualRoute) {
  if (actualRoute != AppRoutes.homePage) {
    StudyPlanContainer().dispose();
    return;
  }
  if (lastIndex == 1 && newIndex != 1) {
    StudyPlanContainer().dispose();
  }
}

bool _showNavigationBar(bool? showNavigationBar, bool hasStudyPlan) {
  if (showNavigationBar != null) {
    if (showNavigationBar) {
      return showNavigationBar;
    }
  }

  return hasStudyPlan;
}
