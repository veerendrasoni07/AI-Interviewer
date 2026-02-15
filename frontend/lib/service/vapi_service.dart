
import 'package:vapi/vapi.dart';

class VapiService {
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
}
