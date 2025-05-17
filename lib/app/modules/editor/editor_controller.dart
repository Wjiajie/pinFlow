import 'dart:convert'; // 用于 jsonEncode/Decode
import 'package:flutter/material.dart'; // 用于 TextEditingController
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:pinflow/app/core/services/database_service.dart';
import 'package:pinflow/app/data/models/note_document.dart';
import 'package:pinflow/app/modules/editor/note_editor_arguments.dart';
import 'package:pinflow/app/modules/home/home_controller.dart';
// import 'dart:developer' as developer; // 可以移除了
import 'package:pinflow/app/core/utils/logger_service.dart'; // <--- 导入 AppLogger

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
    AppLogger.debug("EditorController onInit. NoteId: $_noteId"); // 示例
  }

  /// 加载现有笔记到编辑器。
  ///
  /// @param id 要加载的笔记的 ID。
  Future<void> _loadNote(int id) async {
    isLoading.value = true;
    AppLogger.debug("_loadNote called for id: $id", "EditorController._loadNote");
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
        } catch (e, stackTrace) {
          AppLogger.error("Error decoding Quill Delta JSON: $e", e, stackTrace);
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
    AppLogger.debug('saveNote called. isLoading: ${isLoading.value}', "EditorController.saveNote");
    if (isLoading.value) {
      AppLogger.warning('saveNote: Aborting save because isLoading is true.', "EditorController.saveNote");
      Get.snackbar("请稍候", "笔记正在加载或处理中...", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    AppLogger.info('saveNote: Proceeding with save.', "EditorController.saveNote");

    try {
      final now = DateTime.now();
      AppLogger.trace('saveNote: Converting document to Delta JSON...', "EditorController.saveNote");
      final delta = quillController.document.toDelta();
      final deltaJsonList = delta.toJson();
      final deltaJsonString = jsonEncode(deltaJsonList);
      AppLogger.trace('saveNote: Delta JSON string length: ${deltaJsonString.length}', "EditorController.saveNote");

      final title = titleTextController.text.isEmpty ? "无标题笔记" : titleTextController.text;
      AppLogger.debug('saveNote: Title: "$title"', "EditorController.saveNote");

      if (_currentNote != null && _noteId != null) {
        AppLogger.info('saveNote: Updating existing note with id: $_noteId', "EditorController.saveNote");
        _currentNote!.title = title;
        _currentNote!.contentDeltaJson = deltaJsonString;
        _currentNote!.updatedAt = now;
        await _dbService.saveNote(_currentNote!);
        AppLogger.info('saveNote: Existing note updated successfully.', "EditorController.saveNote");
      } else {
        AppLogger.info('saveNote: Creating new note.', "EditorController.saveNote");
        final newNote = NoteDocument(
          title: title,
          contentDeltaJson: deltaJsonString,
          createdAt: now,
          updatedAt: now,
        );
        await _dbService.saveNote(newNote);
        AppLogger.info('saveNote: New note created and saved successfully.', "EditorController.saveNote");
      }
    } catch (e, stackTrace) {
      AppLogger.error('saveNote: Error during save process', e, stackTrace);
      Get.snackbar("保存失败", "保存笔记时发生错误: $e", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 5));
      return;
    }
    
    AppLogger.debug('saveNote: Attempting to refresh HomeController notes.', "EditorController.saveNote");
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadNotes();
      AppLogger.debug('saveNote: HomeController.loadNotes() called.', "EditorController.saveNote");
    } else {
      AppLogger.warning('saveNote: HomeController not registered.', "EditorController.saveNote");
    }

    AppLogger.info('saveNote: Navigating back and showing success snackbar.', "EditorController.saveNote");
    Get.back(); 
    Get.snackbar("已保存", "笔记已成功保存！", snackPosition: SnackPosition.BOTTOM);
    AppLogger.debug('saveNote: Completed.', "EditorController.saveNote");
  }

  /// Controller 关闭时调用，用于释放资源。
  @override
  void onClose() {
    quillController.dispose(); // 释放 QuillController
    titleTextController.dispose(); // 释放 TextEditingController
    super.onClose();
  }
}