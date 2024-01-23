import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/src/loaders/component_template_loader.dart';

import 'builders/json_components_builder.dart';

class JsonComponentsPlugin {
  static void bind(
      JsonWidgetRegistry registry, ComponentTemplateLoader loader) {
    ComponentTemplateLoader.init(loader);
    var container =
        JsonWidgetBuilderContainer(builder: JsonComponentBuilder.fromDynamic);

    registry.registerCustomBuilder('components', container);
  }
}
