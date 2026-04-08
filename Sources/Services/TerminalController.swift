import Foundation
import AppKit
import ApplicationServices

/// 终端控制服务
class TerminalController {
    static let shared = TerminalController()
    
    private init() {}
    
    /// 跳转到指定会话的终端
    func jumpToTerminal(for session: AISession) {
        switch session.tool {
        case .claudeCode, .claude:
            jumpToClaudeTerminal()
        case .codex:
            jumpToCodexTerminal()
        case .cursor:
            jumpToCursor()
        case .opencode:
            jumpToOpencode()
        case .geminiCLI:
            jumpToGeminiTerminal()
        }
    }
    
    // MARK: - 终端跳转实现
    
    /// 跳转到最近的终端应用
    private func activateTerminal() {
        let terminals = ["iTerm", "Terminal", "Ghostty", "Warp", "Alacritty", "Kitty"]
        
        for terminal in terminals {
            if let app = NSWorkspace.shared.runningApplications.first(where: {
                $0.localizedName?.contains(terminal) ?? false
            }) {
                app.activate()
                return
            }
        }
        
        // 如果没有找到，激活最前面的应用
        NSWorkspace.shared.launchApplication("Terminal")
    }
    
    /// 跳转到 Claude Code 终端
    private func jumpToClaudeTerminal() {
        // 使用 AppleScript 尝试激活终端
        let script = """
        tell application "System Events"
            -- 尝试激活常用终端
            if exists (processes where name is "iTerm2") then
                tell application "iTerm2" to activate
            else if exists (processes where name is "Terminal") then
                tell application "Terminal" to activate
            else if exists (processes where name is "Ghostty") then
                tell application "Ghostty" to activate
            else
                tell application "Warp" to activate
            end if
        end tell
        """
        runAppleScript(script)
    }
    
    /// 跳转到 Codex
    private func jumpToCodexTerminal() {
        // 尝试激活 Codex CLI 所在的终端
        if let app = NSWorkspace.shared.runningApplications.first(where: {
            $0.localizedName?.lowercased().contains("terminal") ?? false
        }) {
            app.activate()
        }
    }
    
    /// 跳转到 Cursor
    private func jumpToCursor() {
        if let app = NSWorkspace.shared.runningApplications.first(where: {
            $0.localizedName == "Cursor"
        }) {
            app.activate()
        }
    }
    
    /// 跳转到 OpenCode
    private func jumpToOpencode() {
        if let app = NSWorkspace.shared.runningApplications.first(where: {
            $0.localizedName == "OpenCode"
        }) {
            app.activate()
        }
    }
    
    /// 跳转到 Gemini CLI 终端
    private func jumpToGeminiTerminal() {
        jumpToClaudeTerminal()
    }
    
    /// 运行 AppleScript
    private func runAppleScript(_ script: String) {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            scriptObject.executeAndReturnError(&error)
            if let error = error {
                print("AppleScript error: \(error)")
            }
        }
    }
    
    /// 获取当前聚焦的窗口信息
    func getFocusedWindowInfo() -> (app: String, title: String)? {
        guard let frontApp = NSWorkspace.shared.frontmostApplication,
              let appName = frontApp.localizedName else {
            return nil
        }
        
        // 获取窗口标题需要辅助权限
        return (appName, "")
    }
}