library flutter_launcher_name;

import 'dart:io';

import 'package:flutter_launcher_name/android.dart' as android;
import 'package:flutter_launcher_name/constants.dart' as constants;
import 'package:flutter_launcher_name/ios.dart' as ios;
import 'package:yaml/yaml.dart';

void exec() {
  print('start');

  final config = loadConfigFile();

  final newName = config['name'] as String?; // null이 될 수 있음을 명시

  if (newName != null) { // null 체크
    android.overwriteAndroidManifest(newName);
    ios.overwriteInfoPlist(newName);
  } else {
    print('Error: newName is null');
  }

  print('exit');
}

Map<String, dynamic> loadConfigFile() {
  final File file = File('pubspec.yaml');
  final String yamlString = file.readAsStringSync();
  final yamlMap = loadYaml(yamlString);

  if (yamlMap == null || !(yamlMap[constants.yamlKey] is Map)) {
    throw Exception('flutter_launcher_name was not found'); // 'new' 키워드 제거
  }

  final Map<String, dynamic> config = <String, dynamic>{};
  for (var entry in yamlMap[constants.yamlKey].entries) { // 타입 명시
    config[entry.key as String] = entry.value; // null safety를 위한 타입 캐스팅
  }

  return config;
}
