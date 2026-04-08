# AiNotify

> macOS 菜单栏 AI 状态监控应用 — 实时显示 Claude Code、Codex、Cursor 等 AI 编程工具的运行状态

## 功能特性

- ✅ **实时状态显示** — 在菜单栏显示 AI 工具的运行状态
- ✅ **会话卡片** — 显示活跃的 AI 会话，支持点击跳转到终端
- ✅ **状态指示器** — 彩色圆点显示运行中/思考中/完成状态
- ✅ **权限请求** — 显示待处理的权限请求
- ✅ **终端跳转** — 点击会话自动激活对应终端窗口

## 技术栈

- **语言**: Swift 5.9
- **框架**: SwiftUI
- **最低支持**: macOS 14.0+
- **架构**: MVVM

## 项目结构

```
ai-notify/
├── Sources/
│   ├── App/                    # 应用入口
│   │   ├── AiNotifyApp.swift
│   │   └── AppDelegate.swift
│   ├── Views/                  # SwiftUI 视图
│   │   ├── NotchPanelView.swift
│   │   ├── SessionCardView.swift
│   │   ├── StatusIndicator.swift
│   │   └── PermissionRequestView.swift
│   ├── Models/                 # 数据模型
│   ├── Services/               # 业务服务
│   └── Utilities/              # 工具扩展
├── Resources/
│   ├── Info.plist
│   └── AiNotify.entitlements
├── project.yml
└── README.md
```

## 如何构建

1. 安装 XcodeGen: `brew install xcodegen`
2. 生成项目: `xcodegen generate`
3. 打开: `open AiNotify.xcodeproj`
4. 运行: Cmd+R

## License

MIT License
