import Foundation

/// 会话状态枚举
enum SessionStatus: String, Codable {
    case idle = "空闲"
    case thinking = "思考中"
    case running = "运行中"
    case completed = "已完成"
    case interrupted = "已中断"
    case error = "错误"
    
    var color: String {
        switch self {
        case .idle: return "gray"
        case .thinking: return "orange"
        case .running: return "green"
        case .completed: return "blue"
        case .interrupted: return "yellow"
        case .error: return "red"
        }
    }
    
    var icon: String {
        switch self {
        case .idle: return "moon"
        case .thinking: return "brain"
        case .running: return "play.fill"
        case .completed: return "checkmark.circle.fill"
        case .interrupted: return "pause.circle.fill"
        case .error: return "exclamationmark.triangle.fill"
        }
    }
    
    var description: String {
        switch self {
        case .idle: return "空闲"
        case .thinking: return "思考中"
        case .running: return "运行中"
        case .completed: return "已完成"
        case .interrupted: return "已中断"
        case .error: return "错误"
        }
    }
}