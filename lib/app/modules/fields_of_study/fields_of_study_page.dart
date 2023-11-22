import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';
import 'package:innominatus_ai/app/shared/routes/args/subjects_page_args.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../shared/containers/fields_of_study_container.dart';
import '../../shared/routes/args/fields_of_study_page_args.dart';
import '../../shared/utils/route_utils.dart';
import '../../shared/widgets/app_scaffold/app_scaffold.dart';
import '../../shared/widgets/continue_floating_button.dart';
import 'controllers/fields_of_study_controller.dart';
import 'controllers/states/fields_of_study_states.dart';
import 'widgets/state_widgets/fields_of_study_error.dart';
import 'widgets/state_widgets/fields_of_study_loading.dart';
import 'widgets/state_widgets/fields_of_study_selection.dart';

class FieldsOfStudyPage extends StatefulWidget {
  final FieldsOfStudyController fieldsOfStudyController;
  const FieldsOfStudyPage({
    Key? key,
    required this.fieldsOfStudyController,
  }) : super(key: key);

  @override
  State<FieldsOfStudyPage> createState() => _FieldsOfStudyPageState();
}

class _FieldsOfStudyPageState extends State<FieldsOfStudyPage> {
  FieldsOfStudyPageArgs? args;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      args = RouteUtils.getArgs(context) as FieldsOfStudyPageArgs;
      controller.setToFieldsOfStudySelectionState();
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.resetSelectedCards();
    controller.appController.fieldsOfStudy$.clear();
    FieldsOfStudyContainer().dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map mapBuilder = {
      const FieldsOfStudySelectionState().toString(): FieldsOfStudySelection(
        fieldsOfStudyController: controller,
      ),
      const FieldsOfStudyLoadingState().toString():
          const FieldsOfStudyLoading(),
      const FieldsOfStudyErrorState().toString(): const FieldsOfStudyError()
    };

    return WillPopScope(
      onWillPop: () async {
        if (!Navigator.of(context).canPop()) {
          Navigator.popAndPushNamed(context, AppRoutes.homePage);
          return false;
        }
        return true;
      },
      child: RxBuilder(
        builder: (_) => AppScaffold(
          floatingButton: Visibility(
            visible:
                controller.isFloatingButtonVisible(controller.state$).value,
            child: ContinueFloatingButton(
              onTap: () {
                if (controller.state$ is FieldsOfStudySelectionState) {
                  final fieldOfStudySelected =
                      appController.fieldsOfStudy$[fieldOfStudyIndex].name;
                  FirebaseAnalytics.instance.logSelectContent(
                    contentType: 'Field of Study',
                    itemId: fieldOfStudySelected,
                  );
                  Navigator.pushNamed(
                    context,
                    AppRoutes.subjectsPage,
                    arguments: SubjectsPageArgs(
                      fieldOfStudy: fieldOfStudySelected,
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
      ),
    );
  }

  FieldsOfStudyController get controller => widget.fieldsOfStudyController;
  AppController get appController => controller.appController;
  int get fieldOfStudyIndex =>
      controller.isFieldOfStudySelectedList.indexOf(true);
}
