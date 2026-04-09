import '../services/connections_service.dart';

class DeepLinkService {
  DeepLinkService._privateConstructor();
  static final DeepLinkService instance = DeepLinkService._privateConstructor();

  Future<bool> handleIncomingLink(Uri uri) async {
    try {
      if (uri.scheme != 'memorra' || uri.host != 'invite') return false;

      final token = uri.queryParameters['token'];
      if (token == null) return false;

      // Redeem the invite via your existing ConnectionsService
      final success = await ConnectionsService.instance.redeemInvite(token);
      return success;
    } catch (e) {
      print('Failed to handle deep link: $e');
      return false;
    }
  }
}