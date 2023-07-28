import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/domain/models/subject_item.dart';
import 'package:innominatus_ai/app/modules/study_plan/controllers/states/study_plan_states.dart';
import 'package:innominatus_ai/app/modules/study_plan/controllers/study_plan_controller.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';
import 'package:innominatus_ai/app/shared/widgets/selection_card.dart';

class StudyPlanDefault extends StatelessWidget {
  final StudyPlanController controller;

  const StudyPlanDefault({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: state.fieldsOfStudyLocalDB!.items
              .map((e) => FieldOfStudyWidget(
                    fieldOfStudyItemModel: e,
                    controller: controller,
                  ))
              .toList(),
        ),
      ),
    );
  }

  StudyPlanDefaultState get state => controller.state$ as StudyPlanDefaultState;
}

class FieldOfStudyWidget extends StatefulWidget {
  final StudyPlanController controller;
  final FieldOfStudyItemModel fieldOfStudyItemModel;

  const FieldOfStudyWidget({
    Key? key,
    required this.controller,
    required this.fieldOfStudyItemModel,
  }) : super(key: key);

  @override
  State<FieldOfStudyWidget> createState() => _FieldOfStudyWidgetState();
}

class _FieldOfStudyWidgetState extends State<FieldOfStudyWidget> {
  @override
  void initState() {
    super.initState();
    controller.fillHasSubjectSelected(fieldOfStudyItemModel.subjects);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          widget.fieldOfStudyItemModel.name,
          style: AppTextStyles.interVeryBig(fontWeight: FontWeight.w500),
        ),
        for (int i = 0; i < widget.fieldOfStudyItemModel.subjects.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: InkWell(
              onTap: () => setState(() => controller.updateSelectionCard(i)),
              child: SelectionCard(
                isCardSelected: widget.controller.isSubjectSelectedList[i],
                title: widget.fieldOfStudyItemModel.subjects[i],
                isSemiBold: false,
              ),
            ),
          )
      ],
    );
  }

  StudyPlanController get controller => widget.controller;
  FieldOfStudyItemModel get fieldOfStudyItemModel =>
      widget.fieldOfStudyItemModel;
}
