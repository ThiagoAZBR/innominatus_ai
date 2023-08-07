import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/classes/controllers/classes_controller.dart';
import 'package:innominatus_ai/app/modules/classes/controllers/states/classes_state.dart';
import 'package:innominatus_ai/app/modules/classes/widgets/classes_error.dart';
import 'package:innominatus_ai/app/modules/classes/widgets/classes_selection.dart';
import 'package:innominatus_ai/app/shared/widgets/app_scaffold/app_scaffold.dart';
import 'package:rx_notifier/rx_notifier.dart';

class ClassesPage extends StatelessWidget {
  final ClassesController controller;

  const ClassesPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBuilder = {
      ClassesSelectionState().toString(): ClassesSelection(
        classesController: controller,
      ),
      ClassesErrorState().toString(): const ClassesError(),
    };

    return AppScaffold(
      child: SingleChildScrollView(
        child: RxBuilder(
          builder: (_) => mapBuilder[controller.state$.toString()]!,
        ),
      ),
    );
  }
}
