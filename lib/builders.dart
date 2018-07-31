import 'dart:async';

import 'package:build/build.dart';

Builder builderA(BuilderOptions options) =>new BuilderA();
Builder builderB(BuilderOptions options) =>new BuilderB();
Builder builderC(BuilderOptions options) =>new BuilderC();
Builder builderD(BuilderOptions options) =>new BuilderD();

class BuilderA implements Builder {
  @override
  Future build(BuildStep buildStep) async {
    final content = await buildStep.readAsString(buildStep.inputId);
    if (content.length > 3) {
      await buildStep.writeAsString(
          buildStep.inputId.changeExtension('.a1'), '');
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    '.dart': ['.a1']
  };
}

class BuilderB implements Builder {
  @override
  Future build(BuildStep buildStep) async {
    await buildStep.writeAsString(buildStep.inputId.changeExtension('.b1'), '');
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    '.a1': ['.b1']
  };
}

class BuilderC implements Builder {
  @override
  Future build(BuildStep buildStep) async {
    final assetA = buildStep.inputId.changeExtension('.a1');
    if (!await buildStep.canRead(assetA)) {
      throw new Exception("can't read file $assetA");
    }
    await buildStep.writeAsString(buildStep.inputId.changeExtension('.c1'), '');
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    '.b1': ['.c1']
  };
}

class BuilderD implements Builder {
  @override
  Future build(BuildStep buildStep) async {
    final outAsset = buildStep.inputId.changeExtension('.txt');
    if (await buildStep.canRead(buildStep.inputId.changeExtension('.c1'))) {
      await buildStep.writeAsString(outAsset, 'has conent');
    } else {
      await buildStep.writeAsString(outAsset, 'no content');
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    '.dart': ['.txt']
  };
}