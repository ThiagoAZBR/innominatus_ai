import 'package:flutter/material.dart';

import 'package:innominatus_ai/app/modules/home/controllers/home_controller.dart';

import '../../../../shared/themes/app_text_styles.dart';
import '../../home_page.dart';

class HomeDefault extends StatelessWidget {
  final HomeController homeController;

  const HomeDefault({
    Key? key,
    required this.homeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 32,
            top: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
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
                      Text(
                        'É bom ter você aqui!',
                        style: AppTextStyles.interMedium(),
                      ),
                    ],
                  ),
                ],
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
                controller: homeController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
