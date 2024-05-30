import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:path/path.dart' as path;

import '../../../json_dynamic_widget_plugin_components.dart';

abstract class AssetPathResolver {
  String resolve(Dependency dependency);
}

class Ext {
  static const json = '.json';
  static const yaml = '.yaml';
}

/// Resolves the asset path based on the dependency name and version
/// It expects the following directory structure:
/// <basePath>/
///   -> <dependency_name>
///      -> <dependency_version><ext>
class DirAssetPathResolver extends AssetPathResolver {
  DirAssetPathResolver({
    required String basePath,
    String ext = Ext.json,
    Map<String, String>? extByDependencyName,
  })  : _basePath = basePath,
        _ext = ext,
        _extByDependencyName = extByDependencyName ?? {};

  final String _basePath;
  final String _ext;
  final Map<String, String> _extByDependencyName;

  @override
  String resolve(Dependency dependency) {
    var ext = _ext;
    if (_extByDependencyName.containsKey(dependency.name)) {
      ext = _extByDependencyName[dependency.name]!;
    }

    return path.join(_basePath, dependency.name, dependency.version + ext);
  }
}

class AssetDependencyLoader implements DependencyLoader {
  AssetDependencyLoader({required this.pathResolver});

  AssetPathResolver pathResolver;

  @override
  Future<String?> load(Dependency dependency, BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final assetPath = pathResolver.resolve(dependency);
    return await assetBundle.loadString(assetPath);
  }
}
