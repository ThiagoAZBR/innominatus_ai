import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/fields_of_study/controllers/fields_of_study_controller.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/widgets/add_personalized_content/add_new_content_confirmation.dart';
import 'package:innominatus_ai/app/shared/widgets/add_personalized_content/add_personalized_content.dart';
import 'package:innominatus_ai/app/shared/widgets/loading/shimmer_cards.dart';
import 'package:innominatus_ai/app/shared/widgets/selection_card.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../../shared/app_constants/app_constants.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/utils/language_utils.dart';
import '../../../../shared/utils/validator_utils.dart';

class FieldsOfStudySelection extends StatefulWidget {
  final FieldsOfStudyController fieldsOfStudyController;
  const FieldsOfStudySelection({
    Key? key,
    required this.fieldsOfStudyController,
  }) : super(key: key);

  @override
  State<FieldsOfStudySelection> createState() => _FieldsOfStudySelectionState();
}

class _FieldsOfStudySelectionState extends State<FieldsOfStudySelection> {
  bool isCardSelected = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (appController.languageCode.isEmpty) {
          String languageCode =
              // ignore: use_build_context_synchronously
              Localizations.localeOf(context).languageCode;

          if (ValidatorUtils.hasSupportedLanguage(languageCode)) {
            appController.languageCode = languageCode;
          } else {
            appController.languageCode = LanguageConstants.english;
          }
        }
        await widget.fieldsOfStudyController.getFieldsOfStudy();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RxBuilder(
              builder: (_) => Visibility(
                visible: fieldsOfStudyController.isFieldOfStudyPageLoading$,
                replacement: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      LocalizationUtils.I(context)
                          .fieldsOfStudyChooseFieldOfStudy,
                      style: AppTextStyles.interVeryBig(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                        top: 8,
                        bottom: 16,
                      ),
                      child: Text(
                        LocalizationUtils.I(context)
                            .fieldsOfStudyHowToChooseFieldOfStudy,
                        style: AppTextStyles.interSmall(),
                      ),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocalizationUtils.I(context).fieldsOfStudyLoadingMessage,
                      style: AppTextStyles.interBig(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Text(
                        LocalizationUtils.I(context)
                            .fieldsOfStudyLoadingMessageDescription,
                        style: AppTextStyles.interSmall(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ToDo: Add here the widget for personalized field of study
            RxBuilder(
              builder: (_) => Visibility(
                visible: !fieldsOfStudyController.isFieldOfStudyPageLoading$,
                replacement: const SizedBox(),
                child: AddPersonalizedContent(
                  onTap: () {
                    // ToDo: Create logic for saving local DB
                    FocusScope.of(context).unfocus();

                    final fieldOfStudyToBeAdded = fieldsOfStudyController
                        .personalizedFieldOfStudyTextController.text;

                    if (fieldOfStudyToBeAdded.isNotEmpty) {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => AddNewContentConfirmation(
                          contentToBeAdded: fieldOfStudyToBeAdded,
                          onTap: () {
                            // ToDo: Add function that deals with LocalDB
                            fieldsOfStudyController
                                .personalizedFieldOfStudyTextController
                                .clear();

                            Navigator.pop(context);
                          },
                        ),
                      );
                    }
                  },
                  textEditingController: fieldsOfStudyController
                      .personalizedFieldOfStudyTextController,
                  title: LocalizationUtils.I(context)
                      .appWidgetsAddPersonalizedFieldOfStudy,
                ),
              ),
            ),

            // Cards with Fields Of Study
            RxBuilder(
              builder: (context) => fieldsOfStudyController
                      .isFieldOfStudyPageLoading$
                  ? const ShimmerCards()
                  : Column(
                      children: [
                        for (int i = 0;
                            i < fieldsOfStudyController.fieldsOfStudy$.length;
                            i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: InkWell(
                              onTap: () => setState(
                                () => fieldsOfStudyController
                                    .changeFieldOfStudySelectedCard(i),
                              ),
                              child: SelectionCard(
                                title: fieldsOfStudyController
                                    .fieldsOfStudy$[i].name,
                                description: fieldsOfStudyController
                                    .fieldsOfStudy$[i].description,
                                isCardSelected: fieldsOfStudyController
                                    .isFieldOfStudySelectedList[i],
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  FieldsOfStudyController get fieldsOfStudyController =>
      widget.fieldsOfStudyController;
  AppController get appController =>
      widget.fieldsOfStudyController.appController;
}
