import UIKit

public struct TopBarStyle: Equatable {
    let tintColor: UIColor
    let borderColor: UIColor
    let backgroundColor: UIColor
    let textColor: UIColor
}

public extension TopBarStyle {
    static let solid = TopBarStyle(
        tintColor: .onBackgroundPrimary,
        borderColor: .border,
        backgroundColor: .backgroundSecondary,
        textColor: .onSecondary
    )

    static let transparent = TopBarStyle(
        tintColor: .onPrimary,
        borderColor: .clear,
        backgroundColor: .clear,
        textColor: .onPrimary
    )
}

public class TopBar: UIView {

    // MARK: Private properties

    private lazy var titleLayoutConstraint = titleLabel.centerYAnchor.constraint(
        equalTo: horizontalWrapperView.safeAreaLayoutGuide.centerYAnchor,
        constant: frame.height
    )

    private var style: TopBarStyle = .solid {
        didSet {
            updateLayout()
        }
    }

    // MARK: Views

    private lazy var horizontalWrapperView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layoutMargins = .init(all: 4)
        return view
    }()

    private lazy var leftButtonWrapper: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.spacing = 4
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var rightButtonWrapper: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.spacing = 4
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var titleLabel: SATSLabel = {
        let label = SATSLabel(style: .h3, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private lazy var verticalWrapperStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var borderView = UIView(withAutoLayout: true)

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

// MARK: Public methods

extension TopBar {
    public func configure(with title: String, style: TopBarStyle = .solid) {
        titleLabel.text = title
        self.style = style
    }

    public func addRightButton(_ button: UIButton) {
        rightButtonWrapper.addArrangedSubview(button)
        updateLayout()
    }

    public func addLeftButton(_ button: UIButton) {
        leftButtonWrapper.addArrangedSubview(button)
        updateLayout()
    }

    public func hideTitle(animated: Bool = false) {
        let frameHeight = frame.height
        if titleLayoutConstraint.constant == frameHeight { return }

        if animated {
            UIView.animate(withDuration: 0.2) {
                self.titleLayoutConstraint.constant = frameHeight
                self.layoutIfNeeded()
            }
        } else {
            titleLayoutConstraint.constant = frameHeight
        }
    }

    public func showTitle(animated: Bool = false) {
        if titleLayoutConstraint.constant == 0 { return }

        if animated {
            UIView.animate(withDuration: 0.2) {
                self.titleLayoutConstraint.constant = 0
                self.layoutIfNeeded()
            }
        } else {
            titleLayoutConstraint.constant = 0
        }
    }

    public func set(style: TopBarStyle, animated: Bool = false) {
        if self.style == style { return }

        if animated {
            UIView.animate(withDuration: 0.2) {
                self.style = style
                self.layoutIfNeeded()
            }
        } else {
            self.style = style
        }
    }
}

// MARK: Private methods

extension TopBar {
    private func setup() {
        clipsToBounds = true

        addSubview(verticalWrapperStackView)

        [
            horizontalWrapperView,
            borderView,
        ].forEach(verticalWrapperStackView.addArrangedSubview(_:))

        [
            leftButtonWrapper,
            titleLabel,
            rightButtonWrapper,
        ].forEach(horizontalWrapperView.addSubview(_:))

        verticalWrapperStackView.pin(to: self)

        NSLayoutConstraint.activate([
            leftButtonWrapper.leadingAnchor.constraint(equalTo: horizontalWrapperView.layoutMarginsGuide.leadingAnchor),
            leftButtonWrapper.topAnchor.constraint(equalTo: horizontalWrapperView.layoutMarginsGuide.topAnchor),
            leftButtonWrapper.bottomAnchor.constraint(equalTo: horizontalWrapperView.layoutMarginsGuide.bottomAnchor),
            leftButtonWrapper.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -4),

            titleLabel.centerXAnchor.constraint(equalTo: horizontalWrapperView.centerXAnchor),
            titleLayoutConstraint,
            titleLabel.trailingAnchor.constraint(equalTo: rightButtonWrapper.leadingAnchor, constant: -4),

            rightButtonWrapper.trailingAnchor.constraint(
                equalTo: horizontalWrapperView.layoutMarginsGuide.trailingAnchor
            ),
            rightButtonWrapper.topAnchor.constraint(equalTo: horizontalWrapperView.layoutMarginsGuide.topAnchor),
            rightButtonWrapper.bottomAnchor.constraint(equalTo: horizontalWrapperView.layoutMarginsGuide.bottomAnchor),

            borderView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }

    private func updateLayout() {
        let buttons = leftButtonWrapper.arrangedSubviews + rightButtonWrapper.arrangedSubviews

        titleLabel.textColor = style.textColor
        backgroundColor = style.backgroundColor
        borderView.backgroundColor = style.borderColor
        buttons.forEach { $0.tintColor = style.tintColor }
    }
}