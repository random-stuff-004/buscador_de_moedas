import 'dart:io';

class CheckInternet {
  /*Essa função faz um ping entre o nosso app e o site do google */
  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // se tiver internet
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false; // se não tiver internet
    }
  }
}
