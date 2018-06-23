import 'package:coveralls/coveralls.dart';
import 'package:test/test.dart';

/// Tests the features of the [Configuration] class.
void main() => group('Configuration', () {
  group('.keys', () {
    test('should return an empty array for an empty configuration', () {
      expect(Configuration().keys, isEmpty);
    });

    test('should return the list of keys for a non-empty configuration', () {
      var keys = Configuration({'foo': 'bar', 'baz': 'qux'}).keys.toList();
      expect(keys, hasLength(2));
      expect(keys.first, equals('foo'));
      expect(keys.last, equals('baz'));
    });
  });

  group('operator []', () {
    test('should properly get and set the configuration entries', () {
      var config = Configuration();
      expect(config['foo'], isNull);

      config['foo'] = 'bar';
      expect(config['foo'], equals('bar'));
    });
  });

  group('.clear()', () {
    test('should be empty when there is no CI environment variables', () {
      var config = Configuration({'foo': 'bar', 'baz': 'qux'});
      expect(config, hasLength(2));
      config.clear();
      expect(config, hasLength(0));
    });
  });

  group('.fromEnvironment()', () {
    test('should return an empty configuration for an empty environment', () {
      expect(Configuration.fromEnvironment({}), isEmpty);
    });

    test('should return an initialized instance for a non-empty environment', () {
      var config = Configuration.fromEnvironment({
        'CI_NAME': 'travis-pro',
        'CI_PULL_REQUEST': 'PR #123',
        'COVERALLS_REPO_TOKEN': '0123456789abcdef',
        'GIT_MESSAGE': 'Hello World!',
        'TRAVIS': 'true',
        'TRAVIS_BRANCH': 'develop'
      });

      expect(config['commit_sha'], equals('HEAD'));
      expect(config['git_message'], equals('Hello World!'));
      expect(config['repo_token'], equals('0123456789abcdef'));
      expect(config['service_branch'], equals('develop'));
      expect(config['service_name'], equals('travis-pro'));
      expect(config['service_pull_request'], equals('123'));
    });
  });

  group('.fromYaml()', () {
    test('should throw an exception with a non-object value', () {
      expect(() => Configuration.fromYaml('**123/456**'), throwsFormatException);
      expect(() => Configuration.fromYaml('foo'), throwsFormatException);
    });

    test('should return an initialized instance for a non-empty map', () {
      var config = Configuration.fromYaml('repo_token: 0123456789abcdef\nservice_name: travis-ci');
      expect(config, hasLength(2));
      expect(config['repo_token'], equals('0123456789abcdef'));
      expect(config['service_name'], equals('travis-ci'));
    });
  });

  group('.loadDefaults()', () {
    test('should properly initialize from a `.coveralls.yml` file', () async {
      var config = await Configuration.loadDefaults('test/fixtures/.coveralls.yml');
      expect(config.length, greaterThanOrEqualTo(2));
      expect(config['repo_token'], equals('yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt'));
      expect(config['service_name'], equals('travis-pro'));
    });

    test('should use the environment defaults if the `.coveralls.yml` file is not found', () async {
      var defaults = Configuration.fromEnvironment();
      var config = await Configuration.loadDefaults('.dummy/config.yml');
      expect(config.length, equals(defaults.length));
      for (var key in config.keys) expect(config[key], equals(defaults[key]));
    });
  });

  group('.remove()', () {
    test('should be empty when there is no CI environment variables', () {
      var config = Configuration({'foo': 'bar', 'bar': 'baz'});
      expect(config, contains('foo'));
      config.remove('foo');
      expect(config, isNot(contains('foo')));
    });
  });

  group('.toJson()', () {
    test('should return an empty map for a newly created instance', () {
      expect(Configuration().toJson(), isEmpty);
    });

    test('should return a non-empty map for an initialized instance', () {
      var map = Configuration({'foo': 'bar', 'bar': 'baz'}).toJson();
      expect(map, hasLength(2));
      expect(map['foo'], equals('bar'));
      expect(map['bar'], equals('baz'));
    });
  });

  group('.toString()', () {
    var data = Configuration({'foo': 'bar', 'baz': 'qux'}).toString();

    test('should start with the class name', () {
      expect(data.indexOf('Configuration {'), equals(0));
    });

    test('should contain the instance properties', () {
      expect(data, allOf(
        contains('"foo":"bar"'),
        contains('"baz":"qux"')
      ));
    });
  });
});
