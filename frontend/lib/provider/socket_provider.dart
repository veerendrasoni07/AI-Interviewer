import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/service/socket_service.dart';

final socketProvider = Provider<SocketService>((ref)  {
  final SocketService socketService = SocketService();
  final user = ref.read(userProvider);
  socketService.initSocket(user!.id);
  ref.onDispose(
      ()=> socketService.dispose()
  );
  return socketService;
});