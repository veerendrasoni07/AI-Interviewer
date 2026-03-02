import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/model/report.dart';
import 'package:frontend/provider/report_provider.dart';
import 'package:frontend/provider/socket_provider.dart';
import 'package:frontend/service/socket_service.dart';

enum ReportState { idle, beforeGenerating, generating, ready, error }

class ReportStateProvider extends StateNotifier<ReportState> {
  final Ref ref;
  SocketService service;
  String? errorMessage;

  ReportStateProvider(this.ref, this.service) : super(ReportState.idle) {
    reportGeneration();
  }

  void reportGeneration() async {
    try {
      state = ReportState.beforeGenerating;
      service.generating(
        callBack: (data) {
          bool flag = data["msg"];
          if (flag) {
            state = ReportState.generating;
          }
        },
      );
      service.generateReport(
        callBack: (data) async {
          final reportData = data["report"];
          final report = Report.fromMap(reportData);
          ref.read(reportProvider.notifier).addReport(report);
          state = ReportState.ready;
        },
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void reset() {
    errorMessage = null;
    state = ReportState.idle;
  }
}

final reportState = StateNotifierProvider<ReportStateProvider, ReportState>((
  ref,
) {
  return ReportStateProvider(ref, ref.read(socketProvider));
});
