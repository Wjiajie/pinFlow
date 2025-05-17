import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinflow/app/core/services/database_service.dart'; // 我们稍后会创建这个文件
import 'package:pinflow/app/routes/app_pages.dart'; // 我们稍后会创建这个文件
import 'package:flutter_localizations/flutter_localizations.dart'; // 通常已经存在
import 'package:flutter_quill/flutter_quill.dart'; // 添加或确保此导入存在
import 'package:flutter/foundation.dart'; // For kReleaseMode
import 'package:logger/logger.dart'; // Import Logger for level setting
import 'package:pinflow/app/core/utils/logger_service.dart'; // 导入 AppLogger (如果需要在这里调用)


/// 应用主入口函数
///
/// 初始化必要的服务并运行应用。
Future<void> main() async {
  // 确保 Flutter 绑定已初始化，这对于在 runApp 之前执行异步操作是必需的
  WidgetsFlutterBinding.ensureInitialized();

  // 设置 Logger 级别 (可选, AppLogger 内部已根据 kReleaseMode 设置)
  if (kReleaseMode) {
    Logger.level = Level.warning;
  } else {
    Logger.level = Level.trace;
  }
  AppLogger.info("Logger initialized. Release mode: $kReleaseMode, Log level: ${Logger.level}");


  // 初始化服务
  // 使用 Get.putAsync 异步初始化 DatabaseService (Isar)
  // 这确保在应用运行前数据库已准备好
  await Get.putAsync(() async => DatabaseService());

  runApp(const MyApp()); // 建议对 MyApp 使用 const 构造
}

/// 应用的根 Widget
///
/// 使用 GetMaterialApp 来集成 GetX 的路由和状态管理功能。
class MyApp extends StatelessWidget {
  /// MyApp 的构造函数
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PinFlow', // 应用标题
      debugShowCheckedModeBanner: false, // 移除调试横幅
      initialRoute: AppPages.INITIAL, // 设置初始路由，来自 app_pages.dart
      getPages: AppPages.routes, // 设置所有应用页面，来自 app_pages.dart
      theme: ThemeData( // 应用的默认主题
        primarySwatch: Colors.blue, // 主题颜色
        visualDensity: VisualDensity.adaptivePlatformDensity, // 适应不同平台的视觉密度
        useMaterial3: true, // 推荐使用 Material 3 设计
      ),
      // 你也可以定义 darkTheme:
      // darkTheme: ThemeData.dark().copyWith(
      //   primaryColor: Colors.blueGrey,
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey, brightness: Brightness.dark),
      //   useMaterial3: true,
      // ),
      // themeMode: ThemeMode.system, // 跟随系统主题设置
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate, // <--- 添加这一行
      ],
      supportedLocales: const [
        Locale('en', 'US'), // 英语
        Locale('zh', 'CN'), // 简体中文
        // ... 添加您应用支持的其他语言
      ],
    );
  }
}