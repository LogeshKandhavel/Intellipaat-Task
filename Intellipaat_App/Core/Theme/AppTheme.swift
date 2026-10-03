import SwiftUI

public enum AppTheme {
    public static let primaryColor = Color(red: 0.12, green: 0.38, blue: 0.94) // Modern vibrant blue
    public static let secondaryColor = Color(red: 0.35, green: 0.42, blue: 0.52)
    public static let successColor = Color(red: 0.15, green: 0.68, blue: 0.38)
    public static let warningColor = Color(red: 0.95, green: 0.61, blue: 0.07)
    public static let errorColor = Color(red: 0.88, green: 0.22, blue: 0.22)
    
    public static let cardBackground = Color(UIColor.secondarySystemGroupedBackground)
    public static let pageBackground = Color(UIColor.systemGroupedBackground)
    
    public static let cornerRadius: CGFloat = 12
    public static let buttonCornerRadius: CGFloat = 10
}
