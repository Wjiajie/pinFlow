import 'package:isar/isar.dart';
import 'folder.dart';

part 'space.g.dart'; // 将由 Isar 生成器创建

/// 代表一个包含文件夹的空间。
///
/// 包含空间的名称、创建时间，以及一个反向链接到此空间下的所有文件夹。
@collection
class Space {
  /// Isar 自动生成的唯一 ID。
  Id id = Isar.autoIncrement;

  /// 空间的名称。
  late String name;

  /// 空间的创建时间。
  late DateTime createdAt;

  /// 指向此空间中所有文件夹的反向链接。
  ///
  /// `@Backlink` 注解用于定义从 `Folder` 的 `space` 字段反向链接回来的关系。
  @Backlink(to: "space")
  final folders = IsarLinks<Folder>();

  /// Space 的构造函数。
  Space({
    required this.name,
    required this.createdAt,
  });
}