import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/datasources/history_local_datasource.dart';
import 'data/repositories/history_repository_impl.dart';
import 'presentation/providers/history_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HistoryLocalDataSource>(
          create: (_) => HistoryLocalDataSourceImpl(),
        ),
        ProxyProvider<HistoryLocalDataSource, HistoryRepositoryImpl>(
          update: (_, dataSource, __) => HistoryRepositoryImpl(dataSource),
        ),
        ChangeNotifierProxyProvider<HistoryRepositoryImpl, HistoryProvider>(
          create: (context) => HistoryProvider(
            context.read<HistoryRepositoryImpl>(),
          ),
          update: (_, repo, previous) => HistoryProvider(repo),
        ),
      ],
      child: MaterialApp(
        title: 'DocScan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4F46E5), // Indigo
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF3F4F6),
          textTheme: GoogleFonts.interTextTheme(),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
