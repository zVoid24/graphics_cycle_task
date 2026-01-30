import '../entities/history_item.dart';

abstract class HistoryRepository {
  Future<List<HistoryItem>> getHistory();
  Future<void> addToHistory(HistoryItem item);
  Future<void> deleteFromHistory(String id);
  Future<void> toggleFavorite(String id);
}
