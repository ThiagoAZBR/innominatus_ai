import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/routes/args/study_plan_args.dart';
import 'package:innominatus_ai/app/shared/utils/route_utils.dart';

import '../../shared/widgets/app_scaffold/app_scaffold.dart';
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
  late final StudyPlanPageArgs args;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = RouteUtils.getArgs(context) as StudyPlanPageArgs;
  }

  @override
  Widget build(BuildContext context) {
    final mapBuilder = {
      const StudyPlanIsLoadingState().toString(): const StudyPlanIsLoading(),
      const StudyPlanWithErrorState().toString(): const StudyPlanWithError(),
      const StudyPlanDefaultState().toString(): const StudyPlanDefault(),
    };

    return AppScaffold(
      child: SingleChildScrollView(
        child: mapBuilder[widget.controller.state$.toString()],
      ),
    );
  }
}
