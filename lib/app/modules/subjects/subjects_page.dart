import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/states/subjects_states.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';
import 'package:innominatus_ai/app/modules/subjects/widgets/state_widgets/study_areas_selection.dart';
import 'package:innominatus_ai/app/modules/subjects/widgets/state_widgets/subjects_error.dart';
import 'package:innominatus_ai/app/modules/subjects/widgets/state_widgets/subjects_loading.dart';
import 'package:innominatus_ai/app/modules/subjects/widgets/state_widgets/topics_selection.dart';
import 'package:innominatus_ai/app/shared/widgets/app_scaffold/app_scaffold.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../shared/routes/args/subjects_page_args.dart';
import '../../shared/themes/app_color.dart';
import '../../shared/utils/route_utils.dart';

class SubjectsPage extends StatefulWidget {
  final SubjectsController subjectsController;
  const SubjectsPage({
    Key? key,
    required this.subjectsController,
  }) : super(key: key);

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late final SubjectsPageArgs args;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = RouteUtils.getArgs(context) as SubjectsPageArgs;
    if (args.studyArea != null) {
      controller.setToTopicsSelectionState();
    } else {
      controller.setToStudyAreaSelectionState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map mapBuilder = {
      const StudyAreasSelectionState().toString(): const StudyAreasSelection(),
      const TopicsSelectionState().toString(): TopicsSelection(
        canChooseMoreThanOneTopic: args.canChooseMoreThanOneTopic,
      ),
      const SubjectsPageLoadingState().toString(): const SubjectsLoading(),
      const SubjectsPageErrorState().toString(): const SubjectsError()
    };

    return WillPopScope(
      onWillPop: () async {
        if (controller.state is TopicsSelectionState) {
          controller.setToStudyAreaSelectionState();
          return false;
        }
        return true;
      },
      child: AppScaffold(
        floatingButton: SubjectFloatingButton(controller: controller),
        child: SingleChildScrollView(
          child: RxBuilder(
            builder: (_) => mapBuilder[controller.state.toString()],
          ),
        ),
      ),
    );
  }

  SubjectsController get controller => widget.subjectsController;
}

class SubjectFloatingButton extends StatelessWidget {
  final SubjectsController controller;
  const SubjectFloatingButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 64,
        right: 12,
      ),
      child: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          if (controller.state is StudyAreasSelectionState) {
            controller.setToTopicsSelectionState();
          }
        },
        child: const Icon(
          Icons.arrow_forward,
          color: AppColors.black,
        ),
      ),
    );
  }
}
