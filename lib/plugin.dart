import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';

class TestPlugin extends ServerPlugin {
  TestPlugin() : super(resourceProvider: PhysicalResourceProvider.INSTANCE);

  @override
  Future<void> analyzeFile({
    required AnalysisContext analysisContext,
    required String path,
  }) async {
    final unit = await analysisContext.currentSession.getResolvedUnit(path);
    if (unit is! ResolvedUnitResult) return;

    final error = AnalysisError(
      AnalysisErrorSeverity.WARNING,
      AnalysisErrorType.LINT,
      Location(path, 0, unit.unit.length, 0, 0),
      'Test Lint Message',
      'test_code',
      url: '',
      contextMessages: [],
      correction: '',
      hasFix: false,
    );
    final params = AnalysisErrorsParams(path, [error]);

    channel.sendNotification(params.toNotification());
  }

  @override
  Future<EditGetAssistsResult> handleEditGetAssists(
    EditGetAssistsParams parameters,
  ) async {
    parameters.file;
    return EditGetAssistsResult(<PrioritizedSourceChange>[
      PrioritizedSourceChange(
          0,
          SourceChange('Test Assist', edits: [
            SourceFileEdit(parameters.file, 0,
                edits: [SourceEdit(parameters.offset, 0, '/*replacement*/')]),
          ]))
    ]);
  }

  @override
  List<String> get fileGlobsToAnalyze => ['**.dart'];

  @override
  String get name => 'plugin_indirect_lints';

  @override
  String get version => '1.0.0-alpha.0';
  //
}
