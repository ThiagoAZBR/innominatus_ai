import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/shared/app_constants/app_assets.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb_constants.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';

import '../../shared/routes/args/fields_of_study_page_args.dart';
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
          padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * 0.2,
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
                    Column(
                      children: <Widget>[
                        Text(
                          'Chaos IO',
                          style: AppTextStyles.interTiny(
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(
                          'Crie sua própria maneira de estudar através do Chaos',
                          style: AppTextStyles.interVeryBig(),
                          textAlign: TextAlign.center,
                        ),
                        Center(
                          child: SvgPicture.asset(
                            AppAssets.chaosIOLogo,
                            width: 250,
                            colorFilter: const ColorFilter.mode(
                              AppColors.link,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 64),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          fixedSize: Size(
                            MediaQuery.sizeOf(context).width * 0.60,
                            60,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          GetIt.I.get<PrefsImpl>().put(
                                LocalDBConstants.hasShowedSplashScreen,
                                false,
                              );
                          Navigator.popAndPushNamed(
                            context,
                            AppRoutes.fieldsOfStudyPage,
                            arguments: FieldsOfStudyPageArgs(
                              canChooseMoreThanOneFieldOfStudy: true,
                            ),
                          );
                        },
                        child: Text(
                          'Vamos Começar!',
                          style: AppTextStyles.interBig(
                            color: AppColors.primary,
                          ),
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
