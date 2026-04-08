import SwiftUI

/// 权限请求视图
struct PermissionRequestView: View {
    let request: PermissionRequest
    let onApprove: () -> Void
    let onDeny: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 头部
            HStack {
                Image(systemName: request.tool.icon)
                    .font(.system(size: 16))
                Text(request.tool.rawValue)
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                Text(request.permissionType.rawValue)
                    .font(.system(size: 12))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
            }
            
            // 描述
            Text(request.description)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .lineLimit(3)
            
            // 操作按钮
            HStack {
                Button("拒绝", action: onDeny)
                    .buttonStyle(.bordered)
                
                Spacer()
                
                Button("批准", action: onApprove)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(16)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    VStack(spacing: 16) {
        PermissionRequestView(
            request: PermissionRequest(
                tool: .claudeCode,
                permissionType: .bash,
                description: "想要执行命令: rm -rf /",
                isPending: true
            ),
            onApprove: {},
            onDeny: {}
        )
        
        PermissionRequestView(
            request: PermissionRequest(
                tool: .codex,
                permissionType: .fileWrite,
                description: "想要写入文件: /Users/demo/project/main.swift",
                isPending: true
            ),
            onApprove: {},
            onDeny: {}
        )
    }
    .padding()
    .frame(width: 340)
    .background(.black)
}