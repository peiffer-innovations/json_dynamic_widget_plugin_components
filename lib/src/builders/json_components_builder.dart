import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:version/version.dart';
import '../loaders/component_template_loader.dart';

/// Loads the component based on the JSON structure.
class JsonComponentBuilder extends JsonWidgetBuilder {
  const JsonComponentBuilder({
    required super.args,
    required this.name,
    required this.values,
    this.version,
    this.callerRegistry,
  });

  final JsonWidgetRegistry? callerRegistry;
  final String name;
  final Version? version;
  final Map<String, dynamic> values;

  @override
  JsonWidgetBuilderModel createModel({
    ChildWidgetBuilder? childBuilder,
    required JsonWidgetData data,
  }) =>
      throw UnsupportedError(
        'The components widget is too complex to support auto-encoding',
      );

  @override
  Widget buildCustom({
    ChildWidgetBuilder? childBuilder,
    required BuildContext context,
    required JsonWidgetData data,
    Key? key,
  }) {
    final callerRegistry = this.callerRegistry ?? JsonWidgetRegistry.instance;
    return _Component(
      name: name,
      version: version,
      values: values,
      callerRegistry: callerRegistry,
      componentRegistry: callerRegistry.copyWith(values: {}),
    );
  }

  static JsonComponentBuilder fromDynamic(
    dynamic map, {
    JsonWidgetRegistry? registry,
  }) {
    final result = maybeFromDynamic(
      map,
      registry: registry,
    );

    if (result == null) {
      throw Exception(
        '[JsonComponentsBuilder]: requested to parse from dynamic, but the input is null.',
      );
    }

    return result;
  }

  static const kType = 'component';

  static const nameKey = 'name';
  static const versionKey = 'version';
  static const valuesKey = 'values';

  /// Builds the builder from a Map-like dynamic structure. This expects the
  /// JSON format to be of the following structure:
  ///
  /// ```json
  /// {
  ///   "id": "<String>",
  ///   "name": "<String>",
  ///   "version": "<String>"
  ///   "variables": "<Object>"
  /// }
  /// ```
  ///
  ///
  /// See also:
  ///  * [JsonComponentBuilder.fromDynamic]
  ///  * [JsonWidgetData.fromDynamic]
  static JsonComponentBuilder? maybeFromDynamic(
    dynamic map, {
    JsonWidgetRegistry? registry,
  }) {
    JsonComponentBuilder? result;
    if (map != null) {
      final name = map[nameKey]!;
      Version? version;
      if (map[versionKey] != null) {
        version = Version.parse(map[versionKey]);
      }
      final variables = Map<String, dynamic>.from(map[valuesKey] ?? {});

      result = JsonComponentBuilder(
        args: map,
        name: name,
        version: version,
        values: variables,
        callerRegistry: registry,
      );
    }
    return result;
  }

  @override
  String get type => kType;
}

class _Component extends StatefulWidget {
  const _Component({
    required this.name,
    required this.version,
    required this.values,
    required this.callerRegistry,
    required this.componentRegistry,
  });

  final String name;
  final Version? version;
  final Map<String, dynamic> values;
  final JsonWidgetRegistry callerRegistry;
  final JsonWidgetRegistry componentRegistry;

  @override
  _ComponentState createState() => _ComponentState();
}

class _ComponentState extends State<_Component> {
  JsonWidgetData? _componentData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadComponent(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _componentData == null
        ? const SizedBox()
        : _componentData!
            .build(context: context, registry: widget.componentRegistry);
  }

  Future<void> _loadComponent(BuildContext context) async {
    final loader = ComponentTemplateLoader.get();

    final componentTemplate = await loader.load(
        context, widget.callerRegistry, widget.name, widget.version);

    final values = <String, dynamic>{};
    for (var supportedValue in componentTemplate.values) {
      var value = supportedValue.defaultValue ?? '';
      if (widget.values.containsKey(supportedValue.name)) {
        value = widget.values[supportedValue.name]!;
      }
      values[supportedValue.name] = value;
    }
    final processedValues = Map<String, dynamic>.from(
      widget.callerRegistry.processArgs(values, null).value,
    );

    processedValues.forEach((key, value) {
      widget.componentRegistry.setValue(key, value);
    });

    setState(
      () => _componentData = JsonWidgetData.fromDynamic(
          componentTemplate.content,
          registry: widget.componentRegistry),
    );
  }
}

class ComponentSchema {
  static const id =
      'https://peiffer-innovations.github.io/flutter_json_schemas/schemas/json_dynamic_plugin_components/dynamic.json';

  static final schema = {
    r'$schema': 'http://json-schema.org/draft-07/schema#',
    r'$id': id,
    r'$children': -1,
    'title': 'Components',
    'oneOf': [
      {
        'type': 'null',
      },
      {
        'type': 'object',
        'additionalProperties': true,
        'properties': {
          'name': SchemaHelper.stringSchema,
          'version': {
            'oneOf': [
              {
                'type': 'null',
              },
              SchemaHelper.stringSchema,
            ],
          },
          'values': {
            'oneOf': [
              {
                'type': 'null',
              },
              {
                'type': 'object',
                'additionalProperties': true,
              }
            ]
          }
        }
      }
    ],
  };
}
