import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';  // 添加 GetX 的导入
import 'package:pinflow/app/data/models/note_document.dart';
import 'package:pinflow/app/data/models/folder.dart';
import 'package:pinflow/app/data/models/space.dart';

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
  }

  /// 打开 Isar 数据库。
  ///
  /// 如果 Isar 实例尚不存在，则会创建一个新的实例。
  /// 数据库文件将存储在应用文档目录中。
  Future<Isar> _openDB() async {
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
    // Isar 的写操作需要在事务中执行
    await isar.writeTxn(() async {
      await isar.noteDocuments.put(note); // `put` 会插入新对象或更新已存在的对象
      // 如果笔记关联了文件夹，确保文件夹链接也被保存
      if (note.folder.value != null) {
        await note.folder.save();
      }
    });
  }

  /// 根据 ID 获取一个笔记。
  ///
  /// @param id 笔记的 ID。
  /// @return 返回找到的 NoteDocument 对象，如果未找到则返回 null。
  Future<NoteDocument?> getNoteById(int id) async {
    final isar = await db;
    return await isar.noteDocuments.get(id);
  }

  /// 获取所有笔记。
  ///
  /// @return 返回包含所有 NoteDocument 对象的列表。
  Future<List<NoteDocument>> getAllNotes() async {
    final isar = await db;
    return await isar.noteDocuments.where().findAll();
  }
  
  /// 根据 ID 删除一个笔记。
  ///
  /// @param id 要删除的笔记的 ID。
  /// @return 如果删除成功返回 true，否则返回 false。
  Future<bool> deleteNote(int id) async {
    final isar = await db;
    return await isar.writeTxn(() async => await isar.noteDocuments.delete(id));
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