import 'dart:convert';

import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/json_dynamic_widget_plugin_components.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      debugPrint('${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('${record.stackTrace}');
    }
  });

  final navigatorKey = GlobalKey<NavigatorState>();

  final registry = JsonWidgetRegistry.instance;
  JsonComponentsPluginRegistrar.registerDefaults(registry: registry).withLoader(
    AssetDependencyLoader(
      pathResolver: DirAssetPathResolver(
        basePath: 'assets/components',
        ext: Ext.json,
        extByDependencyName: {
          'centered_text': Ext.yaml,
        },
      ),
    ),
  );

  registry.navigatorKey = navigatorKey;

  final data = JsonWidgetData.fromDynamic(
    json.decode(await rootBundle.loadString('assets/pages/components.json')),
    registry: registry,
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ComponentWidgetPage(
        data: data,
      ),
      theme: ThemeData.light(),
    ),
  );
}

class ComponentWidgetPage extends StatelessWidget {
  const ComponentWidgetPage({
    super.key,
    required this.data,
  });
  final JsonWidgetData data;

  @override
  Widget build(BuildContext context) => data.build(context: context);
}
