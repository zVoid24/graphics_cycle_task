import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/history_item.dart';

abstract class HistoryLocalDataSource {
  Future<List<HistoryItem>> getHistory();
  Future<bool> saveHistory(List<HistoryItem> items);
  Future<void> deleteFile(String path);
  Future<bool> fileExists(String path);
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  static const String _storageKey = 'pdf_history';

  @override
  Future<List<HistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyString = prefs.getString(_storageKey);
    if (historyString == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(historyString);
      return decoded.map((e) => HistoryItem.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> saveHistory(List<HistoryItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    return await prefs.setString(_storageKey, encoded);
  }

  @override
  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      try {
        await file.delete();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }
}
