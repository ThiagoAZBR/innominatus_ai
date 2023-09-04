import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/domain/models/field_of_study_item.dart';
import 'package:innominatus_ai/app/modules/study_plan/controllers/states/study_plan_states.dart';
import 'package:innominatus_ai/app/modules/study_plan/controllers/study_plan_controller.dart';
import 'package:innominatus_ai/app/shared/routes/args/fields_of_study_page_args.dart';
import 'package:innominatus_ai/app/shared/themes/app_color.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';
import 'package:innominatus_ai/app/shared/widgets/selection_card.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../../shared/localDB/adapters/fields_of_study_local_db.dart';
import '../../../../shared/localDB/localdb_constants.dart';
import '../../../../shared/localDB/localdb_instances.dart';
import '../../../../shared/routes/app_routes.dart';

class StudyPlanDefault extends StatefulWidget {
  final StudyPlanController controller;

  const StudyPlanDefault({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<StudyPlanDefault> createState() => _StudyPlanDefaultState();
}

class _StudyPlanDefaultState extends State<StudyPlanDefault> {
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (state.fieldsOfStudyLocalDB!.items.isEmpty) {
          Navigator.popAndPushNamed(
            context,
            AppRoutes.fieldsOfStudyPage,
            arguments: FieldsOfStudyPageArgs(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: RxBuilder(
          builder: (_) => Column(
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => setState(() => isEditing = !isEditing),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isEditing ? AppColors.link : AppColors.primary,
                  elevation: 0,
                  side: const BorderSide(
                    color: AppColors.link,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEditing ? 'Parar de Editar' : 'Editar',
                      style: AppTextStyles.interSmall(
                        color: isEditing ? AppColors.primary : AppColors.link,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.edit_outlined,
                      color: isEditing ? AppColors.primary : AppColors.link,
                      size: 16,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...state.fieldsOfStudyLocalDB!.items
                  .map((e) => FieldOfStudyWidget(
                        fieldOfStudyItemModel: e,
                        controller: widget.controller,
                        isEditing: isEditing,
                      ))
            ],
          ),
        ),
      ),
    );
  }

  StudyPlanDefaultState get state =>
      widget.controller.state$ as StudyPlanDefaultState;
}

class FieldOfStudyWidget extends StatefulWidget {
  final StudyPlanController controller;
  final FieldOfStudyItemModel fieldOfStudyItemModel;
  final bool isEditing;

  const FieldOfStudyWidget({
    Key? key,
    required this.controller,
    required this.fieldOfStudyItemModel,
    required this.isEditing,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              fieldOfStudyItemModel.name,
              style: AppTextStyles.interVeryBig(fontWeight: FontWeight.w500),
            ),
            Visibility(
              visible: widget.isEditing,
              child: IconButton(
                onPressed: () async {
                  final studyPlanBox = HiveBoxInstances.studyPlan;

                  FieldsOfStudyLocalDB? studyPlan = studyPlanBox.get(
                    LocalDBConstants.studyPlan,
                  );

                  final index = studyPlan!.items.indexWhere(
                    (e) =>
                        e.name.toLowerCase() ==
                        fieldOfStudyItemModel.name.toLowerCase(),
                  );

                  studyPlan.items.removeAt(index);

                  await studyPlanBox.put(
                    LocalDBConstants.studyPlan,
                    studyPlan,
                  );

                  if (studyPlan.items.isEmpty) {
                    // ignore: use_build_context_synchronously
                    Navigator.popAndPushNamed(
                      context,
                      AppRoutes.fieldsOfStudyPage,
                      arguments: FieldsOfStudyPageArgs(),
                    );
                    return;
                  }

                  controller.setDefaultState(studyPlan);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
            )
          ],
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
