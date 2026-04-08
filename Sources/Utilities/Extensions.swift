import SwiftUI

// MARK: - Color 扩展
extension Color {
    static let vibeGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let vibeOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let vibeBlue = Color(red: 0.2, green: 0.5, blue: 1.0)
    static let vibeRed = Color(red: 1.0, green: 0.3, blue: 0.3)
}

// MARK: - View 扩展
extension View {
    /// 添加模糊背景效果
    func glassEffect() -> some View {
        self
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Date 扩展
extension Date {
    /// 相对时间格式化
    var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    /// 简短时间格式化
    var shortTimeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

// MARK: - String 扩展
extension String {
    /// 截断字符串
    func truncated(to length: Int, trailing: String = "...") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        }
        return self
    }
}

// MARK: - Array 扩展
extension Array where Element: Identifiable {
    /// 根据 ID 查找元素
    func first(id: Element.ID) -> Element? {
        self.first { $0.id == id }
    }
    
    /// 更新元素
    mutating func update(_ element: Element) {
        if let index = self.firstIndex(where: { $0.id == element.id }) {
            self[index] = element
        }
    }
    
    /// 移除元素
    mutating func remove(id: Element.ID) {
        self.removeAll { $0.id == id }
    }
}