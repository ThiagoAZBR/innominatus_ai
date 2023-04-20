import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb_constants.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';
import 'package:lottie/lottie.dart';

import '../../shared/themes/app_color.dart';
import '../../shared/themes/app_text_styles.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 142,
            right: 32,
            left: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Column(
                  children: <Widget>[
                    Lottie.asset(
                      "assets/data.json",
                      height: 300,
                      width: 300,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 32,
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Olá!',
                            style: AppTextStyles.interBig(),
                          ),
                          Text(
                            'Eu sou a Chaos, sua IA :)',
                            style: AppTextStyles.interBig(),
                          ),
                          const SizedBox(height: 58),
                          Text(
                            'Vamos começar!',
                            style: AppTextStyles.interBig(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: AppColors.primary,
                        onPressed: () {
                          GetIt.I.get<PrefsImpl>().put(
                                LocalDBConstants.hasShowedSplashScreen,
                                false,
                              );
                          Navigator.popAndPushNamed(
                            context,
                            AppRoutes.homePage,
                          );
                        },
                        child: const Icon(
                          Icons.arrow_forward,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
