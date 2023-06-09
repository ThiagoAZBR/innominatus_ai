import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/states/subjects_states.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';
import 'package:innominatus_ai/app/modules/subjects/widgets/state_widgets/sub_topics_selection.dart';
import 'package:innominatus_ai/app/modules/subjects/widgets/state_widgets/subjects_error.dart';
import 'package:innominatus_ai/app/modules/subjects/widgets/state_widgets/subjects_loading.dart';
import 'package:innominatus_ai/app/modules/subjects/widgets/state_widgets/subjects_selection.dart';
import 'package:innominatus_ai/app/shared/containers/subjects_container.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';
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
    if (args.studyArea != null) {
      controller.setToSubTopicsSelectionState();
    } else {
      controller.setToStudyAreaSelectionState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map mapBuilder = {
      const SubjectsSelectionState().toString(): SubjectsSelection(
        subjectsController: controller,
      ),
      const SubTopicsSelectionState().toString(): SubTopicsSelection(
        canChooseMoreThanOneSubTopic: args.canChooseMoreThanOneSubTopic,
      ),
      const SubjectsPageLoadingState().toString(): const SubjectsLoading(),
      const SubjectsPageErrorState().toString(): const SubjectsError()
    };

    return WillPopScope(
      onWillPop: () async {
        if (controller.state$ is SubTopicsSelectionState) {
          controller.setToStudyAreaSelectionState();
          return false;
        }
        return true;
      },
      child: RxBuilder(
        builder: (_) => AppScaffold(
          floatingButton: Visibility(
            visible:
                controller.isFloatingButtonVisible(controller.state$).value,
            child: SubjectFloatingButton(
              controller: controller,
              context: context,
            ),
          ),
          child: SingleChildScrollView(
            child: mapBuilder[controller.state$.toString()],
          ),
        ),
      ),
    );
  }

  SubjectsController get controller => widget.subjectsController;
}

class SubjectFloatingButton extends StatelessWidget {
  final BuildContext context;
  final SubjectsController controller;

  const SubjectFloatingButton({
    Key? key,
    required this.context,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 64,
        right: 12,
      ),
      child: InkWell(
        onTap: () {
          if (controller.state$ is SubjectsSelectionState) {
            controller.setToSubTopicsSelectionState();
          }
          if (controller.state$ is SubTopicsSelectionState) {}
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppColors.secondary,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Continuar',
                style: AppTextStyles.interMedium(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
