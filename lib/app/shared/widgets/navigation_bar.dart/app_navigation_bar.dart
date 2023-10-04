import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:innominatus_ai/app/shared/app_constants/app_assets.dart';
import 'package:innominatus_ai/app/shared/containers/study_plan_container.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';
import 'package:rx_notifier/rx_notifier.dart';

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
        visible: showNavigationBar ?? appController.hasStudyPlan,
        child: NavigationBar(
          onDestinationSelected: (index) {
            final String? routeName = ModalRoute.of(context)?.settings.name;
            if (routeName != null) {
              if (routeName != AppRoutes.homePage) {
                Navigator.popUntil(
                  context,
                  (route) => route.settings.name == AppRoutes.homePage,
                );
              }
              _handleNavigation(index, appController.pageIndex);
              appController.pageIndex = index;
            }
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_rounded),
              label: 'Início',
            ),
            const NavigationDestination(
              icon: Icon(Icons.school_rounded),
              label: 'Plano de Estudos',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                AppAssets.chaosIOLogo,
                width: 32,
              ),
              label: 'Premium',
            ),
          ],
          selectedIndex: appController.pageIndex,
        ),
      ),
    );
  }
}

void _handleNavigation(int newIndex, int lastIndex) {
  if (lastIndex == 1 && newIndex != 1) {
    StudyPlanContainer().dispose();
  }
}
