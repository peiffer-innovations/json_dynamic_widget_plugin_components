import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/src/models/component_spec.dart';
import 'package:version/version.dart';
import '../loaders/component_spec_loader.dart';

/// Loads the component based on the JSON structure.
class JsonComponentBuilder extends JsonWidgetBuilder {
  const JsonComponentBuilder({
    required super.args,
    required this.name,
    required this.inputs,
    required this.outputs,
    this.version,
    this.callerRegistry,
  });

  final JsonWidgetRegistry? callerRegistry;
  final String name;
  final Version? version;
  final Map<String, dynamic> inputs;
  final Map<String, String> outputs;

  @override
  JsonWidgetBuilderModel createModel({
    ChildWidgetBuilder? childBuilder,
    required JsonWidgetData data,
  }) =>
      throw UnsupportedError(
        'The component widget is too complex to support auto-encoding',
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
      inputs: inputs,
      outputs: outputs,
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
        '[JsonComponentBuilder]: requested to parse from dynamic, but the input is null.',
      );
    }

    return result;
  }

  static const kType = 'component';

  static const nameKey = 'name';
  static const versionKey = 'version';
  static const inputsKey = 'inputs';
  static const outputsKey = 'outputs';

  /// Builds the builder from a Map-like dynamic structure. This expects the
  /// JSON format to be of the following structure:
  ///
  /// ```json
  /// {
  ///   "name": "<String>",
  ///   "version": "<String>"
  ///   "inputs": "<Object>"
  ///   "outputs": "<Object>"
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
      final inputs = Map<String, dynamic>.from(map[inputsKey] ?? {});
      final outputs = Map<String, String>.from(map[outputsKey] ?? {});

      result = JsonComponentBuilder(
        args: map,
        name: name,
        version: version,
        inputs: inputs,
        outputs: outputs,
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
    required this.inputs,
    required this.outputs,
    required this.callerRegistry,
    required this.componentRegistry,
  });

  final String name;
  final Version? version;
  final Map<String, dynamic> inputs;
  final Map<String, String> outputs;
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
    final loader = ComponentSpecLoader.get();

    final componentSpec = await loader.load(
        context, widget.callerRegistry, widget.name, widget.version);

    final inputs = _prepareInputs(componentSpec.inputs);
    final processedInputs = widget.callerRegistry.processArgs(inputs, null);

    Map<String, dynamic>.from(processedInputs.value).forEach((key, value) {
      widget.componentRegistry.setValue(key, value);
    });

    processedInputs.jsonWidgetListenVariables.forEach((inputVariable) => 
      // widget.callerRegistry.valueStream.
    )

    setState(
      () => _componentData = JsonWidgetData.fromDynamic(componentSpec.content,
          registry: widget.componentRegistry),
    );
  }

  // Prepares the inputs based on the input definitions in the component.
  Map<String, dynamic> _prepareInputs(List<InputSpec> inputSpecs) {
    final inputs = <String, dynamic>{};
    // filter out inputs that are not defined in the component
    for (var inputSpec in inputSpecs) {
      var value = inputSpec.defaultValue ?? '';
      if (widget.inputs.containsKey(inputSpec.name)) {
        value = widget.inputs[inputSpec.name]!;
      }
      inputs[inputSpec.name] = value;
    }
    return inputs;
  }
}

class ComponentSchema {
  static const id =
      'https://peiffer-innovations.github.io/flutter_json_schemas/schemas/json_dynamic_plugin_components/component.json';

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
