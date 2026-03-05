// import 'dart:convert';
// import 'dart:developer';
//
//
// import 'package:flutter/foundation.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// class WebSocketClient {
//   WebSocketChannel? _channel;
//   Function(String)? onMessageRecived;
//
//   //Initialize Socket
//   void connect(String socketUrl) {
//     _channel = WebSocketChannel.connect(Uri.parse(socketUrl));
//
//     _channel?.stream.listen(
//           (message) {
//
//
//         onMessageRecived?.call(message);
//       },
//       onError: (error) => debugPrint("Websocket error: $error"),
//       onDone: () => log("Websocket connection closed"),
//     );
//     //
//     debugPrint("Websocket connected to $socketUrl");
//   }
//
// //Join room
//   void joinRoom(String user1Id, String user2Id) {
//     final message = jsonEncode({
//       "type": "joinRoom",
//       "user1Id": user1Id,
//       "user2Id": user2Id,
//     });
//     _channel?.sink.add(message);
//
//     if (kDebugMode) {
//       log("-------------- Joined room with user1Id: $user1Id and user2Id: $user2Id");
//     }
//   }
//
// //To view a room conversation
//   void viewMessage(String chatroomId, String userId) {
//     final message = jsonEncode({
//       "type": "viewMessage",
//       "chatroomId": chatroomId,
//       "userId": userId,
//     });
//
//     _channel?.sink.add(message);
//     if (kDebugMode) {
//       log("View message sent for chatroomid: $chatroomId");
//     }
//   }
//
//   // Send Message
//   void sendMessage(Map<String, dynamic> message) {
//     //Encode the message body
//     final encodedMessage = jsonEncode(message);
//
//     _channel?.sink.add(encodedMessage);
//
//     log("message sent: $encodedMessage");
//   }
//
//   // Disconnect from socket
//   void disconnect() {
//     try {
//       _channel?.sink.close(1000);
//       log("Websoket connection closed");
//     } catch (e) {
//       debugPrint("Error closing Websocket: $e");
//     }
//   }
//
//   //Callback function for incoming message
//   void setOnMessageReceived(Function(String) callback) {
//     onMessageRecived = callback;
//   }
// }