import '../services/connections_service.dart';

class InviteService {
  InviteService.privateConstructor();
  static final InviteService instance = InviteService.privateConstructor();

  Future<String> createInviteURL() async {
    final token = await ConnectionsService.instance.createInvite(Duration(hours: 24));
    final url = Uri(
      scheme: 'memorra',
      host: 'invite',
      queryParameters: {
        'token': token,
      },
    );

    return url.toString();
  }

  String? extractToken(Uri url) {
    return url.queryParameters['token'];
  }

  Future<bool> redeemInvite(String token) async {
    return ConnectionsService.instance.redeemInvite(token);
  }
}