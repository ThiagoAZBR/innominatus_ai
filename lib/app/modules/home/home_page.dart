import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/home/controllers/home_controller.dart';
import 'package:innominatus_ai/app/modules/home/widgets/cards/card_action.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';
import 'package:innominatus_ai/app/shared/routes/args/fields_of_study_page_args.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../shared/app_constants/app_assets.dart';
import '../../shared/themes/app_color.dart';
import '../../shared/themes/app_text_styles.dart';

final List<Widget> pageViewChildren = [
  Container(
    height: 182,
    decoration: const BoxDecoration(
      color: AppColors.secondary,
    ),
  ),
  Container(
    height: 182,
    decoration: const BoxDecoration(
      color: AppColors.black,
    ),
  ),
];

class HomePage extends StatelessWidget {
  final HomeController controller;
  const HomePage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 32,
              top: 48,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Visibility(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: Text(
                        'Olá!',
                        style: AppTextStyles.interVeryBig(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  'É bom ter você aqui!',
                  style: AppTextStyles.interMedium(),
                ),
                // const SizedBox(height: 32),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     right: 32,
                //   ),
                //   child: ClipRRect(
                //     borderRadius: const BorderRadius.all(
                //       Radius.circular(12),
                //     ),
                //     child: SizedBox(
                //       height: 182,
                //       child: RxBuilder(
                //         builder: (_) => Stack(
                //           children: [
                //             PageView.builder(
                //               controller: controller.pageController,
                //               itemCount: pageViewChildren.length,
                //               onPageChanged: (int index) =>
                //                   controller.setPageCounter(index),
                //               itemBuilder: (context, index) =>
                //                   pageViewChildren[index],
                //             ),
                //             Align(
                //               alignment: Alignment.bottomCenter,
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: pageViewChildren
                //                     .map(
                //                       (page) => Padding(
                //                         padding: const EdgeInsets.only(
                //                           left: 4,
                //                           bottom: 24,
                //                         ),
                //                         child: Container(
                //                           height: 10,
                //                           width: 10,
                //                           decoration: BoxDecoration(
                //                             borderRadius:
                //                                 BorderRadius.circular(1000),
                //                             color:
                //                                 controller.slideBannerCounter ==
                //                                         pageViewChildren
                //                                             .indexOf(page)
                //                                     ? AppColors.lightBlack
                //                                     : AppColors.lightWhite,
                //                           ),
                //                         ),
                //                       ),
                //                     )
                //                     .toList(),
                //               ),
                //             )
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 36),
                SuggestionPlaceholders(
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: MediaQuery.of(context).size.height * 0.94,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 24,
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.chatPage);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.chat,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pergunte a Chaos',
                        style:
                            AppTextStyles.interSmall(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SuggestionPlaceholders extends StatefulWidget {
  final HomeController controller;

  const SuggestionPlaceholders({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<SuggestionPlaceholders> createState() => _SuggestionPlaceholdersState();
}

class _SuggestionPlaceholdersState extends State<SuggestionPlaceholders> {
  @override
  void initState() {
    super.initState();
    appController.hasStudyPlan = appController.fetchHasStudyPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RxBuilder(
          builder: (_) => Visibility(
            visible: !appController.hasStudyPlan,
            replacement: CardAction(
              url: AppAssets.studyWoman,
              title: 'Ver Plano de Estudos',
              subtitle:
                  'Verifique seu plano de estudos! Sua área de estudo escolhida e disciplinas.',
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.studyPlanPage,
              ),
            ),
            child: CardAction(
              url: AppAssets.studyMan,
              title: 'Iniciar estudos',
              subtitle:
                  'Aqui você irá escolher o que deseja aprender e dar o pontapé inicial nos seus estudos!',
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.fieldsOfStudyPage,
                arguments: FieldsOfStudyPageArgs(
                  canChooseMoreThanOneFieldOfStudy: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  HomeController get homeController => widget.controller;
  AppController get appController => widget.controller.appController;
}
