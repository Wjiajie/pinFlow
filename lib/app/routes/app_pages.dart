import 'package:get/get.dart';
import 'package:pinflow/app/modules/editor/editor_binding.dart'; // 稍后创建
import 'package:pinflow/app/modules/editor/editor_screen.dart'; // 稍后创建
import 'package:pinflow/app/modules/editor/note_editor_arguments.dart'; // 稍后创建
import 'package:pinflow/app/modules/home/home_binding.dart'; // 稍后创建
import 'package:pinflow/app/modules/home/home_screen.dart'; // 稍后创建
import 'package:pinflow/app/modules/search/search_binding.dart'; // 稍后创建
import 'package:pinflow/app/modules/search/search_screen.dart'; // 稍后创建
import 'package:pinflow/app/modules/view/view_binding.dart'; // 稍后创建
import 'package:pinflow/app/modules/view/view_screen.dart'; // 稍后创建
import 'app_routes.dart';

/// 定义应用的页面及其绑定 (Bindings)。
///
/// Bindings 用于在导航到特定页面时初始化该页面的 Controller 和其他依赖。
class AppPages {
  /// 应用的初始路由。
  static const INITIAL = Routes.HOME;

  /// 应用的所有路由配置。
  ///
  /// 每个 `GetPage` 定义了一个路由，包括名称、页面 Widget 的构造函数，
  /// 以及可选的 Binding 和参数。
  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(), // 主页 Widget
      binding: HomeBinding(), // 主页的依赖绑定
    ),
    GetPage(
      name: Routes.EDITOR,
      page: () => EditorScreen(), // 编辑器 Widget
      binding: EditorBinding(), // 编辑器的依赖绑定
      // arguments: NoteEditorArguments, // 定义参数类型，用于类型安全
    ),
    GetPage(
      name: Routes.VIEW,
      page: () => ViewScreen(), // 视图页面 Widget
      binding: ViewBinding(), // 视图页面的依赖绑定
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => SearchScreen(), // 搜索页面 Widget
      binding: SearchBinding(), // 搜索页面的依赖绑定
    ),
  ];
}