import Foundation
import Combine
import AppKit

/// 进程监控服务 - 单例
@MainActor
class ProcessMonitor: ObservableObject {
    static let shared = ProcessMonitor()
    
    @Published var activeSessions: [AISession] = []
    @Published var pendingPermissions: [PermissionRequest] = []
    
    private var monitorTimer: Timer?
    private var isMonitoring = false
    
    private init() {}
    
    func start() {
        guard !isMonitoring else { return }
        isMonitoring = true
        
        // 每秒检查一次
        monitorTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.checkProcesses()
            }
        }
        
        // 立即检查一次
        checkProcesses()
    }
    
    func stop() {
        monitorTimer?.invalidate()
        monitorTimer = nil
        isMonitoring = false
    }
    
    private func checkProcesses() {
        // 检测正在运行的 AI 进程
        let runningApps = NSWorkspace.shared.runningApplications
        
        var detectedSessions: [AISession] = []
        
        for tool in AITool.allCases {
            for processName in tool.processNames {
                let matchingApps = runningApps.filter { app in
                    app.localizedName?.lowercased().contains(processName.lowercased()) ?? false
                }
                
                if !matchingApps.isEmpty {
                    let app = matchingApps.first!
                    let session = AISession(
                        pid: Int(app.processIdentifier),
                        processName: app.bundleIdentifier ?? processName,
                        name: app.localizedName ?? "\(tool.rawValue) Session",
                        tool: tool,
                        status: .running,
                        startTime: Date()
                    )
                    detectedSessions.append(session)
                }
            }
        }
        
        // 更新活跃会话
        activeSessions = detectedSessions
        
        // 模拟一些权限请求（实际需要解析进程输出）
        if activeSessions.isEmpty && pendingPermissions.isEmpty {
            // 可以在这里添加模拟权限请求用于测试
        }
    }
    
    // 添加权限请求
    func addPermissionRequest(_ request: PermissionRequest) {
        pendingPermissions.append(request)
    }
    
    // 处理权限请求
    func handlePermission(id: UUID, approved: Bool) {
        pendingPermissions.removeAll { $0.id == id }
        
        if approved {
            // 发送批准信号给对应的进程（需要实现进程间通信）
            print("Permission approved for request: \(id)")
        }
    }
}