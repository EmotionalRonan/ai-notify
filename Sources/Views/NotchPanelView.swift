import SwiftUI

// MARK: - Layout Constants

private enum Layout {
    static let panelWidthExpanded: CGFloat = 360
    static let panelWidthCollapsed: CGFloat = 60
    static let cornerRadiusExpanded: CGFloat = 22
    static let cornerRadiusCollapsed: CGFloat = 30
    static let sessionListMaxHeight: CGFloat = 300
    static let sessionListPadding: CGFloat = 12
    static let sessionSpacing: CGFloat = 8
    static let headerHorizontalPadding: CGFloat = 16
    static let headerVerticalPadding: CGFloat = 12
    static let bottomBarHorizontalPadding: CGFloat = 16
    static let bottomBarVerticalPadding: CGFloat = 8
    static let permissionBarHorizontalPadding: CGFloat = 16
    static let permissionBarVerticalPadding: CGFloat = 10
    static let animationResponse: CGFloat = 0.3
}

/// Notch 面板主视图
struct NotchPanelView: View {
    @ObservedObject private var processMonitor = ProcessMonitor.shared
    @State private var isExpanded = false
    @State private var showingPermissionSheet = false
    @State private var showingQuitConfirmation = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 状态栏
            StatusHeaderView(
                activeCount: processMonitor.activeSessions.count,
                isExpanded: isExpanded,
                onToggle: { withAnimation(.spring(response: Layout.animationResponse)) { isExpanded.toggle() } }
            )
            .accessibilityLabel("Vibe Island 状态栏")
            .accessibilityHint(isExpanded ? "双击收起面板" : "双击展开面板")
            
            if isExpanded {
                Divider()
                
                // 会话列表
                if processMonitor.activeSessions.isEmpty {
                    EmptyStateView()
                        .accessibilityLabel("暂无活跃会话")
                } else {
                    ScrollView {
                        LazyVStack(spacing: Layout.sessionSpacing) {
                            ForEach(processMonitor.activeSessions, id: \.pid) { session in
                                SessionCardView(
                                    session: session,
                                    onTap: {
                                        TerminalController.shared.jumpToTerminal(for: session)
                                    }
                                )
                            }
                        }
                        .animation(.spring(response: Layout.animationResponse), value: processMonitor.activeSessions.count)
                        .padding(Layout.sessionListPadding)
                    }
                    .frame(maxHeight: Layout.sessionListMaxHeight)
                    .accessibilityLabel("活跃会话列表")
                }
                
                Divider()
                
                // 权限请求
                if !processMonitor.pendingPermissions.isEmpty {
                    PermissionBarView(
                        permissions: processMonitor.pendingPermissions,
                        onTap: { showingPermissionSheet = true }
                    )
                    .accessibilityLabel("\(processMonitor.pendingPermissions.count) 个待处理权限请求")
                }
                
                // 底部操作栏
                BottomBarView(onQuit: { showingQuitConfirmation = true })
            }
        }
        .frame(width: isExpanded ? Layout.panelWidthExpanded : Layout.panelWidthCollapsed)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: isExpanded ? Layout.cornerRadiusExpanded : Layout.cornerRadiusCollapsed))
        .animation(.spring(response: Layout.animationResponse), value: isExpanded)
        .sheet(isPresented: $showingPermissionSheet) {
            PermissionDetailView(
                permissions: processMonitor.pendingPermissions
            )
        }
        .confirmationDialog("退出 Vibe Island", isPresented: $showingQuitConfirmation, titleVisibility: .visible) {
            Button("退出", role: .destructive) {
                NSApplication.shared.terminate(nil)
            }
            Button("取消", role: .cancel) {}
        } message: {
            Text("确定要退出 Vibe Island 吗？")
        }
    }
}

/// 状态栏头部
struct StatusHeaderView: View {
    let activeCount: Int
    let isExpanded: Bool
    let onToggle: () -> Void
    
    @State private var isHovering = false
    
    var body: some View {
        HStack {
            Image(systemName: "brain")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
            
            if activeCount > 0 {
                Text("\(activeCount) 活跃会话")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Spacer()
            
            Button(action: onToggle) {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(isHovering ? 0.9 : 0.6))
                    .scaleEffect(isHovering ? 1.1 : 1.0)
            }
            .buttonStyle(.plain)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.15)) {
                    isHovering = hovering
                }
            }
            .accessibilityLabel(isExpanded ? "收起面板" : "展开面板")
        }
        .padding(.horizontal, Layout.headerHorizontalPadding)
        .padding(.vertical, Layout.headerVerticalPadding)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Vibe Island 状态栏")
        .accessibilityValue(activeCount > 0 ? "\(activeCount) 个活跃会话" : "无活跃会话")
    }
}

/// 空状态视图
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "moon.stars")
                .font(.system(size: 24))
                .foregroundStyle(.secondary)
            Text("暂无活跃会话")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
        .frame(height: 100)
    }
}

/// 权限栏
struct PermissionBarView: View {
    let permissions: [PermissionRequest]
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                Text("\(permissions.count) 个权限请求")
                    .font(.system(size: 12))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 10))
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
    }
}

/// 底部操作栏
struct BottomBarView: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "gearshape")
                    .font(.system(size: 12))
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Text("Vibe Island v1.0")
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Button(action: { NSApplication.shared.terminate(nil) }) {
                Image(systemName: "power")
                    .font(.system(size: 12))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    NotchPanelView()
}