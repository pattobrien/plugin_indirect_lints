import 'dart:isolate';

import 'package:plugin_indirect_lints/plugin.dart';
import 'package:analyzer_plugin/starter.dart';

Future<void> main(List<String> args, SendPort sendPort) async {
  final plugin = TestPlugin();
  final starter = ServerPluginStarter(plugin);
  starter.start(sendPort);
}
