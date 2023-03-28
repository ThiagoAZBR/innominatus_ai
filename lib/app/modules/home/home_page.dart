import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/home/controllers/home_controller.dart';
import 'package:innominatus_ai/app/modules/home/widgets/cards/card_sugestion.dart';
import 'package:innominatus_ai/app/shared/miscellaneous/app_routes.dart';
import 'package:lottie/lottie.dart';
import 'package:rx_notifier/rx_notifier.dart';

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
              top: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Olá, Luna!',
                        style: AppTextStyles.interBig(
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
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 32,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    child: SizedBox(
                      height: 182,
                      child: RxBuilder(
                        builder: (_) => Stack(
                          children: [
                            PageView.builder(
                              controller: controller.pageController,
                              itemCount: pageViewChildren.length,
                              onPageChanged: (int index) =>
                                  controller.setPageCounter(index),
                              itemBuilder: (context, index) =>
                                  pageViewChildren[index],
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: pageViewChildren
                                    .map((page) => Padding(
                                          padding: const EdgeInsets.only(
                                            left: 4,
                                            bottom: 24,
                                          ),
                                          child: Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(1000),
                                              color: controller.pageCounter ==
                                                      pageViewChildren
                                                          .indexOf(page)
                                                  ? AppColors.lightBlack
                                                  : AppColors.lightWhite,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Sugestões',
                  style: AppTextStyles.interBig(),
                ),
                const SizedBox(height: 24),
                const SuggestionPlaceholders(),
                const SizedBox(height: 32),
                Text(
                  'Recursos',
                  style: AppTextStyles.interBig(),
                ),
                const SizedBox(height: 24),
                const SuggestionPlaceholders(),
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
              right: 32,
              bottom: 98,
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              tooltip: 'IA',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.chatPage);
              },
              child: Lottie.asset(
                "assets/data.json",
                height: 42,
                width: 42,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SuggestionPlaceholders extends StatelessWidget {
  const SuggestionPlaceholders({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: const <Widget>[
            CardSuggestion(suggestion: 'Lorem Ipsum Dolor'),
            SizedBox(width: 12),
            CardSuggestion(suggestion: 'Lorem Ipsum Dolor'),
          ],
        ),
      ],
    );
  }
}
