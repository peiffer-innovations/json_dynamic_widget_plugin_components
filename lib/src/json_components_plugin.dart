import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/src/loaders/component_spec_loader.dart';

import 'builders/json_component_builder.dart';

class JsonComponentsPlugin {
  static void bind(JsonWidgetRegistry registry, ComponentSpecLoader loader) {
    ComponentSpecLoader.init(loader);
    const container = JsonWidgetBuilderContainer(
      builder: JsonComponentBuilder.fromDynamic,
      schemaId: ComponentSchema.id,
    );

    registry.registerCustomBuilder(JsonComponentBuilder.kType, container);
  }
}
