import 'package:get/get.dart';
import 'search_controller.dart';

/// SearchBinding 类负责为 SearchScreen 绑定其 Controller。
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(() => SearchController());
  }
}