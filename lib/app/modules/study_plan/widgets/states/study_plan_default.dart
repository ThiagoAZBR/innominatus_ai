import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/domain/models/field_of_study_item.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecione uma disciplina para acessar suas aulas',
              style: AppTextStyles.interVeryBig(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Você consegue selecionar uma disciplina ao tocar em cima dela',
              style: AppTextStyles.interSmall(),
            ),
            const SizedBox(height: 32),
            ...state.fieldsOfStudyLocalDB!.items.map((e) => FieldOfStudyWidget(
                  fieldOfStudyItemModel: e,
                  controller: controller,
                ))
          ],
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
    controller.setQuantityOfSubjects(
      fieldOfStudyItemModel.subjects.map((e) => e.name).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          fieldOfStudyItemModel.name,
          style: AppTextStyles.interVeryBig(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        for (int i = 0; i < fieldOfStudyItemModel.subjects.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: InkWell(
              onTap: () => setState(() => controller.updateSelectionCard(
                    i,
                    fieldOfStudyItemModel.subjects[i].name,
                  )),
              child: SelectionCard(
                isCardSelected: controller.isSubjectSelectedList[i],
                title: fieldOfStudyItemModel.subjects[i].name,
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
