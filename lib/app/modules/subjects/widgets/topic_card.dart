import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

import '../../../shared/themes/app_color.dart';

class SubjectCard extends StatefulWidget {
  final String subject;
  final String description;
  final bool isCardSelected;

  const SubjectCard({
    Key? key,
    required this.subject,
    required this.description,
    this.isCardSelected = false,
  }) : super(key: key);

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        border: widget.isCardSelected
            ? Border.all(
                color: AppColors.secondary,
                width: 1.5,
              )
            : null,
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
              widget.subject,
              style: AppTextStyles.interBig(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            Visibility(
              visible: isExpanded,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  widget.description,
                  style: AppTextStyles.interSmall(),
                ),
              ),
            ),
            InkWell(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Text(
                isExpanded ? 'Minimizar descrição' : 'Conhecer mais dessa área',
                style: AppTextStyles.interSmall(
                  color: AppColors.link,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
