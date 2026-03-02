import 'package:frontend/global_variable.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void initSocket(String userId) {
    socket = IO.io(
      uri,
      IO.OptionBuilder()
          .setTransports(["websocket"])
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print('Socket connected: ${socket.id}');
      socket.emit('join', userId); // Join user room
    });

    socket.onConnectError((err) => print('Connect Error: $err'));
    socket.onError((err) => print('Socket Error: $err'));
    socket.onDisconnect((_) => print('Socket disconnected'));
  }

  void generateReport({required Function(dynamic) callBack}) {
    socket.on("report", callBack);
  }

  void generating({required Function(dynamic) callBack}) {
    socket.on("generating", callBack);
  }

  void dispose() {
    socket.dispose();
  }
}
