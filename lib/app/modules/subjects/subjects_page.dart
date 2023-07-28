import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';
import 'package:innominatus_ai/app/modules/subjects/subjects_selection.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';
import 'package:innominatus_ai/app/shared/routes/args/study_plan_args.dart';
import 'package:innominatus_ai/app/shared/widgets/app_scaffold/app_scaffold.dart';
import 'package:innominatus_ai/app/shared/widgets/continue_floating_button.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../domain/usecases/chat/get_roadmap.dart';
import '../../shared/containers/subjects_container.dart';
import '../../shared/core/app_controller.dart';
import '../../shared/routes/args/subjects_page_args.dart';
import '../../shared/utils/route_utils.dart';

class SubjectsPage extends StatefulWidget {
  final SubjectsController controller;

  const SubjectsPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  SubjectsPageArgs? args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = RouteUtils.getArgs(context) as SubjectsPageArgs;
    fetchSubjects(args!.fieldOfStudy);
  }

  @override
  void dispose() {
    super.dispose();
    SubjectsContainer().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingButton: RxBuilder(
        builder: (_) => Visibility(
          visible: subjectsController.hasAnySubjectsSelected,
          child: ContinueFloatingButton(
            onTap: () {
              Navigator.popUntil(
                context,
                (route) => route.settings.name == AppRoutes.homePage,
              );
              Navigator.pushNamed(
                context,
                AppRoutes.studyPlan,
                arguments: StudyPlanPageArgs(
                  fieldOfStudy: args?.fieldOfStudy ?? '',
                  subjects: subjectsController.getChosenSubjects(
                    subjects: subjectsController.subjects$,
                    isChosenList: subjectsController.isSubjectsSelectedList,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: SubjectsSelection(
          subjectsController: widget.controller,
        ),
      ),
    );
  }

  SubjectsController get subjectsController => widget.controller;
  AppController get appController => subjectsController.appController;

  // UI Functions
  Future<void> fetchSubjects(String subject) async {
    final subjects = await appController
        .getSubjectsFromFieldOfStudyRoadmap(GetRoadmapParams(subject));
    if (subjects != null) {
      subjectsController.subjects$.addAll(subjects);
      for (var i = 0; i < subjectsController.subjects$.length; i++) {
        subjectsController.isSubjectsSelectedList.add(false);
      }
      subjectsController.endLoading();
    }
  }
}
