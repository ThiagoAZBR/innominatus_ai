import 'package:flutter/material.dart';

import '../../shared/widgets/app_scaffold/app_scaffold.dart';
import 'controllers/states/study_plan_states.dart';
import 'controllers/study_plan_controller.dart';
import 'widgets/states/study_plan_default.dart';
import 'widgets/states/study_plan_is_loading.dart';
import 'widgets/states/study_plan_with_error.dart';

class StudyPlanPage extends StatelessWidget {
  final StudyPlanController controller;
  const StudyPlanPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBuilder = {
      const StudyPlanIsLoadingState().toString(): const StudyPlanIsLoading(),
      const StudyPlanWithErrorState().toString(): const StudyPlanWithError(),
      const StudyPlanDefaultState().toString(): const StudyPlanDefault(),
    };

    return AppScaffold(
      child: SingleChildScrollView(
        child: mapBuilder[controller.state$.toString()],
      ),
    );
  }
}
