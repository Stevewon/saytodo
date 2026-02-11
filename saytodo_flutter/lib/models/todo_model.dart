import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final bool isCompleted;
  final String category;
  final int priority; // 1: 높음, 2: 보통, 3: 낮음
  final DateTime createdAt;
  final DateTime? dueDate;

  TodoModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.category = '일반',
    this.priority = 2,
    required this.createdAt,
    this.dueDate,
  });

  // Firestore에서 읽기
  factory TodoModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TodoModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      isCompleted: data['isCompleted'] ?? false,
      category: data['category'] ?? '일반',
      priority: data['priority'] ?? 2,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      dueDate: data['dueDate'] != null 
          ? (data['dueDate'] as Timestamp).toDate() 
          : null,
    );
  }

  // Firestore에 쓰기
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'category': category,
      'priority': priority,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
    };
  }

  // 복사 메서드
  TodoModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    bool? isCompleted,
    String? category,
    int? priority,
    DateTime? createdAt,
    DateTime? dueDate,
  }) {
    return TodoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  // 우선순위 색상
  String get priorityColor {
    switch (priority) {
      case 1:
        return '#EF4444'; // 빨강 (높음)
      case 2:
        return '#F59E0B'; // 주황 (보통)
      case 3:
        return '#10B981'; // 초록 (낮음)
      default:
        return '#6B7280'; // 회색
    }
  }

  // 우선순위 텍스트
  String get priorityText {
    switch (priority) {
      case 1:
        return '높음';
      case 2:
        return '보통';
      case 3:
        return '낮음';
      default:
        return '없음';
    }
  }
}
