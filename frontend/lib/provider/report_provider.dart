import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/model/report.dart';

class ReportProvider extends StateNotifier<List<Report>> {
  ReportProvider() : super([]);

  void addReport(Report report) {
    state = [report, ...state];
  }

  void setReport(List<Report> reports) {
    state = reports;
  }
}

final reportProvider = StateNotifierProvider<ReportProvider, List<Report>>((
  ref,
) {
  return ReportProvider();
});
