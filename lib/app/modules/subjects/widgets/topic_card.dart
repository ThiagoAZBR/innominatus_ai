import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

import '../../../shared/themes/app_color.dart';

class SubjectCard extends StatefulWidget {
  final String topic;
  final String description;

  const SubjectCard({
    Key? key,
    required this.topic,
    required this.description,
  }) : super(key: key);

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  bool isCardExpanded = false;

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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Name of the Topic
            Text(
              widget.topic,
              style: AppTextStyles.interMedium(),
            ),
            const SizedBox(height: 32),
            // Description of Topic
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: decelerateEasing,
              child: isCardExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        widget.description,
                        style: AppTextStyles.interLittle(),
                      ),
                    )
                  : const SizedBox(),
            ),
            // View More or Less - Text Button
            InkWell(
              onTap: () => setState(
                () => isCardExpanded = !isCardExpanded,
              ),
              child: Visibility(
                visible: isCardExpanded,
                replacement: Text(
                  "Saber Mais",
                  style: AppTextStyles.interLittle(color: AppColors.link),
                ),
                child: Text(
                  "Ver menos",
                  style: AppTextStyles.interLittle(color: AppColors.link),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
