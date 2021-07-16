import SwiftUI

public extension View {

    /// Convenience to apply SATSButton styles to SwiftUI buttons
    ///
    /// - Parameters:
    ///   - style: style of the button based on the UIKit styles
    ///   - size: size of the button (`.basic` by default)
    ///   - isLoading: a booelan to indicate if we need to show a spinner on the button instead of the button text
    /// - Returns: applies the `buttonStyle` modifier to the current view
    func satsButton(_ style: SATSButton.Style, size: SATSButton.Size = .basic, isLoading: Bool = false) -> some View {
        buttonStyle(SATSButtonSwiftUIStyle(style, size: size, isLoading: isLoading))
    }
}

/// Internal implementation of `SATSButton` for SwiftUI,
/// It takes the same parametes as the UIKit implementation
/// and interprets them in a SwiftUI context
private struct SATSButtonSwiftUIStyle: ButtonStyle {
    let style: SATSButton.Style
    let size: SATSButton.Size
    let isLoading: Bool
    @Environment(\.isEnabled) private var isEnabled

    init(_ style: SATSButton.Style, size: SATSButton.Size, isLoading: Bool) {
        self.style = style
        self.size = size
        self.isLoading = isLoading
    }

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            buttonContent(for: configuration)
                .opacity(isLoading ? 0.0 : 1.0)
            spinner
                .opacity(isLoading ? 1.0 : 0.0)
        }
        .padding(.vertical, size.verticalPadding)
        .padding(.horizontal, size.horizontalPadding)
        .if(size.contentHuggingPriority != .defaultHigh, transform: { label in
            label.frame(maxWidth: .infinity, alignment: .center)
        })
        .background(backgroundColor(for: configuration))
        .foregroundColor(textColor(for: configuration))
        .clipShape(Capsule())
    }

    // MARK: Subviews

    @ViewBuilder
    func buttonContent(for configuration: Configuration) -> some View {
        if #available(iOS 14.0, *) {
            configuration
                .label
                .satsFont(.button, weight: .medium)
                .textCase(.uppercase)
        } else {
            configuration
                .label
                .satsFont(.button, weight: .medium)
        }
    }

    var spinner: some View {
        SimpleRepresentable<RoundLoadingView> { loadingView in
            loadingView.startAnimating()
        }
        .frame(width: 20, height: 20, alignment: .center)
    }

    // MARK: Private methods

    private func textColor(for configuration: Configuration) -> Color {
        Color(
            isEnabled ?
                style.titleColor :
                style.titleColorDisabled
        )
    }

    private func backgroundColor(for configuration: Configuration) -> Color {
        if isEnabled {
            return Color(
                configuration.isPressed ?
                    style.backgroundColorHighlighted :
                    style.backgroundColor
            )
        } else {
            return Color(style.backgroundColorDisabled)
        }
    }
}
