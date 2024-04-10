import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/domain/models/subject_item.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../../../domain/models/field_of_study_item.dart';
import '../../../../../shared/app_constants/localdb_constants.dart';
import '../../../../../shared/localDB/adapters/fields_of_study_local_db.dart';
import '../../../../../shared/localDB/localdb_instances.dart';
import '../../../../../shared/routes/app_routes.dart';
import '../../../../../shared/routes/args/fields_of_study_page_args.dart';
import '../../../../../shared/themes/app_text_styles.dart';
import '../../../../../shared/widgets/selection_card.dart';
import '../../../controllers/study_plan_controller.dart';

class FieldOfStudyWidget extends StatelessWidget {
  final int fieldOfStudyIndex;
  final bool isEditing;
  final StudyPlanController controller;
  final FieldOfStudyItemModel fieldOfStudyItemModel;
  final RxList<List<bool>> isSubjectSelectedList;
  final bool hasAnyCardSelected;

  const FieldOfStudyWidget({
    Key? key,
    required this.fieldOfStudyIndex,
    required this.isEditing,
    required this.controller,
    required this.fieldOfStudyItemModel,
    required this.isSubjectSelectedList,
    required this.hasAnyCardSelected,
  }) : super(key: key);

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
              style: AppTextStyles.interBig(fontWeight: FontWeight.w500),
            ),
            Visibility(
              visible: isEditing,
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
                    controller.appController.hasStudyPlan = false;
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
        ...fieldOfStudyItemModel.allSubjects.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: InkWell(
              onTap: () {
                if (!isEditing) {
                  controller.updateSelectionCard(
                    subjectIndex: getSubjectIndex(e, allSubjects),
                    subject: fieldOfStudyItemModel
                        .allSubjects[getSubjectIndex(e, allSubjects)].name,
                    fieldOfStudyIndex: fieldOfStudyIndex,
                  );
                }
              },
              child: SelectionCard(
                isCardSelected: isThisCardSelected(
                      getSubjectIndex(e, allSubjects),
                    ) &&
                    hasAnyCardSelected,
                title: fieldOfStudyItemModel
                    .allSubjects[getSubjectIndex(e, allSubjects)].name,
                isSemiBold: false,
              ),
            ),
          ),
        )
      ],
    );
  }

  bool isThisCardSelected(int i) {
    bool isSelected = controller.isSubjectSelectedList[fieldOfStudyIndex][i];
    return isSelected;
  }

  int getSubjectIndex(SubjectItemModel e, List<String> allSubjects) {
    String name = e.name;
    int subjectIndex = allSubjects.indexOf(name);
    return subjectIndex;
  }

  List<String> get allSubjects =>
      fieldOfStudyItemModel.allSubjects.map((e) => e.name).toList();
}
