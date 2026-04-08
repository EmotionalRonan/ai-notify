import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 启动进程监控
        ProcessMonitor.shared.start()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        ProcessMonitor.shared.stop()
    }
}