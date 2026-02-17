import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/animations/controller/home_controller.dart';
import 'package:frontend/components/voice_bubble.dart';
import 'package:frontend/provider/interview_state.dart';
import 'package:frontend/service/vapi_service.dart';
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
  
  VapiClient vapi = VapiClient('8998d14b-ae71-4f0b-96b0-990630839463');
  VapiCall? currCall;

  Future<void> startCall() async {
    var call = await vapi.start(
      assistantId: "49677832-4bb5-43bd-8300-2e614ee7dad6",
    );
    setState(() {
      currCall = call;
      currCall!.onEvent.listen(_handleCallEvents);
      isCallStarted = true;
      ref.read(interviewProvider.notifier).startInterview();
    });
  }


    void _handleCallEvents(VapiEvent event) {
      final data = event.value;
      final type = data['type'];
      // User starts speaking
      if (type == "voice-input") {
        setState(() {
          currentSpeaker = Speaker.user;
        });
      }

      // Assistant streaming response
      if (type == "model-output") {
        setState(() {
          currentSpeaker = Speaker.assistant;
        });
      }

      if (event.label == "call-end") {
        setState(() {
          currentSpeaker = Speaker.none;
        });
      }
      if (event.label == "call-start") {
      setState(() {
        currentSpeaker=type;
        buttonText = 'End Call';
        isLoading = false;
        isCallStarted = true;
      });
      debugPrint('call started');
    }

    if (event.label == "call-end") {
      setState(() {
        buttonText = 'Start Call';
        isLoading = false;
        isCallStarted = false;
        currCall = null;
      });
      debugPrint('call ended');
    }
    if (event.label == "message") {
      debugPrint('Message: ${event.value}');
    }
  }
  

  Future<void> stopCall() async {
    await currCall!.stop();
    setState(() {
      currCall = null;
      isCallStarted = false;
      ref.read(interviewProvider.notifier).stopInterview();
    });
  }
  bool isInterviewStarted = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final interviewState = ref.watch(interviewProvider);
    return AnimatedBuilder(
      animation: HomeController(),
      builder: (context, snapshot) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                 switch(interviewState){
                  InterviewState.idle => Padding(
                    padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.1, horizontal: constraints.maxWidth * 0.1),
                    child: Column(
                      children: [
                        Text("Ace your next interview with AI Interviewer\n- your personal interview coach! ",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.notoSansSymbols(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        Spacer(),
                        GestureDetector(
                          onTap: () async{
                            showDialog(context: context, builder: (context){
                              return Center(child: CircularProgressIndicator(),);
                            });
                            await startCall();
                            ref.read(interviewProvider.notifier).startInterview();
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: constraints.maxWidth * 0.5,
                            height: constraints.maxHeight * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.cyan,
                            ),
                            child: Center(
                              child: Text("Start Interview",style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),),
                            ),
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                  ),
                  InterviewState.loading => Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  InterviewState.started => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            if (currentSpeaker == Speaker.user)
                              VoiceBubble(color: Colors.cyan),

                            if (currentSpeaker == Speaker.assistant)
                              VoiceBubble(color: Colors.deepPurple),

                          ],
                        ),
                      ),
                      ElevatedButton(onPressed: ()async{
                        await stopCall();
                        ref.read(interviewProvider.notifier).stopInterview();
                      }, child: Text("End Call"))
                    ],
                  ),
                
                  
                  InterviewState.ended => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text("Interview Ended"),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            ref.read(interviewProvider.notifier).reset();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.cyan,
                            ),
                            width: constraints.maxWidth * 0.5,
                            height: constraints.maxHeight * 0.05,
                            child: const Center(
                              child: Text("Back to Home"),
                            ),
                            ),
                        ),
                      ),
                    ],
                  )
                 }
                ],
              );
            },
          ),
        );
      },
    );
  }
}
