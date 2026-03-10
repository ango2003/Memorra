class GiftList {
  final String id;
  final String recipient;

  GiftList({
    required this.id,
    required this.recipient,
  });

  factory GiftList.fromFirestore(Map<String, dynamic> data, String id) {
    return GiftList(
      id: id,
      recipient: data['gift_recipient'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'gift_recipient': recipient,
    };
  }
}