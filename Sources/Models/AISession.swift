import Foundation

/// AI 会话模型
struct AISession: Identifiable, Equatable {
    let id: UUID
    let pid: Int
    let processName: String
    let name: String
    let tool: AITool
    var status: SessionStatus
    var startTime: Date
    var messagesCount: Int
    var reasoning: String?
    
    init(
        id: UUID = UUID(),
        pid: Int,
        processName: String,
        name: String,
        tool: AITool,
        status: SessionStatus = .idle,
        startTime: Date = Date(),
        messagesCount: Int = 0,
        reasoning: String? = nil
    ) {
        self.id = id
        self.pid = pid
        self.processName = processName
        self.name = name
        self.tool = tool
        self.status = status
        self.startTime = startTime
        self.messagesCount = messagesCount
        self.reasoning = reasoning
    }
    
    static func == (lhs: AISession, rhs: AISession) -> Bool {
        lhs.id == rhs.id
    }
}

/// 支持的 AI 工具
enum AITool: String, CaseIterable, Codable {
    case claudeCode = "Claude Code"
    case claude = "Claude"
    case codex = "Codex"
    case cursor = "Cursor"
    case opencode = "OpenCode"
    case geminiCLI = "Gemini CLI"
    
    var icon: String {
        switch self {
        case .claudeCode, .claude: return "brain"
        case .codex: return "chevron.left.forwardslash.chevron.right"
        case .cursor: return "cursorarrow"
        case .opencode: return "terminal"
        case .geminiCLI: return "sparkles"
        }
    }
    
    var processNames: [String] {
        switch self {
        case .claudeCode: return ["claude", "CLAUDE"]
        case .claude: return ["claude", "CLAUDE"]
        case .codex: return ["codex", "Codex"]
        case .cursor: return ["cursor", "Cursor"]
        case .opencode: return ["opencode"]
        case .geminiCLI: return ["gemini", "google-gemini"]
        }
    }
}