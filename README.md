PPEditorExtension（Xcode 文本转换扩展）
=====================================

提供两项编辑命令：
- AllUppercased：将选中文本转换为全大写
- AllLowercased：将选中文本转换为全小写


如何安装与启用
--------------
1) 构建并运行宿主 App（仅首次）
- 在 Xcode 选择 `PPXcodeEditor` Scheme 并运行（⌘R），完成扩展的安装注册。

2) 在系统里启用扩展
- 打开 系统设置 → 隐私与安全性 → 扩展 → Xcode Source Editor。
- 勾选 `PPEditor` 扩展。

3) 在 Xcode 中使用
- 重启 Xcode（首次安装或更新扩展后建议重启）。
- 打开任意源文件并选中文本。
- 菜单栏 Editor → AllUppercased / AllLowercased。


如何确认是否生效
----------------
- Xcode 的 Editor 菜单中能看到 `AllUppercased` 与 `AllLowercased`。
- 执行命令后，选中文本被正确转换为大写/小写。


常见问题
--------
- Editor 菜单里没有看到扩展命令：
  - 确认已在 系统设置 → 隐私与安全性 → 扩展 → Xcode Source Editor 勾选 `PPEditor`。
  - 重启 Xcode。
- 扩展仍然无效：
  - 重新运行一次宿主 App `PPXcodeEditor` 以确保安装完成。
  - 确认你编辑的是可写文件且有选中文本。



打包脚本使用
------------
脚本位置：`scripts/package_app.sh`

功能：构建并将生成的 `.app` 拷贝到项目根目录的 `Products`。

基础用法（Debug 配置）：
```bash
./scripts/package_app.sh
```

指定 Release 配置：
```bash
CONFIGURATION=Release ./scripts/package_app.sh
```

指定输出目录：
```bash
PRODUCTS_DIR="/path/to/Products" ./scripts/package_app.sh
```

可用环境变量：
- `SCHEME`（默认 `PPXcodeEditor`）
- `CONFIGURATION`（默认 `Debug`）
- `SDK`（默认 `macosx`）
- `PROJECT_FILE`（默认 `<repo>/PPXcodeEditor.xcodeproj`）
- `PRODUCTS_DIR`（默认 `<repo>/Products`）
- `DERIVED_DATA`（默认 `<repo>/Products/DerivedData`）
