import 'package:json_dynamic_widget/json_dynamic_widget.dart';

abstract class DependencyVersionResolver {
  Future<String> resolve(String name, String? version, BuildContext context);
}
