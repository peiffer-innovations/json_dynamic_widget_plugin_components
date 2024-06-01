import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_dynamic_widget_plugin_components/json_dynamic_widget_plugin_components.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<DependencyLoader>()])
@GenerateNiceMocks([MockSpec<BuildContext>()])
import 'cached_dependency_loader_test.mocks.dart';

void main() {
  group('CachedDependencyLoader', () {
    late CachedDependencyLoader cachedDependencyLoader;
    late MockDependencyLoader mockDependencyLoader;
    late MockBuildContext mockContext;

    setUp(() {
      mockDependencyLoader = MockDependencyLoader();
      mockContext = MockBuildContext();
      cachedDependencyLoader =
          CachedDependencyLoader(cachedLoader: mockDependencyLoader);
    });

    test('should load dependency from underlying loader if not cached',
        () async {
      // given
      const dependency = Dependency(name: 'dependency', version: '1.0.0');
      when(mockDependencyLoader.load(dependency, mockContext))
          .thenAnswer((_) => Future.value('content'));

      // when
      final result = await cachedDependencyLoader.load(dependency, mockContext);

      // then
      expect(result, 'content');
      verify(mockDependencyLoader.load(dependency, mockContext)).called(1);
    });

    test('should return cached dependency if available', () async {
      // given
      const dependency = Dependency(name: 'dependency', version: '1.0.0');
      when(mockDependencyLoader.load(dependency, mockContext))
          .thenAnswer((_) => Future.value('content'));
      // it should call child loader and load the dependency to the cache
      await cachedDependencyLoader.load(dependency, mockContext);

      // when
      final result = await cachedDependencyLoader.load(dependency, mockContext);

      // then
      expect(result, 'content');
      verify(mockDependencyLoader.load(dependency, mockContext)).called(1);
    });
  });
}
