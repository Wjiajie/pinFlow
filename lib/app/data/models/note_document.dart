import 'package:isar/isar.dart';
import 'folder.dart'; // 我们稍后会创建这个文件

part 'note_document.g.dart'; // 将由 Isar 生成器创建

/// 代表一个笔记文档。
///
/// 包含笔记的标题、内容 (Quill Delta JSON 格式)、创建和更新时间戳，
/// 以及指向其所属文件夹的链接。
@collection
class NoteDocument {
  /// Isar 自动生成的唯一 ID。
  Id id = Isar.autoIncrement;

  /// 笔记的标题。
  late String title;

  /// 存储 Quill Delta 的 JSON 字符串。
  ///
  /// Delta 是 flutter_quill 编辑器用来表示富文本内容的数据结构。
  String? contentDeltaJson;

  /// 存储 Markdown 格式的内容 (可选)。
  ///
  /// 可以从 `contentDeltaJson` 转换得到，或者直接存储。
  String? markdownContent;
  
  /// 笔记的创建时间。
  late DateTime createdAt;

  /// 笔记的最后更新时间。
  late DateTime updatedAt;

  /// 指向父文件夹的链接。
  ///
  /// IsarLink 用于表示与其他集合对象的一对一或一对多关系。
  final folder = IsarLink<Folder>();

  /// NoteDocument 的构造函数。
  NoteDocument({
    required this.title,
    this.contentDeltaJson,
    this.markdownContent,
    required this.createdAt,
    required this.updatedAt,
  });
}