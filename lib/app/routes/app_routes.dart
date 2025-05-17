/// 定义应用中使用的路由名称常量。
///
/// 使用抽象类和静态常量可以避免在代码中硬编码路由字符串，
/// 提高代码的可维护性和减少拼写错误。
abstract class Routes {
  static const HOME = '/home'; // 主页路由
  static const EDITOR = '/editor'; // 笔记编辑器路由
  static const VIEW = '/view'; // 视图页面路由 (例如日历、图谱)
  static const SEARCH = '/search'; // 搜索页面路由
  // static const SETTINGS = '/settings'; // 如果需要单独的设置页面
}