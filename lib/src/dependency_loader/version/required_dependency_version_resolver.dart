import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/src/dependency_loader/version/dependency_version_resolver.dart';

/// Ensures that version is always passed. 
class RequiredDependencyVersionResolver extends DependencyVersionResolver {
  RequiredDependencyVersionResolver();

  @override
  Future<String> resolve(String name, String? version, BuildContext context) {
    if (version == null || version.isEmpty) {
      throw Exception('Missing version for dependency: $name');
    }
    return Future.value(version);
  }
}
