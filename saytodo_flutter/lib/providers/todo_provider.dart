import 'package:flutter/foundation.dart';
import 'package:saytodo_flutter/models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  List<TodoModel> _todos = [];
  bool _isLoading = false;
  String? _error;

  List<TodoModel> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 완료된 Todo
  List<TodoModel> get completedTodos =>
      _todos.where((todo) => todo.isCompleted).toList();

  // 미완료 Todo
  List<TodoModel> get pendingTodos =>
      _todos.where((todo) => !todo.isCompleted).toList();

  // Todo 목록 로드 (임시 데이터)
  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Firebase에서 실제 데이터 로드
      await Future.delayed(const Duration(seconds: 1));
      
      // 임시 데이터
      _todos = [
        TodoModel(
          id: '1',
          userId: 'user1',
          title: '장보기',
          description: '우유, 계란, 빵 사기',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          priority: 1,
          category: '생활',
        ),
        TodoModel(
          id: '2',
          userId: 'user1',
          title: '운동하기',
          description: '헬스장 가기',
          createdAt: DateTime.now(),
          priority: 2,
          category: '건강',
        ),
      ];

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Todo 추가
  Future<void> addTodo(TodoModel todo) async {
    try {
      _todos.add(todo);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Todo 완료 토글
  Future<void> toggleTodo(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        isCompleted: !_todos[index].isCompleted,
      );
      notifyListeners();
    }
  }

  // Todo 삭제
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  // Todo 수정
  Future<void> updateTodo(String id, TodoModel updatedTodo) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }
}
