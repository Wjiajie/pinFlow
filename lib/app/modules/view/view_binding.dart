import 'package:get/get.dart';
import 'view_controller.dart';

/// ViewBinding 类负责为 ViewScreen 绑定其 Controller。
class ViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewController>(() => ViewController());
  }
}