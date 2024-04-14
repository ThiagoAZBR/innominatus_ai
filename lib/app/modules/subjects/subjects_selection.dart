import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/utils/language_utils.dart';
import 'package:innominatus_ai/app/shared/widgets/loading/shimmer_cards.dart';
import 'package:innominatus_ai/app/shared/widgets/selection_card.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../shared/themes/app_text_styles.dart';
import '../../shared/widgets/add_personalized_content/add_new_content_confirmation.dart';
import '../../shared/widgets/add_personalized_content/add_personalized_content.dart';

class SubjectsSelection extends StatefulWidget {
  final SubjectsController subjectsController;
  const SubjectsSelection({
    Key? key,
    required this.subjectsController,
  }) : super(key: key);

  @override
  State<SubjectsSelection> createState() => _SubjectsSelectionState();
}

class _SubjectsSelectionState extends State<SubjectsSelection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.subjectsChooseSubjects,
            style: AppTextStyles.interVeryBig(
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: Text(
              AppLocalizations.of(context)!.subjectsHowToChooseSubjects,
              style: AppTextStyles.interSmall(),
            ),
          ),
          RxBuilder(
            builder: (_) => Visibility(
              visible: !subjectsController.isLoading$,
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  AddPersonalizedContent(
                    title: LocalizationUtils.I(context)
                        .appWidgetsAddPersonalizedSubject,
                    textEditingController:
                        subjectsController.personalizedSubjectFieldController,
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      final subjectToBeAdded = subjectsController
                          .personalizedSubjectFieldController.text;
                      if (subjectToBeAdded.isNotEmpty) {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => AddNewContentConfirmation(
                            contentToBeAdded: subjectToBeAdded,
                            onTap: () {
                              subjectsController.updateSubjectsSelection(
                                subjectToBeAdded: subjectToBeAdded,
                                selectedFieldOfStudy:
                                    subjectsController.selectedFieldOfStudy,
                              );
                              subjectsController
                                  .personalizedSubjectFieldController
                                  .clear();

                              Navigator.pop(context);
                            },
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          RxBuilder(
            builder: (_) => subjectsController.isLoading$
                ? const ShimmerCards()
                : Column(
                    children: <Widget>[
                      for (int i = 0;
                          i < subjectsController.subjects$.length;
                          i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: InkWell(
                            onTap: () => setState(
                              () => subjectsController
                                  .changeSubjectsSelectedCard(i),
                            ),
                            child: SelectionCard(
                              isSemiBold: false,
                              title: subjectsController.subjects$[i],
                              isCardSelected:
                                  subjectsController.isSubjectsSelectedList[i],
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

  SubjectsController get subjectsController => widget.subjectsController;
  AppController get appController => subjectsController.appController;
}
