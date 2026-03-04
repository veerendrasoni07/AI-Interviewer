import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/global_variable.dart';
import 'package:frontend/model/report.dart';
import 'package:frontend/provider/report_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReportController {
  Future<void> getReports({required WidgetRef ref}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      http.Response response = await http.get(
        Uri.parse('$uri/api/get-reports'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)["reports"];
        List<Report> reports = data
            .map((report) => Report.fromMap(report))
            .toList();
        print(data);
        ref.read(reportProvider.notifier).setReport(reports);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
