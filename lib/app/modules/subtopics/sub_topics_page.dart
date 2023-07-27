import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/subtopics/controllers/sub_topics_controller.dart';
import 'package:innominatus_ai/app/modules/subtopics/sub_topics_selection.dart';
import 'package:innominatus_ai/app/shared/widgets/app_scaffold/app_scaffold.dart';
import 'package:innominatus_ai/app/shared/widgets/continue_floating_button.dart';
import 'package:rx_notifier/rx_notifier.dart';

class SubTopicsPage extends StatelessWidget {
  final SubTopicsController controller;

  const SubTopicsPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingButton: RxBuilder(
        builder: (_) => Visibility(
          visible: controller.hasAnySubtopicSelected,
          child: ContinueFloatingButton(onTap: () {}),
        ),
      ),
      child: SingleChildScrollView(
        child: SubTopicsSelection(
          subTopicsController: controller,
        ),
      ),
    );
  }
}