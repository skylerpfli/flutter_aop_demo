// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.8
library frontend_server;

import 'package:vm/target/flutter.dart';
import 'dart:io';
import 'package:frontend_server/frontend_server.dart';
import '../hook/hook_transformer.dart';

final HookTransformer throttleTransformer = HookTransformer();

void main(List<String> args) async {
  // 在切入点加入Transformer
  FlutterTarget.flutterProgramTransformers.add(throttleTransformer);

  // 执行原本的编译流程
  final int exitCode = await starter(args);
  if (exitCode != 0) {
    exit(exitCode);
  }
}
