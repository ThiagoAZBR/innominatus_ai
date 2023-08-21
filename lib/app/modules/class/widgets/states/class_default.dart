import 'package:flutter/widgets.dart';
import 'package:innominatus_ai/app/modules/class/controllers/class_controller.dart';
import 'package:innominatus_ai/app/modules/class/controllers/states/class_states.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

class ClassDefault extends StatelessWidget {
  final ClassController controller;
  const ClassDefault({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: <Widget>[
          Text(
            state.classContent!,
            style: AppTextStyles.interMedium(),
          ),
        ],
      ),
    );
  }

  ClassDefaultState get state => controller.state as ClassDefaultState;
}
