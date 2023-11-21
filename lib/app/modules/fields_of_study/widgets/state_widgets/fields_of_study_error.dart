import 'package:flutter/material.dart';

import '../../../../shared/utils/language_utils.dart';

class FieldsOfStudyError extends StatelessWidget {
  const FieldsOfStudyError({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 32,
        left: 32,
      ),
      child: Text(
        LocalizationUtils.I(context).fieldsOfStudyErrorMessage,
      ),
    );
  }
}
