import 'package:flutter_riverpod/legacy.dart';

enum InterviewState{
  idle,
  loading,
  started,
  ended
}



class InterviewProvider extends StateNotifier<InterviewState>{
  InterviewProvider():super(InterviewState.idle);

  void startInterview(){
    state = InterviewState.started;
  }

  void stopInterview(){
    state = InterviewState.ended;
  }
  void reset(){
    state = InterviewState.idle;
  }

}

final interviewProvider = StateNotifierProvider<InterviewProvider, InterviewState>((ref) => InterviewProvider());