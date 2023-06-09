import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

class SubTopicsSelection extends StatefulWidget {
  final bool canChooseMoreThanOneSubTopic;
  const SubTopicsSelection({
    Key? key,
    required this.canChooseMoreThanOneSubTopic,
  }) : super(key: key);

  @override
  State<SubTopicsSelection> createState() => _SubTopicsSelectionState();
}

class _SubTopicsSelectionState extends State<SubTopicsSelection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.canChooseMoreThanOneSubTopic
                ? "Escolha até 3 tópicos"
                : "Escolha um tópico",
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
        ],
      ),
    );
  }
}
