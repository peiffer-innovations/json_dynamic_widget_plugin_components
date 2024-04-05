import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:path/path.dart' as path;
import 'package:version/version.dart';

import '../models/json_component_spec.dart';
import 'component_spec_loader.dart';

// Loads the component specification from JSON or YAML asset. In case of version being
// null, the loader should return the latest version of the component.
class AssetComponentSpecLoader implements ComponentSpecLoader {
  const AssetComponentSpecLoader(this._basePath);

  static final RegExp _extRegExp = RegExp(r'.[a-z]+$');

  final String _basePath;

  @override
  Future<ComponentSpec> load({
    required String componentName,
    required BuildContext context,
    JsonWidgetRegistry? registry,
    Version? version,
  }) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final componentSpecPath = await _getComponentSpecPath(
      assetBundle,
      componentName,
      version,
    );
    final componentSpecStr = await assetBundle.loadString(componentSpecPath);
    final componentSpecMap = Map<String, dynamic>.from(
        yaon.parse(componentSpecStr, normalize: true));
    return ComponentSpec.fromJson(componentSpecMap, registry);
  }

  Future<String> _getComponentSpecPath(
    AssetBundle assetBundle,
    String componentName,
    Version? version,
  ) async {
    final manifest = await AssetManifest.loadFromAssetBundle(assetBundle);
    final componentSpecBasePath = path.join(
      _basePath,
      componentName,
    );
    final componentSpecPaths = manifest
        .listAssets()
        .where((assetPath) => assetPath.startsWith(componentSpecBasePath));

    version ??= await _getLatestVersion(componentSpecPaths);

    if (version == null) {
      throw Exception('Component: $componentName not found');
    }

    return componentSpecPaths
        .firstWhere((path) => path.contains('/${version.toString()}'));
  }

  Future<Version?> _getLatestVersion(
      Iterable<String> componentSpecPaths) async {
    final versions = componentSpecPaths.map((path) =>
        Version.parse(path.split('/').last.replaceAll(_extRegExp, '')));
    Version? latestVersion;

    if (versions.isNotEmpty) {
      latestVersion = versions.first;
      for (var version in versions.skip(1)) {
        if (version.compareTo(latestVersion) > 0) {
          latestVersion = version;
        }
      }
    }

    return latestVersion;
  }
}
