import '../../domain/entities/history_item.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource dataSource;

  HistoryRepositoryImpl(this.dataSource);

  @override
  Future<List<HistoryItem>> getHistory() async {
    final items = await dataSource.getHistory();
    final existenceResults = await Future.wait(
      items.map((item) => dataSource.fileExists(item.filePath)),
    );

    final verifiedItems = <HistoryItem>[];
    bool changesMade = false;

    for (int i = 0; i < items.length; i++) {
      if (existenceResults[i]) {
        verifiedItems.add(items[i]);
      } else {
        changesMade = true;
      }
    }

    if (changesMade) {
      await dataSource.saveHistory(verifiedItems);
    }
    verifiedItems.sort((a, b) => b.date.compareTo(a.date));

    return verifiedItems;
  }

  @override
  Future<void> addToHistory(HistoryItem item) async {
    final items = await getHistory();
    items.removeWhere((element) => element.filePath == item.filePath);

    items.insert(0, item);
    await dataSource.saveHistory(items);
  }

  @override
  Future<void> deleteFromHistory(String id) async {
    final items = await getHistory();
    final itemIndex = items.indexWhere((element) => element.id == id);
    if (itemIndex == -1) return;

    final itemToDelete = items[itemIndex];

    await dataSource.deleteFile(itemToDelete.filePath);

    items.removeAt(itemIndex);
    await dataSource.saveHistory(items);
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final items = await getHistory();
    final index = items.indexWhere((element) => element.id == id);
    if (index != -1) {
      items[index].isFavorite = !items[index].isFavorite;
      await dataSource.saveHistory(items);
    }
  }
}
