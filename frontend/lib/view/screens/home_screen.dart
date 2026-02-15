import 'package:flutter/material.dart';
import 'package:frontend/service/vapi_service.dart';
import 'package:vapi/vapi.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  VapiClient vapi = VapiClient('8998d14b-ae71-4f0b-96b0-990630839463');
  VapiCall? currCall;


  Future<void> startCall() async{
    var call = await vapi.start(
        assistantId: "49677832-4bb5-43bd-8300-2e614ee7dad6"
    );
    currCall = call;
  }
  Future<void> stopCall() async{
    await currCall!.stop();
  }

  bool isInterviewStarted = false;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Row(
              children: [

                isInterviewStarted ? ElevatedButton(
                  onPressed: () {
                    VapiService().stopCall();
                    setState(() {
                      isInterviewStarted = false;
                    });
                  },
                  child: const Text('Stop Interview'),
                ) :

                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Center(child: CircularProgressIndicator());
                      },
                    );
                    setState(() {
                      isInterviewStarted = true;
                    });
                    VapiService().startCall();
                    Navigator.pop(context);
                  },
                  child: const Text('Start Interview'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
