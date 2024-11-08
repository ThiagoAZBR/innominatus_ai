import 'package:flutter/material.dart';

class SubjectsError extends StatelessWidget {
  const SubjectsError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        top: 32,
        left: 32,
      ),
      child: Text(
          'Ocorreu um erro ao tentar mostrar os conteúdos, tente novamente.'),
    );
  }
}
