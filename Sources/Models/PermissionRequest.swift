import Foundation

/// 权限请求模型
struct PermissionRequest: Identifiable, Equatable {
    let id: UUID
    let tool: AITool
    let permissionType: PermissionType
    let description: String
    let timestamp: Date
    var isPending: Bool
    
    init(
        id: UUID = UUID(),
        tool: AITool,
        permissionType: PermissionType,
        description: String,
        timestamp: Date = Date(),
        isPending: Bool = true
    ) {
        self.id = id
        self.tool = tool
        self.permissionType = permissionType
        self.description = description
        self.timestamp = timestamp
        self.isPending = isPending
    }
    
    static func == (lhs: PermissionRequest, rhs: PermissionRequest) -> Bool {
        lhs.id == rhs.id
    }
}

/// 权限类型
enum PermissionType: String, Codable {
    case fileRead = "读取文件"
    case fileWrite = "写入文件"
    case bash = "执行命令"
    case webFetch = "网络请求"
    case browser = "浏览器操作"
    case toolUse = "使用工具"
    case other = "其他"
    
    var icon: String {
        switch self {
        case .fileRead: return "doc.text"
        case .fileWrite: return "pencil"
        case .bash: return "terminal"
        case .webFetch: return "globe"
        case .browser: return "safari"
        case .toolUse: return "wrench.and.screwdriver"
        case .other: return "questionmark.circle"
        }
    }
}