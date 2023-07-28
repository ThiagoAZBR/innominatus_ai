import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/containers/study_plan_container.dart';
import 'package:innominatus_ai/app/shared/routes/args/study_plan_args.dart';
import 'package:innominatus_ai/app/shared/utils/route_utils.dart';
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
  late final StudyPlanPageArgs? args;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    args = RouteUtils.getArgs(context) as StudyPlanPageArgs;

    if (args == null) {
      final fieldsOfStudy = controller.recoverStudyPlan();

      if (fieldsOfStudy != null) {
        return controller.setDefaultState(fieldsOfStudy);
      }

      controller.setErrorState();
    }

    final studyPlan = await controller.saveStudyPlan(args!);
    controller.setDefaultState(studyPlan);
  }

  @override
  void dispose() {
    super.dispose();
    StudyPlanContainer().dispose();
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

    return AppScaffold(
      floatingButton: RxBuilder(
        builder: (_) => Visibility(
          visible: controller.hasAnySelectedCard(),
          child: ContinueFloatingButton(
            onTap: () {},
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: mapBuilder[controller.state$.toString()],
      ),
    );
  }

  StudyPlanController get controller => widget.controller;
}
