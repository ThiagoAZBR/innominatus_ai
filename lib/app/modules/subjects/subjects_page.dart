import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';
import 'package:innominatus_ai/app/modules/subjects/subjects_selection.dart';
import 'package:innominatus_ai/app/shared/widgets/app_scaffold/app_scaffold.dart';
import 'package:innominatus_ai/app/shared/widgets/continue_floating_button.dart';
import 'package:rx_notifier/rx_notifier.dart';

class SubjectsPage extends StatelessWidget {
  final SubjectsController controller;

  const SubjectsPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingButton: RxBuilder(
        builder: (_) => Visibility(
          visible: controller.hasAnySubjectsSelected,
          child: ContinueFloatingButton(onTap: () {}),
        ),
      ),
      child: SingleChildScrollView(
        child: SubjectsSelection(
          subjectsController: controller,
        ),
      ),
    );
  }
}
