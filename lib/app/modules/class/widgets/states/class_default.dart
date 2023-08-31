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
      padding: const EdgeInsets.fromLTRB(32, 32, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            state.className!,
            style: AppTextStyles.interHuge(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            state.classContent!,
            style: AppTextStyles.interSmall(lineHeight: 1.3),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  ClassDefaultState get state => controller.state as ClassDefaultState;
}
