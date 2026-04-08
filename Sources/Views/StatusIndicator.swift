import SwiftUI

/// 状态指示器组件
struct StatusIndicator: View {
    let status: SessionStatus
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(colorForStatus)
                .frame(width: 10, height: 10)
                .overlay(
                    Circle()
                        .stroke(colorForStatus.opacity(0.3), lineWidth: 2)
                        .scaleEffect(status == .running ? 1.5 : 1.0)
                        .animation(
                            status == .running ? 
                                .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : 
                                .default,
                            value: status
                        )
                )
            
            Text(status.description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var colorForStatus: Color {
        switch status {
        case .idle: return .gray
        case .thinking: return .orange
        case .running: return .green
        case .completed: return .blue
        case .interrupted: return .yellow
        case .error: return .red
        }
    }
}

/// 权限请求详情视图
struct PermissionDetailView: View {
    let permissions: [PermissionRequest]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // 标题栏
            HStack {
                Text("权限请求")
                    .font(.headline)
                Spacer()
                Button("关闭") { dismiss() }
            }
            .padding()
            
            Divider()
            
            // 权限列表
            if permissions.isEmpty {
                Text("暂无待处理权限请求")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(permissions) { permission in
                    PermissionRowView(permission: permission)
                }
            }
        }
        .frame(width: 400, height: 300)
    }
}

/// 权限行视图
struct PermissionRowView: View {
    let permission: PermissionRequest
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: permission.permissionType.icon)
                    .foregroundStyle(.blue)
                Text(permission.tool.rawValue)
                    .font(.subheadline.weight(.medium))
                Spacer()
                Text(permission.permissionType.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(permission.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            HStack {
                Button("拒绝") {}
                    .buttonStyle(.bordered)
                Spacer()
                Button("批准") {}
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview("Status Indicator") {
    HStack(spacing: 20) {
        StatusIndicator(status: .idle)
        StatusIndicator(status: .thinking)
        StatusIndicator(status: .running)
        StatusIndicator(status: .completed)
        StatusIndicator(status: .interrupted)
        StatusIndicator(status: .error)
    }
    .padding()
}