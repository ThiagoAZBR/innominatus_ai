import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';
import 'package:innominatus_ai/app/shared/routes/args/classes_page_args.dart';
import 'package:innominatus_ai/app/shared/routes/args/study_plan_args.dart';
import 'package:innominatus_ai/app/shared/utils/route_utils.dart';
import 'package:innominatus_ai/app/shared/widgets/navigation_bar.dart/app_navigation_bar.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../shared/widgets/app_scaffold/app_scaffold.dart';
import '../../shared/widgets/continue_floating_button.dart';
import 'controllers/states/study_plan_states.dart';
import 'controllers/study_plan_controller.dart';
import 'widgets/states/study_plan_default.dart';
import 'widgets/states/study_plan_is_loading.dart';
import 'widgets/states/study_plan_with_error.dart';

class StudyPlanPage extends StatefulWidget {
  final StudyPlanController controller;
  const StudyPlanPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<StudyPlanPage> createState() => _StudyPlanPageState();
}

class _StudyPlanPageState extends State<StudyPlanPage> {
  StudyPlanPageArgs? args;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      args = RouteUtils.getArgs(context) as StudyPlanPageArgs?;

      if (args == null) {
        final fieldsOfStudy = controller.recoverStudyPlan();

        if (fieldsOfStudy != null) {
          return controller.setDefaultState(fieldsOfStudy);
        }

        return controller.setErrorState();
      }

      final studyPlan = await controller.saveStudyPlan(args!);
      await controller.appController.checkUserPremiumStatus();
      controller.setDefaultState(studyPlan);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapBuilder = {
      const StudyPlanIsLoadingState().toString(): const StudyPlanIsLoading(),
      const StudyPlanWithErrorState().toString(): const StudyPlanWithError(),
      const StudyPlanDefaultState().toString(): StudyPlanDefault(
        controller: controller,
      ),
    };

    return WillPopScope(
      onWillPop: () async {
        if (!controller.appController.hasStudyPlan) {
          controller.appController.hasStudyPlan = true;
        } else {
          return false;
        }
        if (!Navigator.of(context).canPop()) {
          Navigator.popAndPushNamed(context, AppRoutes.homePage);
          return false;
        }
        return true;
      },
      child: RxBuilder(
        builder: (_) => AppScaffold(
          bottomNavigationBar: Visibility(
            visible: args != null,
            child: AppNavigationBar(
              appController: controller.appController,
              showNavigationBar: args != null,
            ),
          ),
          floatingButton: Visibility(
            visible: controller.hasAnySelectedCard,
            child: ContinueFloatingButton(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.classesPage,
                  arguments: ClassesPageArgs(
                    selectedSubject: controller.selectedSubject!,
                    selectedFieldOfStudy: controller.selectedFieldOfStudy!,
                  ),
                );
              },
            ),
          ),
          child: SingleChildScrollView(
            child: mapBuilder[controller.state$.toString()],
          ),
        ),
      ),
    );
  }

  StudyPlanController get controller => widget.controller;
}
