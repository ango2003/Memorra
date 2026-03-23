import '../services/invite_service.dart';

class DeepLinkService {
  DeepLinkService.privateConstructor();
  static final DeepLinkService instance = DeepLinkService.privateConstructor();

  Future<bool> handleIncomingLink(Uri url) async {
    final token = InviteService.instance.extractToken(url);
    if (token == null) {
      return Future.value(false);
    }
    return await InviteService.instance.redeemInvite(token);
  }
}