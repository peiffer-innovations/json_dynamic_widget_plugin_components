import 'dart:async';

import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/src/builder/component_spec.dart';
import 'package:json_dynamic_widget_plugin_components/src/dependency_loader/dependency.dart';

import '../dependency_loader/dependency_registry.dart';

part 'json_component_builder.g.dart';

class _Component extends StatefulWidget {
  const _Component({
    @JsonBuildArg() this.childBuilder,
    @JsonBuildArg() required this.data,
    required this.inputs,
    super.key,
    @JsonBuildArg() required this.model,
    required this.name,
    required this.outputs,
    this.version,
  });
  final ChildWidgetBuilder? childBuilder;

  final JsonWidgetData data;
  final Map<String, dynamic> inputs;
  final JsonComponentBuilderModel model;
  final String name;
  final Map<String, String> outputs;
  final String? version;

  @override
  _ComponentState createState() => _ComponentState();
}

class _ComponentState extends State<_Component> {
  static final JsonWidgetRegistry _componentParent = JsonWidgetRegistry(
    debugLabel: 'component_parent',
  );

  final List<StreamSubscription<WidgetValueChanged>> _inputSubscriptions = [];
  final List<StreamSubscription<WidgetValueChanged>> _outputSubscriptions = [];

  JsonWidgetData? _componentData;
  late JsonWidgetRegistry _componentRegistry;
  late JsonWidgetData _data;

  @override
  Widget build(BuildContext context) {
    return _componentData == null
        ? const SizedBox()
        : _componentData!.build(context: context, registry: _componentRegistry);
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

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init(context);
    });
  }

  void _addInputSubscriptions(
    String componentInputName,
    dynamic rawValue,
    JsonWidgetRegistry callerRegistry,
    ProcessedArg processedValue,
  ) {
    for (var inputValueVar in processedValue.jsonWidgetListenVariables) {
      final inputSubscription = callerRegistry.valueStream.listen((event) {
        if (inputValueVar == event.id) {
          final processedValue = callerRegistry.processArgs(rawValue, null);
          _componentRegistry.setValue(componentInputName, processedValue.value);
        }
      });
      _inputSubscriptions.add(inputSubscription);
    }
  }

  void _addOutputSubscription(
    String componentOutputName,
    String callerOutputName,
    JsonWidgetRegistry callerRegistry,
  ) {
    final outputSubscription = _componentRegistry.valueStream.listen((event) {
      if (componentOutputName == event.id) {
        callerRegistry.setValue(callerOutputName, event.value);
      }
    });
    _outputSubscriptions.add(outputSubscription);
  }

  Future<void> _init(BuildContext context) async {
    final dependencyRegistry = DependencyRegistry.instance;
    final callerRegistry = _data.jsonWidgetRegistry;

    var version = '';
    if (context.mounted) {
      version = await dependencyRegistry.resolveVersion(
        widget.name,
        widget.version,
        context,
      );
    }
    if (version.isEmpty) {
      throw Exception(
        'Unable to resolve version for component: ${widget.name}:${widget.version ?? ''}',
      );
    }
    final dependency = Dependency(name: widget.name, version: version);

    String? componentSpecStr;
    if (context.mounted) {
      componentSpecStr = await dependencyRegistry.load(dependency, context);
    }

    if (componentSpecStr == null || componentSpecStr.isEmpty) {
      throw Exception(
        'Unable to load component: ${widget.name}:${widget.version ?? ''}',
      );
    }

    final componentSpecJson = Map<String, dynamic>.from(
      yaon.parse(componentSpecStr, normalize: true),
    );

    final componentSpec = ComponentSpec.fromJson(componentSpecJson);

    _componentRegistry = callerRegistry.copyWith(
      debugLabel: '${componentSpec.name}:${componentSpec.version.toString()}',
      values: {},
      parent: _componentParent,
    );
    _prepareInputs(componentSpec.inputs).forEach((name, rawValue) {
      final processedValue = callerRegistry.processArgs(rawValue, null);
      _componentRegistry.setValue(name, processedValue.value);

      _addInputSubscriptions(name, rawValue, callerRegistry, processedValue);
    });

    _prepareOutputs(componentSpec.outputs).forEach((
      componentOutputName,
      callerOutputName,
    ) {
      _addOutputSubscription(
        componentOutputName,
        callerOutputName,
        callerRegistry,
      );
    });

    if (mounted) {
      setState(
        () =>
            _componentData = JsonWidgetData.fromDynamic(
              componentSpec.content,
              registry: _componentRegistry,
            ),
      );
    }
  }

  // Prepares the inputs based on the input definitions in the component.
  Map<String, dynamic> _prepareInputs(List<InputSpec> inputSpecs) {
    final inputs = <String, dynamic>{};
    // filter out inputs that are not defined in the component
    for (var inputSpec in inputSpecs) {
      var value = inputSpec.defaultValue ?? '';
      if (widget.inputs.containsKey(inputSpec.name)) {
        value =
            widget.data.jsonWidgetArgs[ComponentSpec.inputsKey][inputSpec
                .name]!;
      }
      inputs[inputSpec.name] = value;
    }
    return inputs;
  }

  // Prepares the outputs based on the output definitions in the component.
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

/// Loads the component based on the JSON structure.
@jsonWidget
abstract class _JsonComponentBuilder extends JsonWidgetBuilder {
  const _JsonComponentBuilder({required super.args});

  @override
  _Component buildCustom({
    ChildWidgetBuilder? childBuilder,
    required BuildContext context,
    required JsonWidgetData data,
    Key? key,
  });

  @JsonArgDecoder('inputs')
  Map<String, dynamic> _decodeInputs({required dynamic value}) =>
      value == null ? const {} : Map<String, dynamic>.from(value);

  @JsonArgDecoder('outputs')
  Map<String, String> _decodeOutputs({required dynamic value}) =>
      value == null ? const {} : Map<String, String>.from(value);
}
