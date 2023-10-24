import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/modules/home/controllers/home_controller.dart';
import 'package:innominatus_ai/app/modules/home/widgets/cards/card_action.dart';
import 'package:innominatus_ai/app/modules/home/widgets/states/home_default.dart';
import 'package:innominatus_ai/app/modules/home/widgets/states/home_loading.dart';
import 'package:innominatus_ai/app/modules/premium/controllers/premium_controller.dart';
import 'package:innominatus_ai/app/modules/premium/premium_page.dart';
import 'package:innominatus_ai/app/modules/study_plan/study_plan_page.dart';
import 'package:innominatus_ai/app/shared/containers/home_container.dart';
import 'package:innominatus_ai/app/shared/containers/premium_container.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';
import 'package:innominatus_ai/app/shared/routes/args/fields_of_study_page_args.dart';
import 'package:innominatus_ai/app/shared/widgets/app_dialog/app_dialog.dart';
import 'package:innominatus_ai/app/shared/widgets/navigation_bar.dart/app_navigation_bar.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/app_constants/app_assets.dart';
import '../../shared/containers/study_plan_container.dart';
import '../../shared/themes/app_color.dart';
import '../../shared/themes/app_text_styles.dart';
import '../study_plan/controllers/study_plan_controller.dart';

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

class HomePage extends StatefulWidget {
  final HomeController controller;
  const HomePage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    super.dispose();
    HomeContainer().dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        appController.hasStudyPlan = appController.fetchHasStudyPlan();
        await appController.checkUserPremiumStatus();
        appController.isAppUpdated = await appController.isAppVersionUpdated();
        appController.isHomeLoading = false;
        
        if (!appController.isAppUpdated) {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (_) => const AppDialog(
              title: 'Nova versão do Chaos IO disponível',
              content:
                  'Atualize o App para receber as últimas atualizações e funcionalidades',
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RxBuilder(
      builder: (_) => Visibility(
        visible: appController.isHomeLoading,
        replacement: Scaffold(
          bottomNavigationBar: AppNavigationBar(
            appController: widget.controller.appController,
          ),
          backgroundColor: AppColors.primary,
          body: <Widget>[
            HomeDefault(homeController: widget.controller),
            _handleStudyPlanPage(),
            _handlePremiumPage(),
          ][widget.controller.appController.pageIndex],
          floatingActionButton: Visibility(
            visible: widget.controller.appController.pageIndex == 0,
            child: SizedBox(
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
                              'Pergunte ao Chaos',
                              style: AppTextStyles.interSmall(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        child: const HomeLoading(),
      ),
    );
  }

  AppController get appController => widget.controller.appController;
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
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RxBuilder(
          builder: (_) => appController.isHomeLoading
              ? Padding(
                  padding: const EdgeInsets.only(right: 32, bottom: 32),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: double.infinity,
                      height: 220,
                    ),
                  ),
                )
              : Visibility(
                  visible: !appController.hasStudyPlan,
                  replacement: CardAction(
                    url: AppAssets.studyWoman,
                    title: 'Ver Plano de Estudos',
                    subtitle:
                        'Verifique seu plano de estudos! Sua área de estudo escolhida e disciplinas.',
                    onTap: () => appController.setPageToStudyPlan(),
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

Widget _handleStudyPlanPage() {
  final I = GetIt.I;

  if (!I.isRegistered<StudyPlanController>()) {
    StudyPlanContainer().setup();
  }

  return StudyPlanPage(
    controller: I.get<StudyPlanController>(),
  );
}

Widget _handlePremiumPage() {
  final I = GetIt.I;

  if (!I.isRegistered<PremiumController>()) {
    PremiumContainer().setup();
  }

  return PremiumPage(
    premiumController: I.get<PremiumController>(),
  );
}
