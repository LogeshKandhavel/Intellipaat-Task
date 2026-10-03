import SwiftUI

public enum AppTheme {
    // MARK: - Brand Palette
    public static let primaryColor = Color(red: 0.18, green: 0.38, blue: 0.98) // Vibrant royal sapphire
    public static let primaryDark = Color(red: 0.10, green: 0.22, blue: 0.75)
    public static let primaryLight = Color(red: 0.38, green: 0.58, blue: 1.0)
    
    public static let accentColor = Color(red: 0.04, green: 0.71, blue: 0.88) // Modern electric cyan
    public static let secondaryColor = Color(red: 0.38, green: 0.44, blue: 0.56)
    
    // MARK: - Semantic Status Colors
    public static let successColor = Color(red: 0.08, green: 0.72, blue: 0.45) // Emerald mint
    public static let warningColor = Color(red: 0.96, green: 0.62, blue: 0.12) // Warm amber
    public static let errorColor = Color(red: 0.92, green: 0.26, blue: 0.35) // Modern coral red
    public static let infoColor = Color(red: 0.20, green: 0.60, blue: 1.00) // Sky blue
    
    // MARK: - Adaptive Surfaces
    public static let cardBackground = Color(UIColor.secondarySystemGroupedBackground)
    public static let pageBackground = Color(UIColor.systemGroupedBackground)
    public static let elevatedBackground = Color(UIColor.tertiarySystemGroupedBackground)
    public static let surfaceSubtle = Color(UIColor.systemGray6)
    
    // MARK: - Geometry & Radii
    public static let cornerRadius: CGFloat = 16
    public static let cardCornerRadius: CGFloat = 18
    public static let buttonCornerRadius: CGFloat = 14
    public static let pillCornerRadius: CGFloat = 30
    
    // MARK: - Gradients
    public static let primaryGradient = LinearGradient(
        colors: [Color(red: 0.20, green: 0.40, blue: 0.98), Color(red: 0.40, green: 0.25, blue: 0.92)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let accentGradient = LinearGradient(
        colors: [Color(red: 0.04, green: 0.71, blue: 0.88), Color(red: 0.20, green: 0.45, blue: 0.98)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    public static let successGradient = LinearGradient(
        colors: [Color(red: 0.08, green: 0.72, blue: 0.45), Color(red: 0.05, green: 0.60, blue: 0.50)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let cardHeaderGradient = LinearGradient(
        colors: [primaryColor.opacity(0.08), primaryColor.opacity(0.01)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    public static let heroBannerGradient = LinearGradient(
        colors: [
            Color(red: 0.15, green: 0.32, blue: 0.88),
            Color(red: 0.32, green: 0.20, blue: 0.82)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

