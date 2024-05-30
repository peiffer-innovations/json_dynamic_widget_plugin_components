import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/json_dynamic_widget_plugin_components.dart';

class MemoryDependencyLoader implements DependencyLoader {
  MemoryDependencyLoader({required this.dependencyData});

  Map<Dependency, String> dependencyData = {};

  @override
  Future<String?> load(Dependency dependency, BuildContext context) {
    if (dependencyData.containsKey(dependency)) {
      return Future.value(dependencyData[dependency]);
    }
    return Future.value(null);
  }
}
