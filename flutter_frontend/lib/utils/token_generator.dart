import 'dart:math';

class TokenGenerator {
  static final Random _random = Random.secure();
  static const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  static String generateToken(int length) {
    return List.generate(length, (_) => chars[_random.nextInt(chars.length)]).join();
  }
}