class HistoryItem {
  final String id;
  final String filePath;
  final DateTime date;
  final String name;
  bool isFavorite;

  HistoryItem({
    required this.id,
    required this.filePath,
    required this.date,
    required this.name,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'filePath': filePath,
        'date': date.toIso8601String(),
        'name': name,
        'isFavorite': isFavorite,
      };

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        id: json['id'],
        filePath: json['filePath'],
        date: DateTime.parse(json['date']),
        name: json['name'],
        isFavorite: json['isFavorite'] ?? false,
      );
}
