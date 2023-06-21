import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';
import 'package:innominatus_ai/app/shared/routes/args/subtopics_page_args.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../shared/containers/subjects_container.dart';
import '../../shared/routes/args/subjects_page_args.dart';
import '../../shared/utils/route_utils.dart';
import '../../shared/widgets/app_scaffold/app_scaffold.dart';
import '../../shared/widgets/continue_floating_button.dart';
import 'controllers/states/subjects_states.dart';
import 'controllers/subjects_controller.dart';
import 'widgets/state_widgets/subjects_error.dart';
import 'widgets/state_widgets/subjects_loading.dart';
import 'widgets/state_widgets/subjects_selection.dart';

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
  void dispose() {
    super.dispose();
    controller.resetSelectedCarts();
    controller.appController.subjects$.clear();
    SubjectsContainer().dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = RouteUtils.getArgs(context) as SubjectsPageArgs;

    controller.setToSubjectsSelectionState();
  }

  @override
  Widget build(BuildContext context) {
    final Map mapBuilder = {
      const SubjectsSelectionState().toString(): SubjectsSelection(
        subjectsController: controller,
      ),
      const SubjectsPageLoadingState().toString(): const SubjectsLoading(),
      const SubjectsPageErrorState().toString(): const SubjectsError()
    };

    return RxBuilder(
      builder: (_) => AppScaffold(
        floatingButton: Visibility(
          visible: controller.isFloatingButtonVisible(controller.state$).value,
          child: ContinueFloatingButton(
            onTap: () {
              if (controller.state$ is SubjectsSelectionState) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.subtopicsPage,
                  arguments: SubTopicsPageArgs(
                    subject: appController.subjects$[subjectItemIndex].subject,
                  ),
                );
              }
            },
          ),
        ),
        child: SingleChildScrollView(
          child: mapBuilder[controller.state$.toString()],
        ),
      ),
    );
  }

  SubjectsController get controller => widget.subjectsController;
  AppController get appController => controller.appController;
  int get subjectItemIndex => controller.isSubjectSelectedList.indexOf(true);
}
