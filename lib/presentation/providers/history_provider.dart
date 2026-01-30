import 'package:flutter/material.dart';
import '../../domain/entities/history_item.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryRepository _repository;

  List<HistoryItem> _history = [];
  bool _isLoading = true;

  HistoryProvider(this._repository) {
    _loadHistory();
  }

  List<HistoryItem> get history => _history;
  bool get isLoading => _isLoading;

  Future<void> _loadHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      _history = await _repository.getHistory();
    } catch (e) {
      debugPrint(e.toString());
      _history = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _loadHistorySilent();
  }

  Future<void> _loadHistorySilent() async {
    try {
      _history = await _repository.getHistory();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _history = [];
    }
  }

  Future<void> addHistoryItem(HistoryItem item) async {
    await _repository.addToHistory(item);
    await _loadHistorySilent();
  }

  Future<void> deleteHistoryItem(String id) async {
    await _repository.deleteFromHistory(id);
    await _loadHistorySilent();
  }

  Future<void> toggleFavorite(String id) async {
    final index = _history.indexWhere((element) => element.id == id);
    if (index != -1) {
      _history[index].isFavorite = !_history[index].isFavorite;
      notifyListeners();
    }
    await _repository.toggleFavorite(id);
    await _loadHistorySilent();
  }
}
