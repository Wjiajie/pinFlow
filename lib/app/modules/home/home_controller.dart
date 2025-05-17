import 'package:get/get.dart';
import 'package:pinflow/app/core/services/database_service.dart';
import 'package:pinflow/app/data/models/note_document.dart';
import 'package:pinflow/app/modules/editor/note_editor_arguments.dart'; // 稍后创建
import 'package:pinflow/app/routes/app_routes.dart';

/// HomeScreen 的控制器。
///
/// 管理 HomeScreen 的状态和业务逻辑，例如加载笔记、处理用户交互等。
class HomeController extends GetxController {
  /// 数据库服务实例，通过 Get.find() 获取。
  final DatabaseService _dbService = Get.find();

  /// 存储笔记列表的可观察变量。
  ///
  /// 使用 `.obs` 使其成为 GetX 的可观察对象，当其值改变时，
  /// 依赖于它的 UI 组件会自动更新。
  var notes = <NoteDocument>[].obs;

  /// 当前底部导航栏选中的索引。
  var selectedBottomNavIndex = 0.obs; // 0 for View, 1 for Search

  /// Controller 初始化时调用。
  @override
  void onInit() {
    super.onInit();
    loadNotes(); // 初始化时加载笔记列表
  }

  /// 从数据库加载所有笔记。
  void loadNotes() async {
    notes.value = await _dbService.getAllNotes();
  }

  /// 导航到编辑器页面以创建新笔记。
  void createNewNote() {
    // 导航到 EDITOR 路由，不传递参数表示创建新笔记
    Get.toNamed(Routes.EDITOR, arguments: NoteEditorArguments(noteId: null));
  }

  /// 导航到编辑器页面以编辑现有笔记。
  ///
  /// @param note 要编辑的 NoteDocument 对象。
  void editNote(NoteDocument note) {
    // 导航到 EDITOR 路由，并传递笔记 ID 作为参数
    Get.toNamed(Routes.EDITOR, arguments: NoteEditorArguments(noteId: note.id));
  }
  
  /// 删除一个笔记。
  ///
  /// @param noteId 要删除的笔记的 ID。
  void deleteNote(int noteId) async {
    await _dbService.deleteNote(noteId);
    loadNotes(); // 删除后重新加载笔记列表以更新 UI
  }

  /// 处理底部导航栏项目的点击事件。
  ///
  /// @param index 被点击的导航项的索引。
  void onBottomNavItemTapped(int index) {
    selectedBottomNavIndex.value = index;
    if (index == 0) { // "View" 按钮
      Get.toNamed(Routes.VIEW);
    } else if (index == 1) { // "Search" 按钮
      Get.toNamed(Routes.SEARCH);
    }
    // 注意：这里的 selectedBottomNavIndex 主要是为了UI上高亮当前选中的底部按钮，
    // 实际的页面切换是通过 Get.toNamed 完成的。
    // 如果底部导航栏本身就是用来切换当前屏幕的主要内容（而不是打开新页面），
    // 那么这里的逻辑会更复杂，可能需要管理一个 PageView 或类似的组件。
    // 根据设计图，这里的 View 和 Search 更像是打开新页面的快捷方式。
  }
}