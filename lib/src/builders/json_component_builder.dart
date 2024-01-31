import 'dart:async';

import 'package:json_dynamic_widget/builders.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/src/models/json_component_spec.dart';
import 'package:version/version.dart';
import '../loaders/component_spec_loader.dart';

part 'json_component_builder.g.dart';

/// Loads the component based on the JSON structure.
@jsonWidget
abstract class _JsonComponentBuilder extends JsonWidgetBuilder {
  const _JsonComponentBuilder({
    required super.args,
  });

  @JsonArgDecoder('version')
  Version? _decodeVersion({required dynamic value}) =>
      value != null && value != '' ? Version.parse(value) : null;

  @JsonArgEncoder('version')
  static String _encodeVersion(Version? version) => version?.toString() ?? '';

  @JsonArgDecoder('inputs')
  Map<String, dynamic> _decodeInputs({required dynamic value}) =>
      value == null ? {} : Map<String, dynamic>.from(value);

  @JsonArgDecoder('outputs')
  Map<String, String> _decodeOutputs({required dynamic value}) =>
      value == null ? {} : Map<String, String>.from(value);

  @override
  _Component buildCustom({
    ChildWidgetBuilder? childBuilder,
    required BuildContext context,
    required JsonWidgetData data,
    Key? key,
  });
}

class _Component extends StatefulWidget {
  const _Component({
    @JsonBuildArg() this.childBuilder,
    @JsonBuildArg() required this.data,
    @JsonBuildArg() required this.model,
    super.key,
    required this.name,
    this.version,
    required this.inputs,
    required this.outputs,
  });

  final ChildWidgetBuilder? childBuilder;
  final JsonWidgetData data;
  final JsonComponentBuilderModel model;
  final String name;
  final Version? version;
  final Map<String, dynamic> inputs;
  final Map<String, String> outputs;

  @override
  _ComponentState createState() => _ComponentState();
}

class _ComponentState extends State<_Component> {
  JsonWidgetData? _componentData;
  late JsonWidgetRegistry _componentRegistry;
  late JsonWidgetData _data;

  List<StreamSubscription<WidgetValueChanged>> _inputSubscriptions = [];
  List<StreamSubscription<WidgetValueChanged>> _outputSubscriptions = [];

  static final JsonWidgetRegistry _componentParent =
      JsonWidgetRegistry(debugLabel: 'component_parent');

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _componentData == null
        ? const SizedBox()
        : _componentData!
            .build(context: context, registry: _componentRegistry);
  }

  Future<void> _init(BuildContext context) async {
    final loader = ComponentSpecLoader.get();
    final callerRegistry = _data.jsonWidgetRegistry;

    final componentSpec =
        await loader.load(context, callerRegistry, widget.name, widget.version);

    _componentRegistry = callerRegistry.copyWith(
      debugLabel: '${componentSpec.name}:${componentSpec.version?.toString()}',
      values: {},
      parent: _componentParent,
    );
    _prepareInputs(componentSpec.inputs).forEach(
      (name, value) {
        final processedValue = callerRegistry.processArgs(value, null);
        _componentRegistry.setValue(name, processedValue.value);

        for (var inputValueVar in processedValue.jsonWidgetListenVariables) {
          final inputSubscription = callerRegistry.valueStream.listen((event) {
            if (inputValueVar == event.id) {
              final processedValue = callerRegistry.processArgs(value, null);
              _componentRegistry.setValue(name, processedValue.value);
            }
          });
          _inputSubscriptions.add(inputSubscription);
        }
      },
    );

    _prepareOutputs(componentSpec.outputs)
        .forEach((outputName, callerOutputName) {
      final outputSubscription = _componentRegistry.valueStream.listen((event) {
        if (outputName == event.id) {
          callerRegistry.setValue(callerOutputName, event.value);
        }
      });
      _outputSubscriptions.add(outputSubscription);
    });

    setState(
      () => _componentData = JsonWidgetData.fromDynamic(componentSpec.content,
          registry: _componentRegistry),
    );
  }

  @override
  void dispose() {
    for (var subscription in _inputSubscriptions) {
      subscription.cancel();
    }
    for (var subscription in _outputSubscriptions) {
      subscription.cancel();
    }

    super.dispose();
  }

  // Prepares the inputs based on the input definitions in the component.
  Map<String, dynamic> _prepareInputs(List<InputSpec> inputSpecs) {
    final inputs = <String, dynamic>{};
    // filter out inputs that are not defined in the component
    for (var inputSpec in inputSpecs) {
      var value = inputSpec.defaultValue ?? '';
      if (widget.inputs.containsKey(inputSpec.name)) {
        value = widget.data.jsonWidgetArgs[ComponentSpec.inputsKey]
            [inputSpec.name]!;
      }
      inputs[inputSpec.name] = value;
    }
    return inputs;
  }

  // Prepares the outputs based on the input definitions in the component.
  Map<String, String> _prepareOutputs(List<OutputSpec> outputSpecs) {
    final outputs = <String, String>{};
    // filter out outputs that are not defined in the component
    for (var outputSpec in outputSpecs) {
      final outputName = outputSpec.name;
      if (widget.outputs.containsKey(outputName)) {
        outputs[outputName] = widget.outputs[outputName]!;
      }
    }
    return outputs;
  }
}
