import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/controller/report_controller.dart';
import 'package:frontend/model/report.dart';
import 'package:frontend/provider/report_provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ReportController().getReports(ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    final reports = ref.watch(reportProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Reports',
          style: GoogleFonts.orbitron(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF08160E),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF020A06), Color(0xFF042112), Color(0xFF0A3D24)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: reports.isEmpty
                ? Center(
                    child: Text(
                      'No reports available yet.',
                      style: GoogleFonts.spaceGrotesk(
                        color: const Color(0xFFD4FBE5),
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                  shrinkWrap: true,
                  itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      return _ReportTile(report: report);
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.to(() => ReportDetailsScreen(report: report));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x5528D877)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interview Report',
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tech Stack: ${report.techstack}',
              style: GoogleFonts.spaceGrotesk(
                color: const Color(0xFFD4FBE5),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Accuracy: ${report.accuracy}%',
              style: GoogleFonts.spaceGrotesk(
                color: const Color(0xFFD4FBE5),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tap to view full details',
              style: GoogleFonts.spaceGrotesk(
                color: const Color(0xFF7DE6AA),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportDetailsScreen extends StatelessWidget {
  const ReportDetailsScreen({super.key, required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report Details',
          style: GoogleFonts.orbitron(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF08160E),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF020A06), Color(0xFF042112), Color(0xFF0A3D24)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _DetailCard(title: 'Tech Stack', value: report.techstack),
              _DetailCard(title: 'Accuracy', value: '${report.accuracy}%'),
              _DetailCard(title: 'Fluency', value: report.fluency),
              _DetailCard(title: 'Communication', value: report.communication),
              _DetailCard(
                title: 'Strong Areas',
                value: report.strongareas.join(', '),
              ),
              _DetailCard(
                title: 'Weak Areas',
                value: report.weakareas.join(', '),
              ),
              _DetailCard(
                title: 'Improvements',
                value: report.improvement.join(', '),
              ),
              _DetailCard(title: 'Tips', value: report.tips.join(', ')),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x5528D877)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              color: const Color(0xFF8BF0B7),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value.isEmpty ? '-' : value,
            style: GoogleFonts.spaceGrotesk(
              color: const Color(0xFFD4FBE5),
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
