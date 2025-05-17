import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'search_controller.dart' as local;

/// 搜索屏幕 (SearchScreen)。
///
/// 用于提供传统搜索和 AI 搜索功能。
/// 目前为占位符。
class SearchScreen extends GetView<local.SearchController> {
  // SearchScreen 的构造函数
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索'),
      ),
      body: const Center(
        child: Text(
          '搜索功能待实现',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}