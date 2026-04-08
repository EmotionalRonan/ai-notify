import Foundation
import UserNotifications

/// 通知服务
class NotificationService {
    static let shared = NotificationService()
    
    private init() {
        requestAuthorization()
    }
    
    /// 请求通知权限
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    /// 发送会话开始通知
    func sendSessionStartedNotification(session: AISession) {
        let content = UNMutableNotificationContent()
        content.title = "AI 会话开始"
        content.body = "\(session.tool.rawValue): \(session.name)"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: session.id.uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    /// 发送权限请求通知
    func sendPermissionRequestNotification(request: PermissionRequest) {
        let content = UNMutableNotificationContent()
        content.title = "权限请求"
        content.body = "\(request.tool.rawValue): \(request.permissionType.rawValue) - \(request.description)"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let identifier = "permission-\(request.id.uuidString)"
        
        let notificationRequest = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(notificationRequest)
    }
    
    /// 发送会话完成通知
    func sendSessionCompletedNotification(session: AISession, messageCount: Int) {
        let content = UNMutableNotificationContent()
        content.title = "AI 会话完成"
        content.body = "\(session.name) - 完成了 \(messageCount) 条消息"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: session.id.uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    /// 移除所有通知
    func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}