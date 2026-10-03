import SwiftUI

public struct ProgressBarView: View {
    public let progress: Int // 0 to 100
    public var height: CGFloat = 8
    public var showPercentageLabel: Bool = false
    
    public init(progress: Int, height: CGFloat = 8, showPercentageLabel: Bool = false) {
        self.progress = min(100, max(0, progress))
        self.height = height
        self.showPercentageLabel = showPercentageLabel
    }
    
    private var progressRatio: Double {
        Double(progress) / 100.0
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if showPercentageLabel {
                HStack {
                    Text("Progress")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.secondary)
                    Spacer()
                    HStack(spacing: 3) {
                        if progress == 100 {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundColor(AppTheme.successColor)
                        }
                        Text("\(progress)%")
                            .font(.caption.weight(.bold))
                            .foregroundColor(progress == 100 ? AppTheme.successColor : AppTheme.primaryColor)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        (progress == 100 ? AppTheme.successColor : AppTheme.primaryColor)
                            .opacity(0.12)
                    )
                    .clipShape(Capsule())
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Modern Subtle Background Track
                    Capsule()
                        .fill(Color(UIColor.systemGray5).opacity(0.8))
                        .frame(height: height)
                    
                    // Filled Gradient Progress Bar
                    if progress > 0 {
                        Capsule()
                            .fill(
                                progress == 100
                                ? AppTheme.successGradient
                                : AppTheme.primaryGradient
                            )
                            .frame(width: max(height, geometry.size.width * CGFloat(progressRatio)), height: height)
                            .shadow(
                                color: (progress == 100 ? AppTheme.successColor : AppTheme.primaryColor).opacity(0.35),
                                radius: 4,
                                x: 0,
                                y: 2
                            )
                            .animation(.spring(response: 0.55, dampingFraction: 0.8), value: progress)
                    }
                }
            }
            .frame(height: height)
        }
    }
}

