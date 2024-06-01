import 'package:json_dynamic_widget/json_dynamic_widget.dart';

/// Allows to define different dependency version resolving strategies.
/// For example in case of missing version it is possible to
/// define the logic of resolving latest one.
abstract class DependencyVersionResolver {
  Future<String> resolve(String name, String? version, BuildContext context);
}
