class Channel {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final String ownerName;
  final List<String> memberIds;
  final String inviteCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.ownerName,
    required this.memberIds,
    required this.inviteCode,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'memberIds': memberIds,
      'inviteCode': inviteCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      memberIds: List<String>.from(map['memberIds'] ?? []),
      inviteCode: map['inviteCode'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String getInviteLink() {
    return 'https://channelalarm.app/invite/$inviteCode';
  }
}
