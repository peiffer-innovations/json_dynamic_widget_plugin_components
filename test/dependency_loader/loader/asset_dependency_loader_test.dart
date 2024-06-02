import 'package:flutter_test/flutter_test.dart';
import 'package:json_dynamic_widget_plugin_components/json_dynamic_widget_plugin_components.dart';
import 'package:path/path.dart' as path;

void main() {
  group('DirAssetPathResolver', () {
    test('should resolve with json path in case of only passing the base path',
        () {
      // given
      const basePath = 'path/to/base';
      final resolver = DirAssetPathResolver(basePath: basePath);
      const dependency = Dependency(name: 'test', version: '1.0.0');

      // when
      final resolvedPath = resolver.resolve(dependency);

      // then
      expect(resolvedPath, path.join(basePath, 'test', '1.0.0.json'));
    });

    test(
        'should resolve with yaml path in case of passing that ext via constructor',
        () {
      // given
      const basePath = 'path/to/base';
      const ext = '.yaml';
      final resolver = DirAssetPathResolver(basePath: basePath, ext: ext);
      const dependency = Dependency(name: 'test', version: '1.0.0');

      // when
      final resolvedPath = resolver.resolve(dependency);

      // then
      expect(resolvedPath, path.join(basePath, 'test', '1.0.0.yaml'));
    });

    test(
        'should resolve with path that takes into account extension by dependency name',
        () {
      // given
      const basePath = 'path/to/base';
      const ext = '.json';
      final extByDependencyName = {'test': '.yaml'};
      final resolver = DirAssetPathResolver(
        basePath: basePath,
        ext: ext,
        extByDependencyName: extByDependencyName,
      );
      const dependency = Dependency(name: 'test', version: '1.0.0');

      // when
      final resolvedPath = resolver.resolve(dependency);

      // then
      expect(resolvedPath, path.join(basePath, 'test', '1.0.0.yaml'));
    });
  });
}
