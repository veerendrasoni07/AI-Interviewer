import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/voice_bubble.dart';
import 'package:frontend/model/report.dart';
import 'package:frontend/provider/interview_state.dart';
import 'package:frontend/provider/report_provider.dart';
import 'package:frontend/provider/report_state.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/service/vapi_service.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vapi/vapi.dart';

enum Speaker { user, assistant, none }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  Speaker currentSpeaker = Speaker.none;

  String buttonText = 'Start Interview';
  bool isLoading = false;
  bool isCallStarted = false;

  final VapiService vapiService = VapiService.instance;
  final VapiClient vapi = VapiClient('4e70a746-fd7c-4c9a-9e1f-e5354afc9e3d');
  VapiCall? currCall;
  Offset _pointer = const Offset(0.5, 0.5);

  final List<List<Color>> _dynamicGradients = <List<Color>>[
    const [Color(0xFF020A06), Color(0xFF042112), Color(0xFF0A3D24)],
    const [Color(0xFF02120A), Color(0xFF05351D), Color(0xFF0D5F34)],
    const [Color(0xFF020A06), Color(0xFF103820), Color(0xFF1BAA5A)],
    const [Color(0xFF010604), Color(0xFF143A22), Color(0xFF28C26B)],
  ];

  List<Color> _gradientForState(InterviewState state) {
    switch (state) {
      case InterviewState.idle:
        return _dynamicGradients[0];
      case InterviewState.loading:
        return _dynamicGradients[1];
      case InterviewState.started:
        return _dynamicGradients[2];
      case InterviewState.ended:
        return _dynamicGradients[3];
    }
  }

  Future<void> startCall() async {
    // _conversationLines.clear();
    // _lastConversation = '';
    ref.read(reportState.notifier).reset();
    final user = ref.read(userProvider);
    final call = await vapi.start(
      assistantId: '6129f7cc-ca0d-4540-b8ba-9a74fba80603',
      assistantOverrides: {
        'variableValues': {"userId": user!.id, "name": user.fullname},
      },
    );
    if (!mounted) {
      return;
    }
    setState(() {
      currCall = call;
      currCall!.onEvent.listen(_handleCallEvents);
      isCallStarted = true;
      ref.read(interviewProvider.notifier).startInterview();
    });
  }

  void _handleCallEvents(VapiEvent event) {
    final data = event.value;
    final type = (data is Map<String, dynamic>) ? data['type'] : null;

    if (type == 'voice-input') {
      setState(() {
        currentSpeaker = Speaker.user;
      });
    }

    if (type == 'model-output') {
      setState(() {
        currentSpeaker = Speaker.assistant;
      });
    }

    if (event.label == 'call-end') {
      setState(() {
        currentSpeaker = Speaker.none;
      });
    }

    if (event.label == 'call-start') {
      setState(() {
        buttonText = 'End Call';
        isLoading = false;
        isCallStarted = true;
      });
      debugPrint('call started');
    }

    if (event.label == 'call-end') {
      setState(() {
        buttonText = 'Start Call';
        isLoading = false;
        isCallStarted = false;
        currCall = null;
      });
      debugPrint('call ended');
    }

    // if (event.label == 'message') {
    //   final transcriptLine = _extractConversationLine(event.value);
    //   if (transcriptLine != null && transcriptLine.isNotEmpty) {
    //
    //   }
    //   debugPrint('Message: ${event.value}');
    // }
  }

  // String? _extractConversationLine(dynamic value) {
  //   if (value is String) {
  //     return value.trim();
  //   }
  //
  //   if (value is Map<String, dynamic>) {
  //     final role = value['role']?.toString();
  //     final text =
  //         value['transcript'] ??
  //         value['message'] ??
  //         value['content'] ??
  //         value['text'];
  //
  //     String extractedText = '';
  //     if (text is String) {
  //       extractedText = text;
  //     } else if (text is List) {
  //       extractedText = text.map((item) => item.toString()).join(' ');
  //     } else if (text is Map<String, dynamic>) {
  //       extractedText = (text['text'] ?? text['content'] ?? '').toString();
  //     }
  //
  //     extractedText = extractedText.trim();
  //     if (extractedText.isEmpty) {
  //       return null;
  //     }
  //
  //     if (role != null && role.isNotEmpty) {
  //       return '$role: $extractedText';
  //     }
  //     return extractedText;
  //   }
  //
  //   return null;
  // }

  Future<void> stopCall() async {
    if (currCall == null) {
      return;
    }

    await currCall!.stop();
    if (!mounted) {
      return;
    }

    setState(() {
      currCall = null;
      isCallStarted = false;
      ref.read(interviewProvider.notifier).stopInterview();
    });
  }

  @override
  Widget build(BuildContext context) {
    final interviewState = ref.watch(interviewProvider);
    final activeGradient = _gradientForState(interviewState);
    final reportStatus = ref.watch(reportState);
    final reports = ref.watch(reportProvider);
    final latestReport = reports.isNotEmpty ? reports.first : null;
    return Scaffold(
      body: MouseRegion(
        onHover: (event) {
          final size = MediaQuery.sizeOf(context);
          setState(() {
            _pointer = Offset(
              (event.localPosition.dx / size.width).clamp(0.0, 1.0),
              (event.localPosition.dy / size.height).clamp(0.0, 1.0),
            );
          });
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 740;
            final parallaxX = (_pointer.dx - 0.5) * 48;
            final parallaxY = (_pointer.dy - 0.5) * 48;

            return Stack(
              fit: StackFit.expand,
              children: [
                _AnimatedBackdrop(
                  colors: activeGradient,
                  parallaxX: parallaxX,
                  parallaxY: parallaxY,
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight * 0.08,
                      horizontal:
                          constraints.maxWidth * (isNarrow ? 0.08 : 0.1),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      switchInCurve: Curves.easeOutQuart,
                      switchOutCurve: Curves.easeInQuart,
                      child: switch (interviewState) {
                        InterviewState.idle => _IdleContent(
                          key: const ValueKey<String>('idle'),
                          isNarrow: isNarrow,
                          onStart: () async {
                            Get.dialog(
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF1EDC75),
                                ),
                              ),
                              barrierDismissible: false,
                            );

                            await startCall();

                            if (mounted) {
                              ref
                                  .read(interviewProvider.notifier)
                                  .startInterview();
                              if (Get.isDialogOpen ?? false) {
                                Get.back();
                              }
                            }
                          },
                        ),
                        InterviewState.loading => const Center(
                          key: ValueKey<String>('loading'),
                          child: CircularProgressIndicator(
                            color: Color(0xFF14B85E),
                          ),
                        ),
                        InterviewState.started => _InCallContent(
                          key: const ValueKey<String>('started'),
                          currentSpeaker: currentSpeaker,
                          isNarrow: isNarrow,
                          onEndCall: () async {
                            await stopCall();
                          },
                        ),
                        InterviewState.ended => _EndedContent(
                          key: const ValueKey<String>('ended'),
                          isNarrow: isNarrow,
                          reportStatus: reportStatus,
                          report: latestReport,
                          errorMessage: ref
                              .read(reportState.notifier)
                              .errorMessage,
                          onRetry: () {
                            // final user = ref.read(userProvider);
                            // ref
                            //     .read(reportState.notifier)
                            //     .saveConversationAndGenerateReport(
                            //       conversation: _lastConversation,
                            //       userId: user?.id,
                            //     );
                          },
                          onReset: () {
                            ref.read(interviewProvider.notifier).reset();
                            ref.read(reportState.notifier).reset();
                          },
                        ),
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedBackdrop extends StatefulWidget {
  const _AnimatedBackdrop({
    required this.colors,
    required this.parallaxX,
    required this.parallaxY,
  });

  final List<Color> colors;
  final double parallaxX;
  final double parallaxY;

  @override
  State<_AnimatedBackdrop> createState() => _AnimatedBackdropState();
}

class _AnimatedBackdropState extends State<_AnimatedBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _orbController;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _orbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.colors,
          stops: const [0.1, 0.55, 1.0],
        ),
      ),
      child: AnimatedBuilder(
        animation: _orbController,
        builder: (context, _) {
          final t = Curves.easeInOut.transform(_orbController.value);
          return Stack(
            children: [
              _ParallaxOrb(
                size: 320 + (26 * t),
                top: 70 + widget.parallaxY * 0.35,
                left: -80 + widget.parallaxX * 0.5,
                color: const Color(0xFF13C466).withValues(alpha: 0.28),
              ),
              _ParallaxOrb(
                size: 240 + (18 * (1 - t)),
                top: 180 - widget.parallaxY * 0.45,
                right: -30 - widget.parallaxX * 0.4,
                color: const Color(0xFF26EE84).withValues(alpha: 0.2),
              ),
              _ParallaxOrb(
                size: 420 + (35 * t),
                bottom: -160 - widget.parallaxY * 0.5,
                left: 40 + widget.parallaxX * 0.3,
                color: const Color(0xFF0EA556).withValues(alpha: 0.25),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.38),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ParallaxOrb extends StatelessWidget {
  const _ParallaxOrb({
    required this.size,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  final double size;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, color.withValues(alpha: 0.0)],
            ),
          ),
        ),
      ),
    );
  }
}

class _IdleContent extends StatelessWidget {
  const _IdleContent({
    super.key,
    required this.isNarrow,
    required this.onStart,
  });

  final bool isNarrow;
  final Future<void> Function() onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Text(
          'AI Interviewer',
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: isNarrow ? 34 : 46,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Step into futuristic interview prep with real-time voice coaching and adaptive questioning.',
          style: GoogleFonts.spaceGrotesk(
            color: const Color(0xFFCCF7DE),
            fontSize: isNarrow ? 15 : 18,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _TechPill(label: 'Live Voice AI'),
            _TechPill(label: 'Live Feedback'),
            _TechPill(label: 'Report Generation'),
          ],
        ),
        SizedBox(height: isNarrow ? 26 : 36),
        GestureDetector(
          onTap: onStart,
          child: Container(
            width: isNarrow ? double.infinity : 280,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFF0D7E44), Color(0xFF23E07A)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x6612CC6A),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Start Interview',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _TechPill extends StatelessWidget {
  const _TechPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.black.withValues(alpha: 0.22),
        border: Border.all(
          color: const Color(0xFF28D877).withValues(alpha: 0.45),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          color: const Color(0xFFC8F7DA),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _InCallContent extends StatelessWidget {
  const _InCallContent({
    super.key,
    required this.currentSpeaker,
    required this.isNarrow,
    required this.onEndCall,
  });

  final Speaker currentSpeaker;
  final bool isNarrow;
  final Future<void> Function() onEndCall;

  @override
  Widget build(BuildContext context) {
    final status = switch (currentSpeaker) {
      Speaker.user => 'You are speaking...',
      Speaker.assistant => 'AI is responding...',
      Speaker.none => 'Listening for voice activity...',
    };

    final pulseColor = switch (currentSpeaker) {
      Speaker.user => const Color(0xFF2DF58A),
      Speaker.assistant => const Color(0xFF14B85E),
      Speaker.none => const Color(0xFF7DDFA9),
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Interview Session Live',
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: isNarrow ? 23 : 29,
          ),
        ),
        const SizedBox(height: 26),
        VoiceBubble(color: pulseColor),
        const SizedBox(height: 20),
        Text(
          status,
          style: GoogleFonts.spaceGrotesk(
            color: const Color(0xFFC8F8DB),
            fontSize: isNarrow ? 15 : 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: onEndCall,
          child: Container(
            width: isNarrow ? double.infinity : 240,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withValues(alpha: 0.3),
              border: Border.all(
                color: const Color(0xFF52E593).withValues(alpha: 0.6),
              ),
            ),
            child: Center(
              child: Text(
                'End Call',
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: const Color(0xFFE4FFEE),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EndedContent extends StatelessWidget {
  const _EndedContent({
    super.key,
    required this.isNarrow,
    required this.onReset,
    required this.reportStatus,
    required this.report,
    required this.onRetry,
    this.errorMessage,
  });

  final bool isNarrow;
  final VoidCallback onReset;
  final VoidCallback onRetry;
  final ReportState reportStatus;
  final Report? report;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Interview Complete',
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: isNarrow ? 24 : 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          reportStatus == ReportState.beforeGenerating
              ? 'Saving conversation...'
              : reportStatus == ReportState.generating
              ? 'Generating your report...'
              : reportStatus == ReportState.error
              ? (errorMessage ?? 'Failed to generate report.')
              : 'Your report is ready below.',
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            color: const Color(0xFFD4FBE5),
            fontSize: isNarrow ? 14 : 16,
          ),
        ),
        const SizedBox(height: 28),
        if (reportStatus == ReportState.beforeGenerating ||
            reportStatus == ReportState.generating)
          const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: CircularProgressIndicator(color: Color(0xFF1BD877)),
          ),
        if (reportStatus == ReportState.ready && report != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0x5528D877)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tech Stack: ${report!.techstack}',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white),
                ),
                Text(
                  'Accuracy: ${report!.accuracy}',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white),
                ),
                Text(
                  'Fluency: ${report!.fluency}',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white),
                ),
                Text(
                  'Communication: ${report!.communication}',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white),
                ),
                Text(
                  'Strong Areas: ${report!.strongareas.join(', ')}',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white),
                ),
                Text(
                  'Weak Areas: ${report!.weakareas.join(', ')}',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white),
                ),
                Text(
                  'Improvements: ${report!.improvement.join(', ')}',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white),
                ),
                Text(
                  'Tips: ${report!.tips.join(', ')}',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white),
                ),
              ],
            ),
          ),
        if (reportStatus == ReportState.error)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: onRetry,
              child: Container(
                width: isNarrow ? double.infinity : 260,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withValues(alpha: 0.35),
                  border: Border.all(color: const Color(0x66FFFFFF)),
                ),
                child: Center(
                  child: Text(
                    'Retry Report',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        GestureDetector(
          onTap:
              reportStatus == ReportState.beforeGenerating ||
                  reportStatus == ReportState.generating
              ? () {}
              : onReset,
          child: Container(
            width: isNarrow ? double.infinity : 260,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: reportStatus == ReportState.beforeGenerating || reportStatus == ReportState.generating ? const [Color(0xFF0C6538), Color(0xFF1BD877)] :  [Colors.grey.shade800,Colors.grey.shade400],
              ),
            ),
            child: Center(
              child: Text(
                'Back to Home',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
