import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/src/models/component_template.dart';
import 'package:version/version.dart';

abstract class ComponentTemplateLoader {
  // Loads the component based on the JSON structure. In case of version being
  // null, the loader should return the latest version of the component.
  Future<ComponentTemplate> load(BuildContext context,
      JsonWidgetRegistry? registry, String componentName, Version? version);

  static ComponentTemplateLoader? _loader;

  // initializes the ComponentLoader instance
  static void init(ComponentTemplateLoader loader) {
    if (_loader != null) {
      throw Exception('ComponentJsonLoader already initialized');
    }
    _loader = loader;
  }

  // returns the ComponentLoader instance
  static ComponentTemplateLoader get() {
    if (_loader == null) {
      throw Exception('ComponentJsonLoader not initialized');
    }
    return _loader!;
  }
}
