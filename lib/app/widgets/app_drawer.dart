import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinflow/app/modules/settings/settings_dialog.dart';

/// 应用的侧边栏 (抽屉导航)。
///
/// 未来将用于显示空间、文件夹和文件等导航项。
class AppDrawer extends StatelessWidget {
  // AppDrawer 的构造函数
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer, // 使用主题颜色
            ),
            child: Text(
              'PinFlow 导航',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.space_dashboard_outlined),
            title: const Text('当前空间 (占位符)'),
            onTap: () {
              // TODO: 实现空间切换或管理功能
              Get.back(); // 关闭抽屉
              Get.snackbar('提示', '空间功能待实现');
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('文件夹 (占位符)'),
            onTap: () {
              // TODO: 实现文件夹导航
              Get.back();
              Get.snackbar('提示', '文件夹功能待实现');
            },
          ),
          // 可以用 ExpansionTile 来实现可展开的文件夹/文件列表
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('设置'),
            onTap: () {
              Get.back(); // 先关闭抽屉
              Get.dialog(SettingsDialog()); // 再打开设置对话框
            },
          ),
        ],
      ),
    );
  }
}