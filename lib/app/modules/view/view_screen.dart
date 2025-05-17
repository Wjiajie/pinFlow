import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view_controller.dart';

/// 视图屏幕 (ViewScreen)。
///
/// 用于展示笔记的不同视图，例如贡献日历、关系图谱等。
/// 目前为占位符。
class ViewScreen extends GetView<ViewController> {
  // ViewScreen 的构造函数
  const ViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('视图'),
      ),
      body: const Center(
        child: Text(
          '视图功能待实现',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}