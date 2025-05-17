import 'package:get/get.dart';
import 'editor_controller.dart';

/// EditorBinding 类负责为 EditorScreen 绑定其 Controller。
class EditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditorController>(() => EditorController());
  }
}