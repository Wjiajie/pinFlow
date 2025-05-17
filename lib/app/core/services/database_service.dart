import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';  // 添加 GetX 的导入
import 'package:pinflow/app/data/models/note_document.dart';
import 'package:pinflow/app/data/models/folder.dart';
import 'package:pinflow/app/data/models/space.dart';
import 'package:pinflow/app/core/utils/logger_service.dart'; // <--- 导入 AppLogger

/// 数据库服务类
///
/// 负责管理 Isar 数据库的初始化和操作。
class DatabaseService extends GetxService { // 继承 GetxService 以便 GetX 管理其生命周期
  /// Isar 数据库实例的 Future。
  ///
  /// 使用 Future 是因为数据库的打开是一个异步操作。
  late Future<Isar> db;

  /// DatabaseService 的构造函数。
  ///
  /// 在构造时调用 `_openDB` 初始化数据库。
  DatabaseService() {
    db = _openDB();
    AppLogger.info("DatabaseService initialized.");
  }

  /// 打开 Isar 数据库。
  ///
  /// 如果 Isar 实例尚不存在，则会创建一个新的实例。
  /// 数据库文件将存储在应用文档目录中。
  Future<Isar> _openDB() async {
    AppLogger.debug("_openDB called.");
    // 检查是否已经有名为 'pinflow_db' 的 Isar 实例
    if (Isar.instanceNames.isEmpty || Isar.getInstance('pinflow_db') == null) {
      final dir = await getApplicationDocumentsDirectory(); // 获取应用文档目录
      return await Isar.open(
        [NoteDocumentSchema, FolderSchema, SpaceSchema], // 注册所有数据模型的 Schema
        directory: dir.path, // 指定数据库存储路径
        name: 'pinflow_db', // 数据库实例的名称
      );
    }
    // 如果实例已存在，则返回该实例
    return Future.value(Isar.getInstance('pinflow_db'));
  }

  // --- NoteDocument CRUD 操作 ---

  /// 创建或更新一个笔记文档。
  ///
  /// @param note 要保存的 NoteDocument 对象。
  Future<void> saveNote(NoteDocument note) async {
    final isar = await db;
    AppLogger.debug("Saving note: ${note.title} (ID: ${note.id})", "DatabaseService.saveNote");
    try {
      await isar.writeTxn(() async {
        await isar.noteDocuments.put(note);
        // 移除可能导致事务嵌套的 folder.save() 调用（Isar 会自动处理关联关系）
        // if (note.folder.value != null) {
        //   await note.folder.save();
        // }
      });
      AppLogger.info("Note saved successfully: ${note.title} (ID: ${note.id})", "DatabaseService.saveNote");
    } catch (e, stackTrace) {
      AppLogger.error("Error saving note: ${note.title}", e, stackTrace);
      rethrow; // Re-throw the exception if you want calling code to handle it
    }
  }

  /// 根据 ID 获取一个笔记。
  ///
  /// @param id 笔记的 ID。
  /// @return 返回找到的 NoteDocument 对象，如果未找到则返回 null。
  Future<NoteDocument?> getNoteById(int id) async {
    final isar = await db;
    AppLogger.debug("Getting note by ID: $id", "DatabaseService.getNoteById");
    final note = await isar.noteDocuments.get(id);
    if (note == null) {
      AppLogger.warning("Note with ID $id not found.", "DatabaseService.getNoteById");
    } else {
      AppLogger.debug("Note found: ${note.title}", "DatabaseService.getNoteById");
    }
    return note;
  }

  /// 获取所有笔记。
  ///
  /// @return 返回包含所有 NoteDocument 对象的列表。
  Future<List<NoteDocument>> getAllNotes() async {
    final isar = await db;
    AppLogger.debug("Getting all notes.", "DatabaseService.getAllNotes");
    final notes = await isar.noteDocuments.where().findAll();
    AppLogger.info("Retrieved ${notes.length} notes.", "DatabaseService.getAllNotes");
    return notes;
  }
  
  /// 根据 ID 删除一个笔记。
  ///
  /// @param id 要删除的笔记的 ID。
  /// @return 如果删除成功返回 true，否则返回 false。
  Future<bool> deleteNote(int id) async {
    final isar = await db;
    AppLogger.debug("Deleting note with ID: $id", "DatabaseService.deleteNote");
    try {
      final success = await isar.writeTxn(() async => await isar.noteDocuments.delete(id));
      if (success) {
        AppLogger.info("Note with ID $id deleted successfully.", "DatabaseService.deleteNote");
      } else {
        AppLogger.warning("Failed to delete note with ID $id (not found or error).", "DatabaseService.deleteNote");
      }
      return success;
    } catch (e, stackTrace) {
      AppLogger.error("Error deleting note with ID $id", e, stackTrace);
      return false;
    }
  }

  // --- Folder CRUD 操作 (待实现) ---
  // Future<void> saveFolder(Folder folder) async { ... }
  // Future<Folder?> getFolderById(int id) async { ... }
  // Future<List<Folder>> getAllFoldersInSpace(int spaceId) async { ... }
  // Future<bool> deleteFolder(int id) async { ... }

  // --- Space CRUD 操作 (待实现) ---
  // Future<void> saveSpace(Space space) async { ... }
  // Future<Space?> getSpaceById(int id) async { ... }
  // Future<List<Space>> getAllSpaces() async { ... }
  // Future<bool> deleteSpace(int id) async { ... }
}