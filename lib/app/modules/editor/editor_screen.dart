import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'editor_controller.dart';

/// 笔记编辑器屏幕。
///
/// 使用 flutter_quill 实现富文本编辑功能。
/// 包含标题输入框、Quill 工具栏和 Quill 编辑器区域。
class EditorScreen extends GetView<EditorController> {
  // EditorScreen 的构造函数
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar 的标题会动态显示当前笔记的标题或 "编辑笔记"
        title: Obx(() => Text(controller.titleTextController.text.isEmpty
            ? "编辑笔记"
            : controller.titleTextController.text)),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: '保存笔记',
            onPressed: controller.saveNote, // 点击保存笔记
          ),
        ],
      ),
      body: Obx(() { // 使用 Obx 包裹，以便在 isLoading 状态改变时重建
        if (controller.isLoading.value) {
          // 如果正在加载笔记，显示加载指示器
          return const Center(child: CircularProgressIndicator());
        }
        // 笔记加载完成后显示编辑器界面
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 笔记标题输入框
              TextField(
                controller: controller.titleTextController,
                decoration: const InputDecoration(
                  hintText: '笔记标题',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Quill 编辑器工具栏
              GetBuilder<EditorController>(
                builder: (editorCtrl) {
                  return QuillSimpleToolbar(
                    controller: editorCtrl.quillController,
                    config: QuillSimpleToolbarConfig(
                      embedButtons: FlutterQuillEmbeds.toolbarButtons(),
                      showClipboardPaste: true,
                      buttonOptions: QuillSimpleToolbarButtonOptions(
                        base: QuillToolbarBaseButtonOptions(
                          afterButtonPressed: () {
                            // 在桌面平台上，按钮点击后重新获取焦点
                            FocusScope.of(context).requestFocus();
                          },
                        ),
                        linkStyle: QuillToolbarLinkStyleButtonOptions(
                          validateLink: (link) => true, // 允许所有链接格式
                        ),
                      ),
                    ),
                  );
                }
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: GetBuilder<EditorController>(
                    builder: (editorCtrl) {
                      return QuillEditor(
                        controller: editorCtrl.quillController,
                        focusNode: FocusNode(),
                        scrollController: ScrollController(),
                        config: QuillEditorConfig(
                          placeholder: '在这里开始写作...',
                          padding: const EdgeInsets.all(16),
                          scrollable: true,
                          autoFocus: false,
                          expands: false,
                          enableInteractiveSelection: true,
                          enableSelectionToolbar: true,
                          showCursor: true,
                          embedBuilders: FlutterQuillEmbeds.editorBuilders(
                            imageEmbedConfig: QuillEditorImageEmbedConfig(
                              imageProviderBuilder: (context, imageUrl) {
                                if (imageUrl.startsWith('assets/')) {
                                  return AssetImage(imageUrl);
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}