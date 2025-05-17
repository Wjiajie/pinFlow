/// 传递给 EditorScreen 的参数。
///
/// 包含可选的 `noteId`。如果 `noteId` 为 null，则表示创建新笔记；
/// 否则，表示编辑具有该 ID 的现有笔记。
class NoteEditorArguments {
  final int? noteId;

  NoteEditorArguments({this.noteId});
}