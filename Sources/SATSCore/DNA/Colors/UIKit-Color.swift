import UIKit

public extension UIColor {

    // MARK: Background

    static var backgroundPrimary: UIColor { color(.backgroundPrimary) }
    static var backgroundSecondary: UIColor { color(.backgroundSecondary) }
    static var backgroundSurface: UIColor { color(.backgroundSurface) }

    // MARK: Secondary

    static var secondary: UIColor { color(.secondary) }
    static var secondaryHighlight: UIColor { color(.secondaryHighlight) }
    static var secondaryDisabled: UIColor { color(.secondaryDisabled) }
    static var clean: UIColor { color(.clean) }

    // MARK: CTA

    static var cta: UIColor { color(.cta) }
    static var ctaHighlight: UIColor { color(.ctaHighlight) }
    static var ctaDisabled: UIColor { color(.ctaDisabled) }
    static var nonText: UIColor { color(.nonText) }

    // MARK: Waitlist

    static var waitlist: UIColor { color(.waitlist) }
    static var waitlistHighlight: UIColor { color(.waitlistHighlight) }

    // MARK: Signal

    static var signalSuccess: UIColor { color(.signalSuccess) }
    static var signalWarning: UIColor { color(.signalWarning) }
    static var signalDelete: UIColor { color(.signalDelete) }
    static var signalError: UIColor { color(.signalError) }

    // MARK: UI

    static var border: UIColor { color(.border) }
    static var shimmer: UIColor { color(.shimmer) }
    static var tabs: UIColor { color(.tabs) }

    // MARK: "On" colors
    // used in text and icons "on" top of another color

    static var onPrimary: UIColor { color(.onPrimary) }
    static var onPrimaryDisabled: UIColor { color(.onPrimaryDisabled) }

    static var onSecondary: UIColor { color(.onSecondary) }
    static var onSecondaryDisabled: UIColor { color(.onSecondaryDisabled) }

    static var onClean: UIColor { color(.onClean) }
    static var onCleanDisabled: UIColor { color(.onCleanDisabled) }

    static var onCta: UIColor { color(.onCta) }
    static var onCtaDisabled: UIColor { color(.onCtaDisabled) }

    static var onNonText: UIColor { color(.onNonText) }
    static var onSignal: UIColor { color(.onSignal) }
    static var onWaitlist: UIColor { color(.onWaitlist) }

    static var onBackgroundEnabledOn: UIColor { color(.onBackgroundEnabledOn) }
    static var onBackgroundEnabledOff: UIColor { color(.onBackgroundEnabledOff) }
    static var onBackgroundDisabledOn: UIColor { color(.onBackgroundDisabledOn) }
    static var onBackgroundDisabledOff: UIColor { color(.onBackgroundDisabledOff) }
    static var onBackgroundPrimary: UIColor { color(.onBackgroundPrimary) }
    static var onBackgroundSecondary: UIColor { color(.onBackgroundSecondary) }
    static var onBackgroundDisabled: UIColor { color(.onBackgroundDisabled) }

    static var onSurfaceEnabledOn: UIColor { color(.onSurfaceEnabledOn) }
    static var onSurfaceEnabledOff: UIColor { color(.onSurfaceEnabledOff) }
    static var onSurfaceDisabledOn: UIColor { color(.onSurfaceDisabledOn) }
    static var onSurfaceDisabledOff: UIColor { color(.onSurfaceDisabledOff) }
    static var onSurfacePrimary: UIColor { color(.onSurfacePrimary) }
    static var onSurfaceSecondary: UIColor { color(.onSurfaceSecondary) }
    static var onSurfaceDisabled: UIColor { color(.onSurfaceDisabled) }

    static var onGradientPrimary: UIColor { color(.onGradientPrimary) }
    static var onGradientSecondary: UIColor { color(.onGradientSecondary) }
    static var onGradientDisabled: UIColor { color(.onGradientDisabled) }

    // MARK: Theme dependant colors

    static var primary: UIColor { themedColor(.primary) }
    static var primaryHighlight: UIColor { themedColor(.primaryHighlight) }
    static var primaryDisabled: UIColor { themedColor(.primaryDisabled) }

    static var selection: UIColor { themedColor(.selection) }

    static var backgroundTopStart: UIColor { themedColor(.backgroundTopStart) }
    static var backgroundTopEnd: UIColor { themedColor(.backgroundTopEnd) }

    static var navigationPrimary: UIColor { themedColor(.navigationPrimary) }
    static var navigationSecondary: UIColor { themedColor(.navigationSecondary) }

    // MARK: Private

    private static func themedColor(_ name: ColorName) -> UIColor {
        guard let color = ColorTheme.current[name] else {
            preconditionFailure("❌ \(name.rawValue) color not found! in \(ColorTheme.current.name)")
        }

        return color
    }

    private static func color(_ name: ColorName) -> UIColor {
        guard let color = UIColor(named: name.rawValue, in: .module, compatibleWith: nil) else {
            preconditionFailure("❌ \(name.rawValue) color not found!")
        }

        return color
    }
}
