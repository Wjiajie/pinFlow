import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 应用设置对话框。
///
/// 目前仅为占位符，未来可添加主题切换、数据同步等设置项。
class SettingsDialog extends StatelessWidget {
  // SettingsDialog 的构造函数
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('设置'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('这里是设置浮窗。'),
            Text('功能后续扩展。'),
            // 例如：主题切换选项
            // SwitchListTile(
            //   title: Text('深色模式'),
            //   value: Get.isDarkMode,
            //   onChanged: (bool value) {
            //     Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            //     // TODO: 使用 shared_preferences 保存主题设置
            //   },
            // ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('关闭'),
          onPressed: () {
            Get.back(); // 关闭对话框
          },
        ),
      ],
    );
  }
}