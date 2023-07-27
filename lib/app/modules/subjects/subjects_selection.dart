import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/domain/usecases/chat/get_roadmap.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';
import 'package:innominatus_ai/app/shared/containers/subjects_container.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/widgets/selection_card.dart';
import 'package:innominatus_ai/app/shared/widgets/shimmer_cards.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../shared/routes/args/subtopics_page_args.dart';
import '../../shared/themes/app_text_styles.dart';
import '../../shared/utils/route_utils.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = RouteUtils.getArgs(context) as SubjectsPageArgs;
    fetchSubjects(args.fieldOfStudy);
  }

  @override
  void dispose() {
    super.dispose();
    SubjectsContainer().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Escolha até 3 Disciplinas",
            style: AppTextStyles.interVeryBig(
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: Text(
              'Você consegue selecionar uma disciplina ao tocar em cima dela',
              style: AppTextStyles.interSmall(),
            ),
          ),
          const SizedBox(height: 32),
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

  // UI Functions
  Future<void> fetchSubjects(String subject) async {
    final subjects = await appController
        .getSubjectsFromFieldOfStudyRoadmap(GetRoadmapParams(subject));
    if (subjects != null) {
      subjectsController.subjects$.addAll(subjects);
      for (var i = 0; i < subjectsController.subjects$.length; i++) {
        subjectsController.isSubjectsSelectedList.add(false);
      }
      subjectsController.endLoading();
    }
  }
}
