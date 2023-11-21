import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/classes/controllers/classes_controller.dart';
import 'package:innominatus_ai/app/shared/widgets/loading/shimmer_cards.dart';
import 'package:innominatus_ai/app/shared/widgets/selection_card.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../shared/themes/app_text_styles.dart';
import '../../../shared/utils/language_utils.dart';

class ClassesSelection extends StatefulWidget {
  final ClassesController controller;
  const ClassesSelection({super.key, required this.controller});

  @override
  State<ClassesSelection> createState() => _ClassesSelectionState();
}

class _ClassesSelectionState extends State<ClassesSelection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            LocalizationUtils.I(context).classesChooseYourClass,
            style: AppTextStyles.interVeryBig(
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: Text(
              LocalizationUtils.I(context).classesHowToChooseClass,
              style: AppTextStyles.interSmall(),
            ),
          ),
          const SizedBox(height: 32),
          RxBuilder(
            builder: (_) => controller.isClassesLoading$
                ? const ShimmerCards()
                : Column(
                    children: <Widget>[
                      for (int i = 0; i < generatedClasses.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: InkWell(
                            onTap: () => setState(
                              () => controller.changeSelectedClass(i),
                            ),
                            child: SelectionCard(
                              title: generatedClasses[i],
                              isSemiBold: false,
                              isCardSelected: controller.isSelectedClasses[i],
                            ),
                          ),
                        )
                    ],
                  ),
          )
        ],
      ),
    );
  }

  ClassesController get controller => widget.controller;
  RxList<String> get generatedClasses => widget.controller.generatedClasses;
}
