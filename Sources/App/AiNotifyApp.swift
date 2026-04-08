import SwiftUI

@main
struct AiNotifyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("AiNotify", systemImage: "brain") {
            NotchPanelView()
        }
        .menuBarExtraStyle(.menuBarPopover)
    }
}