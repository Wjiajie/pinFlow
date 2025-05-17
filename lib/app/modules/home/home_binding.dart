import 'package:get/get.dart';
import 'home_controller.dart';

/// HomeBinding 类负责为 HomeScreen 绑定其 Controller。
///
/// 当导航到 HomeScreen 时，GetX 会自动查找并实例化这个 Binding，
/// 然后调用 `dependencies()` 方法来注册 HomeController。
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // 使用 Get.lazyPut 懒加载 HomeController。
    // 这意味着 HomeController 只在第一次被访问时才会被创建。
    Get.lazyPut<HomeController>(() => HomeController());
  }
}