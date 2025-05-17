import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinflow/app/modules/home/home_controller.dart';
import 'package:pinflow/app/widgets/app_drawer.dart'; // 稍后创建
import 'package:pinflow/app/modules/settings/settings_dialog.dart'; // 稍后创建

/// 应用的主屏幕 (HomeScreen)。
///
/// 使用 GetView<HomeController> 可以方便地访问 HomeController。
/// UI 结构基于用户提供的设计图。
class HomeScreen extends GetView<HomeController> {
  // HomeScreen 的构造函数
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PinFlow'), // 应用标题
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // 设置图标
            tooltip: '设置',
            onPressed: () {
              // 打开设置对话框
              Get.dialog(SettingsDialog());
            },
          ),
        ],
      ),
      drawer: AppDrawer(), // 应用侧边栏 (抽屉导航)
      body: Obx(() { // 使用 Obx 包裹需要响应 controller.notes 变化的 Widget
        if (controller.notes.isEmpty) {
          return const Center(child: Text('还没有笔记，点击 "+" 创建一个吧！'));
        }
        // 使用 ListView.builder 高效地显示笔记列表
        return ListView.builder(
          itemCount: controller.notes.length,
          itemBuilder: (context, index) {
            final note = controller.notes[index];
            return ListTile(
              title: Text(note.title),
              subtitle: Text('更新于: ${note.updatedAt.toLocal().toString().substring(0, 16)}'),
              onTap: () => controller.editNote(note), // 点击编辑笔记
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                tooltip: '删除笔记',
                onPressed: () => _confirmDeleteNoteDialog(context, note.id), // 点击删除笔记
              ),
            );
          },
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // FAB 居中停靠
      floatingActionButton: FloatingActionButton(
        onPressed: controller.createNewNote, // 点击创建新笔记
        tooltip: '新建笔记',
        child: const Icon(Icons.add),
        elevation: 2.0,
      ),
      bottomNavigationBar: BottomAppBar( // 底部应用栏
        shape: const CircularNotchedRectangle(), // 为 FAB 创建凹口
        notchMargin: 6.0, // 凹口边距
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildBottomNavItem(context, Icons.view_list_outlined, 'View', 0),
            const SizedBox(width: 48), // FAB 占用的空间
            _buildBottomNavItem(context, Icons.search_outlined, 'Search', 1),
          ],
        ),
      ),
    );
  }

  /// 构建底部导航栏项目。
  ///
  /// @param context 构建上下文。
  /// @param icon 图标数据。
  /// @param label 标签文本。
  /// @param index 导航项的索引。
  /// @return 返回一个 IconButton Widget。
  Widget _buildBottomNavItem(BuildContext context, IconData icon, String label, int index) {
    // 使用 Obx 包裹 IconButton，使其能够响应 selectedBottomNavIndex 的变化来更新颜色
    return Obx(() => IconButton(
          icon: Icon(
            icon,
            color: controller.selectedBottomNavIndex.value == index
                ? Theme.of(context).colorScheme.primary // 选中颜色
                : Colors.grey, // 未选中颜色
          ),
          tooltip: label,
          onPressed: () => controller.onBottomNavItemTapped(index),
        ));
  }

  /// 显示删除笔记确认对话框。
  ///
  /// @param context 构建上下文。
  /// @param noteId 要删除的笔记的 ID。
  void _confirmDeleteNoteDialog(BuildContext context, int noteId) {
    Get.defaultDialog(
      title: "确认删除",
      middleText: "你确定要删除这个笔记吗？此操作无法撤销。",
      textConfirm: "删除",
      textCancel: "取消",
      confirmTextColor: Colors.white,
      buttonColor: Theme.of(context).colorScheme.error, // 使用错误颜色作为确认按钮背景
      onConfirm: () {
        controller.deleteNote(noteId);
        Get.back(); // 关闭对话框
      },
      onCancel: () => Get.back(), // 关闭对话框
    );
  }
}