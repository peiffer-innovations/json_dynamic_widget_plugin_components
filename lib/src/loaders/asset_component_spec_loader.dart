import 'dart:convert';

import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:version/version.dart';

import '../models/component_spec.dart';
import 'package:path/path.dart' as Path;
import 'component_spec_loader.dart';

class AssetComponentSpecLoader implements ComponentSpecLoader {
  AssetComponentSpecLoader(this.basePath);

  final String basePath;

  @override
  Future<ComponentSpec> load(
    BuildContext context,
    JsonWidgetRegistry? registry,
    String componentName,
    Version? version,
  ) async {
    final assetBundle = DefaultAssetBundle.of(context);

    version ??= await _getLatestVersion(assetBundle, componentName);

    if (version == null) {
      throw Exception('Component: $componentName not found');
    }

    final componentSpecStr = await assetBundle.loadString(Path.join(
      basePath,
      componentName,
      '${version.toString()}.json',
    ));
    final componentSpecMap =
        json.decode(componentSpecStr) as Map<String, dynamic>;
    return ComponentSpec.fromJson(componentSpecMap, registry);
  }

  Future<Version?> _getLatestVersion(
      AssetBundle assetBundle, String componentName) async {
    final versions = await _getAllVersions(assetBundle, componentName);

    if (versions.isEmpty) {
      return null;
    }

    var latestVersion = versions.first;
    if (versions.length == 1) {
      return latestVersion;
    }

    for (var i = 1; i < versions.length; i++) {
      final version = versions[i];
      if (version.compareTo(latestVersion) > 0) {
        latestVersion = version;
      }
    }

    return latestVersion;
  }

  Future<List<Version>> _getAllVersions(
    AssetBundle assetBundle,
    String componentName,
  ) async {
    final versions = <Version>[];
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    manifest
        .listAssets()
        .where((assetPath) => assetPath.startsWith('$basePath/$componentName/'))
        .forEach((componentPath) {
      final version = Version.parse(
        componentPath.split('/').last.replaceAll('.json', ''),
      );
      versions.add(version);
    });
    return versions;
  }
}
