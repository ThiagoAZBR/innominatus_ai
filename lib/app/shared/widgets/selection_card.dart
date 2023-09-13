import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

import '../themes/app_color.dart';

class SelectionCard extends StatefulWidget {
  final String title;
  final String? description;
  final bool isSemiBold;
  final bool isCardSelected;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final bool hasBoxShadow;
  final MainAxisAlignment textAlign;
  final bool hasIcon;
  final IconData icon;
  final Color iconColor;

  const SelectionCard({
    Key? key,
    required this.title,
    this.description,
    this.isSemiBold = true,
    this.isCardSelected = false,
    this.backgroundColor = AppColors.primary,
    this.borderColor = AppColors.secondary,
    this.textColor = AppColors.textColor,
    this.hasBoxShadow = true,
    this.textAlign = MainAxisAlignment.start,
    this.hasIcon = false,
    this.icon = Icons.add_outlined,
    this.iconColor = AppColors.link,
  }) : super(key: key);

  @override
  State<SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<SelectionCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: widget.isCardSelected
            ? Border.all(
                color: widget.borderColor,
                width: 1.5,
              )
            : null,
        boxShadow: widget.hasBoxShadow
            ? [
                BoxShadow(
                  color: AppColors.shadow,
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Name of the Topic
            Row(
              mainAxisAlignment: widget.textAlign,
              children: [
                Flexible(
                  child: Text(
                    widget.title,
                    style: AppTextStyles.interBig(
                      color: widget.textColor,
                      fontWeight: widget.isSemiBold
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.hasIcon,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      widget.icon,
                      color: widget.iconColor,
                    ),
                  ),
                )
              ],
            ),
            Visibility(
              visible: widget.description != null,
              child: const SizedBox(height: 24),
            ),
            widget.description != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        visible: isExpanded,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            widget.description!,
                            style: AppTextStyles.interSmall(),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => isExpanded = !isExpanded),
                        child: Text(
                          isExpanded
                              ? 'Minimizar descrição'
                              : 'Conhecer mais dessa área',
                          style: AppTextStyles.interSmall(
                            color: AppColors.link,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
