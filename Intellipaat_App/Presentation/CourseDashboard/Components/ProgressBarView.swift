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
                    Text("Progress:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(progress)%")
                        .font(.subheadline.bold())
                        .foregroundColor(AppTheme.primaryColor)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(Color(UIColor.systemGray5))
                        .frame(height: height)
                    
                    // Filled progress bar
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.primaryColor, AppTheme.primaryColor.opacity(0.85)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(progressRatio), height: height)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: height)
        }
    }
}
