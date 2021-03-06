// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.8
library frontend_server;

import 'package:vm/target/flutter.dart';
import 'dart:io';
import 'package:frontend_server/frontend_server.dart';
import '../hook/type_transformer.dart';

final TypeTransformer typeTransformer = TypeTransformer();

void main(List<String> args) async {
  ///在FlutterTarget中加入Transformer
  if (!FlutterTarget.flutterProgramTransformers.contains(typeTransformer)) {
    FlutterTarget.flutterProgramTransformers.add(typeTransformer);
  }

  final int exitCode = await starter(args);
  if (exitCode != 0) {
    exit(exitCode);
  }
}
