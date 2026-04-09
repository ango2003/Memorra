class GiftList {
  final String id;
  final String recipient;

  GiftList({required this.id, required this.recipient});

  factory GiftList.fromJson(Map<String, dynamic> json) {
    return GiftList(
      id: json['id'] ?? '',
      recipient: json['gift_recipient'] ?? json['recipient'] ?? '',
    );
  }

  factory GiftList.fromFirestore(Map<String, dynamic> data, String id) {
    return GiftList(id: id, recipient: data['gift_recipient'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'gift_recipient': recipient};
  }

  Map<String, dynamic> toFirestore() {
    return {'gift_recipient': recipient};
  }
}
