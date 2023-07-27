import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/domain/usecases/chat/get_roadmap.dart';
import 'package:innominatus_ai/app/modules/subtopics/controllers/sub_topics_controller.dart';
import 'package:innominatus_ai/app/shared/containers/subtopics_container.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/widgets/selection_card.dart';
import 'package:innominatus_ai/app/shared/widgets/shimmer_cards.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../shared/routes/args/subtopics_page_args.dart';
import '../../shared/themes/app_text_styles.dart';
import '../../shared/utils/route_utils.dart';

class SubTopicsSelection extends StatefulWidget {
  final SubTopicsController subTopicsController;
  const SubTopicsSelection({
    Key? key,
    required this.subTopicsController,
  }) : super(key: key);

  @override
  State<SubTopicsSelection> createState() => _SubTopicsSelectionState();
}

class _SubTopicsSelectionState extends State<SubTopicsSelection> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = RouteUtils.getArgs(context) as SubjectsPageArgs;
    fetchSubTopics(args.subject);
  }

  @override
  void dispose() {
    super.dispose();
    SubTopicsContainer().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Escolha um tópico",
            style: AppTextStyles.interVeryBig(
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: Text(
              'Você consegue selecionar um tópico ao tocar em cima dele',
              style: AppTextStyles.interSmall(),
            ),
          ),
          const SizedBox(height: 32),
          RxBuilder(
            builder: (context) => subTopicsController.isLoading$
                ? const ShimmerCards()
                : Column(
                    children: <Widget>[
                      for (int i = 0;
                          i < subTopicsController.subTopics$.length;
                          i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: InkWell(
                            onTap: () => setState(
                              () => subTopicsController
                                  .changeSubTopicsSelectedCard(i),
                            ),
                            child: SelectionCard(
                              isSemiBold: false,
                              title: subTopicsController.subTopics$[i],
                              isCardSelected:
                                  subTopicsController.isSubtopicSelectedList[i],
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

  SubTopicsController get subTopicsController => widget.subTopicsController;
  AppController get appController => subTopicsController.appController;

  // UI Functions
  Future<void> fetchSubTopics(String subject) async {
    final subjects = await appController
        .getSubtopicsFromSubjectRoadmap(GetRoadmapParams(subject));
    if (subjects != null) {
      subTopicsController.subTopics$.addAll(subjects);
      for (var i = 0; i < subTopicsController.subTopics$.length; i++) {
        subTopicsController.isSubtopicSelectedList.add(false);
      }
      subTopicsController.endLoading();
    }
  }
}
