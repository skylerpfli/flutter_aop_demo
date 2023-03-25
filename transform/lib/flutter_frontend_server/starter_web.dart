// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.8
library frontend_server;

import 'package:vm/target/flutter.dart';
import '../hook/hook_transformer.dart';
import 'package:compiler/src/dart2js.dart' as dart2js;

final HookTransformer throttleTransformer = HookTransformer();

Future<void> main(List<String> args) async {
  // 在切入点加入Transformer
  FlutterTarget.flutterProgramTransformers.add(throttleTransformer);

  // 执行原本的编译流程
  dart2js.main(args);
}