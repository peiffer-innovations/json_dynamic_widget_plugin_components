import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/src/models/json_component_spec.dart';
import 'package:version/version.dart';

abstract class ComponentSpecLoader {
  static ComponentSpecLoader? _loader;

  // Loads the component specification based on the JSON structure. In case of version being
  // null, the loader should return the latest version of the component.
  Future<ComponentSpec> load(BuildContext context, JsonWidgetRegistry? registry,
      String componentName, Version? version);

  // returns the ComponentLoader instance
  static ComponentSpecLoader get() {
    if (_loader == null) {
      throw Exception('ComponentSpecLoader not initialized');
    }
    return _loader!;
  }

  // initializes the ComponentLoader instance
  static void init(ComponentSpecLoader loader) {
    if (_loader != null) {
      throw Exception('ComponentSpecLoader already initialized');
    }
    _loader = loader;
  }
}
