import 'package:isar/isar.dart';
import 'note_document.dart';
import 'space.dart'; // 我们稍后会创建这个文件

part 'folder.g.dart'; // 将由 Isar 生成器创建

/// 代表一个包含笔记的文件夹。
///
/// 包含文件夹的名称、创建时间、指向其所属空间的链接，
/// 以及一个反向链接到此文件夹下的所有笔记。
@collection
class Folder {
  /// Isar 自动生成的唯一 ID。
  Id id = Isar.autoIncrement;

  /// 文件夹的名称。
  late String name;

  /// 文件夹的创建时间。
  late DateTime createdAt;

  /// 指向父空间的链接。
  final space = IsarLink<Space>();

  /// 指向此文件夹中所有笔记的反向链接。
  ///
  /// `@Backlink` 注解用于定义从 `NoteDocument` 的 `folder` 字段反向链接回来的关系。
  @Backlink(to: "folder")
  final notes = IsarLinks<NoteDocument>();

  /// Folder 的构造函数。
  Folder({
    required this.name,
    required this.createdAt,
  });
}