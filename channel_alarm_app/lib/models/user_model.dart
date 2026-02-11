class AppUser {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final List<String> channelIds;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.channelIds,
    this.fcmToken,
    required this.createdAt,
    required this.lastLoginAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'channelIds': channelIds,
      'fcmToken': fcmToken,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      photoUrl: map['photoUrl'],
      channelIds: List<String>.from(map['channelIds'] ?? []),
      fcmToken: map['fcmToken'],
      createdAt: DateTime.parse(map['createdAt']),
      lastLoginAt: DateTime.parse(map['lastLoginAt']),
    );
  }
}
