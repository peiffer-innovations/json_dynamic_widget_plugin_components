import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/json_dynamic_widget_plugin_components.dart';
import 'package:json_dynamic_widget_plugin_components/src/builder/json_component_builder.dart';

part 'json_components_plugin_registrar.g.dart';

@jsonWidgetRegistrar
abstract class _JsonComponentsPluginRegistrar {
  _JsonComponentsPluginRegistrar withLoader(DependencyLoader loader) {
    DependencyRegistry.instance.loader = loader;
    return this;
  }

  _JsonComponentsPluginRegistrar withVersionResolver(
      DependencyVersionResolver versionResolver) {
    DependencyRegistry.instance.versionResolver = versionResolver;
    return this;
  }
}
