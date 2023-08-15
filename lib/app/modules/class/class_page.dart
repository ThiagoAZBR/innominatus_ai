import 'package:flutter/widgets.dart';
import 'package:innominatus_ai/app/modules/class/controllers/class_controller.dart';
import 'package:innominatus_ai/app/shared/routes/args/class_page_args.dart';
import 'package:innominatus_ai/app/shared/utils/route_utils.dart';
import 'package:innominatus_ai/app/shared/widgets/app_scaffold/app_scaffold.dart';

class ClassPage extends StatefulWidget {
  final ClassController controller;
  const ClassPage({super.key, required this.controller});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  ClassPageArgs? args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = RouteUtils.getArgs(context) as ClassPageArgs?;
    if (args != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: Text('Tela de Aula'),
    );
  }

  ClassController get controller => widget.controller;
}
