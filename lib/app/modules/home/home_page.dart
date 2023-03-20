import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/home/widgets/cards/card_sugestion.dart';
import 'package:innominatus_ai/app/shared/miscellaneous/app_routes.dart';
import 'package:lottie/lottie.dart';

import '../../app_controller.dart';
import '../../shared/themes/app_color.dart';
import '../../shared/themes/app_text_styles.dart';

class HomePage extends StatelessWidget {
  final AppController appController;
  const HomePage({
    Key? key,
    required this.appController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 32,
              top: 24,
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundItems,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Boas-Vindas!',
                      style: AppTextStyles.interVeryBig(),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 142,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.58,
                            height: 142,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundItems,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.58,
                            height: 142,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundItems,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
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
                SizedBox(
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
              ],
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
        const SizedBox(height: 24),
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
