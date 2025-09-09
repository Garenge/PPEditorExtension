PPXcodeEditor / PPEditorExtension
================================

一个简单的 Xcode Source Editor Extension，提供以下命令：

- AllUppercased：将选中文本转换为全大写
- AllLowercased：将选中文本转换为全小写


快速开始
--------
1) 构建并运行宿主 App（只需第一次）
- 用 Xcode 打开工程后，选择 `PPXcodeEditor`（宿主 App）Scheme。
- 使用 Debug 或 Release 任意一次运行（⌘R），以便把扩展正确安装到系统。

2) 启用扩展
- 打开 系统设置 → 隐私与安全性 → 扩展 → Xcode Source Editor。
- 在列表中勾选 `PPEditor`（或你看到的扩展名称）。

3) 在 Xcode 中使用
- 重新启动 Xcode（第一次安装/变更扩展后建议重启）。
- 打开任意可编辑文本文件，选中一段文本。
- 菜单栏选择 Editor → AllUppercased 或 AllLowercased。
- 选中文本将被转换为对应的大写/小写形式。


如何检查是否生效
----------------
- 在 Xcode 菜单栏的 Editor 下能看到 `AllUppercased` 与 `AllLowercased` 菜单项。
- 执行命令后，选中文本正确变为大写/小写。
- 如果菜单存在但命令无效，请查看“常见问题排查”。


常见问题排查
------------
- 菜单里看不到扩展命令
  - 确认已在 系统设置 → 隐私与安全性 → 扩展 → Xcode Source Editor 勾选 `PPEditor`。
  - 重启 Xcode。
  - 确认你打开的是可编辑的源文件，且有选中文本。

- 仍然无效/命令无法执行
  - 重新构建并运行一次宿主 App `PPXcodeEditor`，确保扩展已正确安装。
  - 检查签名：`PPXcodeEditorExtension` 与宿主 App 使用有效的开发者证书（Apple Development）。
  - 在 Xcode 的 Report/Console 中查看编译与运行日志是否有错误（例如签名、权限、Bundle 标识不一致等）。
  - 若之前装过同名扩展，尝试卸载旧版本或提升 Bundle Identifier 避免冲突。


命令列表（动态绑定）
------------------
扩展通过 Info.plist 注册命令，并在代码中根据运行时 `Bundle.main.bundleIdentifier` 动态拼接标识进行分发：

- UppercasedCommand：将选区转为大写
- LowercasedCommand：将选区转为小写


开发说明（可选）
--------------
- 命令分发：`SourceEditorCommand.perform` 内使用 `invocation.commandIdentifier` 进行分支分发。
- 逻辑实现：
  - `uppercaseSelectedText(_:)`
  - `lowercaseSelectedText(_:)`
  均支持单行与多行选区，仅替换选中的范围。


许可
----
本项目仅用于示例与学习用途。根据你需求选择合适的 License 后补充于此。


