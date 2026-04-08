import SwiftUI

/// 会话卡片视图
struct SessionCardView: View {
    let session: AISession
    let onTap: () -> Void

    @State private var isHovering = false
    @State private var isPressed = false

    // MARK: - Layout Constants

    private enum Layout {
        static let cardPadding: CGFloat = 12
        static let cornerRadius: CGFloat = 12
        static let hStackSpacing: CGFloat = 12
        static let vStackSpacing: CGFloat = 4
        static let metaSpacing: CGFloat = 8
        static let iconSize: CGFloat = 12
        static let arrowIconSize: CGFloat = 14
        static let titleFontSize: CGFloat = 13
        static let reasoningFontSize: CGFloat = 11
        static let metaFontSize: CGFloat = 10
        static let hoverScale: CGFloat = 1.01
        static let pressedScale: CGFloat = 0.98
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Layout.hStackSpacing) {
                // 状态指示器
                StatusIndicator(status: session.status)

                // 会话信息
                VStack(alignment: .leading, spacing: Layout.vStackSpacing) {
                    HStack {
                        Image(systemName: session.tool.icon)
                            .font(.system(size: Layout.iconSize))
                            .foregroundStyle(.secondary)
                        Text(session.name)
                            .font(.system(size: Layout.titleFontSize, weight: .medium))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                    }

                    // 推理内容（如果有）
                    if let reasoning = session.reasoning {
                        Text(reasoning)
                            .font(.system(size: Layout.reasoningFontSize))
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }

                    // 元信息
                    HStack(spacing: Layout.metaSpacing) {
                        Label(formatTime(session.startTime), systemImage: "clock")
                            .font(.system(size: Layout.metaFontSize))
                            .foregroundStyle(.secondary)

                        if session.messagesCount > 0 {
                            Label("\(session.messagesCount) 条消息", systemImage: "message")
                                .font(.system(size: Layout.metaFontSize))
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Spacer()

                // 跳转图标
                Image(systemName: "arrow.right.circle")
                    .font(.system(size: Layout.arrowIconSize))
                    .foregroundStyle(.secondary)
            }
            .padding(Layout.cardPadding)
            .background {
                RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                    .fill(.regularMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                            .strokeBorder(
                                isHovering ? Color.primary.opacity(0.2) : Color.clear,
                                lineWidth: 1
                            )
                    }
            }
            .scaleEffect(isPressed ? Layout.pressedScale : (isHovering ? Layout.hoverScale : 1))
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(session.name)
        .accessibilityValue(accessibilityValue)
        .accessibilityHint("双击打开会话对应的终端窗口")
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Accessibility

    private var accessibilityValue: String {
        var parts: [String] = []
        parts.append(session.status.description)
        if let reasoning = session.reasoning {
            parts.append(reasoning)
        }
        parts.append("开始于 \(formatTime(session.startTime))")
        if session.messagesCount > 0 {
            parts.append("\(session.messagesCount) 条消息")
        }
        return parts.joined(separator: "，")
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    VStack(spacing: 12) {
        SessionCardView(
            session: AISession(
                pid: 12345,
                processName: "com.anthropic.clause",
                name: "Coding Project",
                tool: .claudeCode,
                status: .running,
                messagesCount: 23,
                reasoning: "Analyzing the codebase structure..."
            ),
            onTap: {}
        )
        
        SessionCardView(
            session: AISession(
                pid: 67890,
                processName: "com.openai.codex",
                name: "Debug Session",
                tool: .codex,
                status: .thinking,
                messagesCount: 5,
                reasoning: "Looking for the bug in line 42..."
            ),
            onTap: {}
        )
    }
    .padding()
    .frame(width: 340)
    .background(.black)
}