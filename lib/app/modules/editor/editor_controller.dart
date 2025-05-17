import 'dart:convert'; // 用于 jsonEncode/Decode
import 'package:flutter/material.dart'; // 用于 TextEditingController
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:pinflow/app/core/services/database_service.dart';
import 'package:pinflow/app/data/models/note_document.dart';
import 'package:pinflow/app/modules/editor/note_editor_arguments.dart';
import 'package:pinflow/app/modules/home/home_controller.dart'; // 用于刷新主页笔记列表

/// EditorScreen 的控制器。
///
/// 管理笔记编辑的状态和逻辑，包括 Quill 编辑器控制器、笔记标题、加载和保存笔记。
class EditorController extends GetxController {
  /// 数据库服务实例。
  final DatabaseService _dbService = Get.find();

  /// Quill 编辑器控制器。
  ///
  /// `late` 关键字表示它将在构造函数或 onInit 中被初始化。
  late quill.QuillController quillController;

  /// 笔记标题的文本编辑控制器。
  final titleTextController = TextEditingController();
  
  /// 当前正在编辑的笔记对象。
  NoteDocument? _currentNote;
  /// 当前编辑笔记的 ID (如果存在)。
  int? _noteId;

  /// 是否正在加载笔记。
  var isLoading = true.obs;


  /// Controller 初始化时调用。
  @override
  void onInit() {
    super.onInit();
    // 从路由参数中获取 NoteEditorArguments
    final arguments = Get.arguments as NoteEditorArguments?;
    _noteId = arguments?.noteId;

    if (_noteId != null) {
      _loadNote(_noteId!); // 如果有 noteId，则加载现有笔记
    } else {
      // 创建新笔记
      quillController = quill.QuillController.basic();
      titleTextController.text = "新笔记"; // 默认标题
      isLoading.value = false;
    }
  }

  /// 加载现有笔记到编辑器。
  ///
  /// @param id 要加载的笔记的 ID。
  Future<void> _loadNote(int id) async {
    isLoading.value = true;
    _currentNote = await _dbService.getNoteById(id);
    if (_currentNote != null) {
      titleTextController.text = _currentNote!.title;
      if (_currentNote!.contentDeltaJson != null && _currentNote!.contentDeltaJson!.isNotEmpty) {
        try {
          // 将存储的 JSON Delta 解码为 Quill Document
          final deltaJson = jsonDecode(_currentNote!.contentDeltaJson!);
          quillController = quill.QuillController(
            document: quill.Document.fromJson(deltaJson),
            selection: const TextSelection.collapsed(offset: 0), // 光标初始位置
          );
        } catch (e) {
          print("Error decoding Quill Delta JSON: $e");
          // 解码失败则使用空文档
          quillController = quill.QuillController.basic();
        }
      } else {
        // 如果没有内容，则使用空文档
        quillController = quill.QuillController.basic();
      }
    } else {
      // 如果未找到笔记 (例如 ID 无效)，则视为创建新笔记
      Get.snackbar("错误", "无法加载笔记，将创建新笔记。");
      quillController = quill.QuillController.basic();
      titleTextController.text = "新笔记";
      _noteId = null; // 清除无效的 noteId
      _currentNote = null;
    }
    isLoading.value = false;
    update(); // 通知 GetX 更新依赖于此 Controller 的 Widgets (特别是 GetBuilder)
  }

  /// 保存当前笔记 (新建或更新)。
  Future<void> saveNote() async {
    if (isLoading.value) return; // 如果正在加载，则不执行保存

    final now = DateTime.now();
    // 将 Quill Document 转换为 JSON Delta 以便存储
    final deltaJsonString = jsonEncode(quillController.document.toDelta().toJson());
    
    // TODO: 实现 Delta 到 Markdown 的转换逻辑，并存储到 markdownContent 字段
    // String markdownContent = convertDeltaToMarkdown(quillController.document.toDelta());

    final title = titleTextController.text.isEmpty ? "无标题笔记" : titleTextController.text;

    if (_currentNote != null && _noteId != null) {
      // 更新现有笔记
      _currentNote!.title = title;
      _currentNote!.contentDeltaJson = deltaJsonString;
      // _currentNote!.markdownContent = markdownContent; // 如果实现了 Markdown 转换
      _currentNote!.updatedAt = now;
      await _dbService.saveNote(_currentNote!);
    } else {
      // 创建新笔记
      final newNote = NoteDocument(
        title: title,
        contentDeltaJson: deltaJsonString,
        // markdownContent: markdownContent, // 如果实现了 Markdown 转换
        createdAt: now,
        updatedAt: now,
      );
      // TODO: 实现将笔记分配给默认文件夹/空间，或允许用户选择
      await _dbService.saveNote(newNote);
    }
    
    // 刷新 HomeScreen 上的笔记列表
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadNotes();
    }
    Get.back(); // 保存后返回上一屏幕
    Get.snackbar("已保存", "笔记已成功保存！", snackPosition: SnackPosition.BOTTOM);
  }

  /// Controller 关闭时调用，用于释放资源。
  @override
  void onClose() {
    quillController.dispose(); // 释放 QuillController
    titleTextController.dispose(); // 释放 TextEditingController
    super.onClose();
  }
}