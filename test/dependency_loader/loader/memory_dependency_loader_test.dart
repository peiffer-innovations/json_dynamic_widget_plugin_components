import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_dynamic_widget_plugin_components/json_dynamic_widget_plugin_components.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<BuildContext>()])
import 'memory_dependency_loader_test.mocks.dart';

void main() {
  group('MemoryDependencyLoader', () {
    late MockBuildContext mockContext;

    setUp(() {
      mockContext = MockBuildContext();
    });

    test('should return dependency data if it exists', () async {
      // given
      const dependency = Dependency(name: 'test', version: '1.0.0');
      final dependencyData = {dependency: 'test_data'};
      final loader = MemoryDependencyLoader(dependencyData: dependencyData);

      // when
      final result = await loader.load(dependency, mockContext);

      // then
      expect(result, 'test_data');
    });

    test('should return null if dependency data does not exist', () async {
      // given
      const dependency = Dependency(name: 'test', version: '1.0.0');
      final dependencyData = <Dependency, String>{};
      final loader = MemoryDependencyLoader(dependencyData: dependencyData);

      // when
      final result = await loader.load(dependency, mockContext);

      // then
      expect(result, null);
    });
  });
}
