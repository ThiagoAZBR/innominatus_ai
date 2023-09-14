import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/themes/app_color.dart';
import 'package:innominatus_ai/app/shared/widgets/loading/shimmer_cards.dart';
import 'package:innominatus_ai/app/shared/widgets/selection_card.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../shared/themes/app_text_styles.dart';

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
          AddPersonalizedSubject(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => AddNewSubjectConfirmation(
                  onTap: () {},
                ),
              );
            },
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
}

class AddPersonalizedSubject extends StatelessWidget {
  final VoidCallback onTap;
  const AddPersonalizedSubject({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextField(
          maxLines: 2,
          minLines: 1,
          style: AppTextStyles.interBig(),
          decoration: InputDecoration(
            hintText: ' Escreva uma disciplina...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: onTap,
              icon: const Icon(
                Icons.send_rounded,
                color: AppColors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddNewSubjectConfirmation extends StatelessWidget {
  final VoidCallback onTap;
  const AddNewSubjectConfirmation({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Confirme o nome da disciplina:',
            style: AppTextStyles.interBig(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Antropologia Cultural',
            style: AppTextStyles.interMedium(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              fixedSize: const Size(
                double.infinity,
                50,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                'Confirmar',
                style: AppTextStyles.interMedium(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              fixedSize: const Size(
                double.infinity,
                50,
              ),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.lightWhite),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                'Cancelar',
                style: AppTextStyles.interMedium(color: AppColors.lightBlack),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
