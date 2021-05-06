import UIKit

public struct ArticlePageViewData {
    let title: String
    let introduction: String?
    let description: NSAttributedString
    let image: UIImage?
    let externalUrls: [ExternalUrlViewData]?

    public init(
        title: String,
        introduction: String?,
        description: NSAttributedString,
        image: UIImage?,
        externalUrls: [ExternalUrlViewData]?
    ) {
        self.title = title
        self.introduction = introduction
        self.description = description
        self.image = image
        self.externalUrls = externalUrls
    }
}

public protocol ArticlePageViewDelegate: AnyObject {
    func articleViewDidSelectExternalUrl(_ url: URL?)
}

extension SATSFont.TextStyle {
    static let articleIntroduction = SATSFont.TextStyle(
        size: 19,
        nativeStyle: .subheadline,
        name: "articleIntroduction"
    )
}

public class ArticlePageView: UIView {

    public lazy var topBar = TopBar(withAutoLayout: true)
    public weak var delegate: ArticlePageViewDelegate?

    // MARK: - Private

    private let roundedCornerRadius: CGFloat = 8
    private let headerHeight: CGFloat = 56
    private var hasImage: Bool { imageView.image != nil }
    private var imageHeight: CGFloat { 230 + safeAreaInsets.top }
    private lazy var imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageHeight)

    // MARK: - Views

    private lazy var titleLabel: SATSLabel = {
        let label = SATSLabel(style: .h1, weight: .satsFeeling)
        label.textColor = .onSecondary
        label.numberOfLines = 0
        return label
    }()

    private lazy var introductionLabel: SATSLabel = {
        let label = SATSLabel(style: .basic, weight: .default)
        label.font = SATSFont.font(style: .articleIntroduction, weight: .default)
        label.textColor = .onSecondaryDisabled
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: SATSLabel = {
        let label = SATSLabel(style: .large)
        label.textColor = .onSecondaryDisabled
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private func createExternalUrlView(viewData: ExternalUrlViewData) -> ExternalUrlView {
        let view = ExternalUrlView(withAutoLayout: true)
        view.onOpenUrl = externalUrlTapped
        view.configure(with: viewData)
        return view
    }

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.backgroundColor = .backgroundSecondary
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.delegate = self
        scrollView.contentInset.top = headerHeight
        return scrollView
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

// MARK: - Public methods

extension ArticlePageView {
    public func configure(with viewData: ArticlePageViewData) {
        titleLabel.text = viewData.title.uppercased()
        introductionLabel.text = viewData.introduction
        descriptionLabel.attributedText = viewData.description

        topBar.configure(with: viewData.title)
        topBar.hideTitle()

        if let image = viewData.image {
            set(headerImage: image)
        }

        if let urls = viewData.externalUrls {
            urls.forEach {
                let view = createExternalUrlView(viewData: $0)
                contentStackView.addArrangedSubview(view)
                contentStackView.setCustomSpacing(0, after: view)
                view.widthAnchor.constraint(equalTo: readableContentGuide.widthAnchor).isActive = true
            }
        }
    }

    public func set(headerImage image: UIImage) {
        imageView.image = image

        contentStackView.layer.cornerRadius = roundedCornerRadius
        // here we make space for the content
        scrollView.contentInset.top = imageHeight - roundedCornerRadius

        topBar.set(style: .transparent)
    }
}

// MARK: - Private methods

extension ArticlePageView {
    private func setup() {
        [
            titleLabel,
            introductionLabel,
            descriptionLabel,
        ].forEach(contentStackView.addArrangedSubview(_:))

        scrollView.addSubview(contentStackView)

        [
            imageView,
            scrollView,
            topBar,
        ].forEach(addSubview(_:))

        scrollView.pin(to: safeAreaLayoutGuide)
        contentStackView.pin(to: scrollView)

        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: topAnchor),
            topBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBar.heightAnchor.constraint(greaterThanOrEqualToConstant: headerHeight),

            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageHeightConstraint,

            titleLabel.widthAnchor.constraint(equalTo: readableContentGuide.widthAnchor),
            introductionLabel.widthAnchor.constraint(equalTo: readableContentGuide.widthAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: readableContentGuide.widthAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func updateImageSize() {
        let topInset = scrollView.contentInset.top
        let scrollOffset = -scrollView.contentOffset.y
        let additionalHeight = scrollOffset - topInset
        imageHeightConstraint.constant = imageHeight + max(0, additionalHeight)
    }

    private func handleHeaderShift() {
        let headerShiftThreshold = scrollView.contentOffset.y + topBar.frame.size.height

        if headerShiftThreshold >= 0 {
            topBar.set(style: .solid, animated: true)
        } else {
            topBar.set(style: .transparent, animated: true)
        }
    }

    private func handleTitleShift() {
        if scrollView.contentOffset.y >= titleLabel.bounds.origin.y {
            topBar.showTitle(animated: true)
        } else if scrollView.contentOffset.y < titleLabel.bounds.origin.y {
            topBar.hideTitle(animated: true)
        }
    }

    private func externalUrlTapped(url: URL?) {
        delegate?.articleViewDidSelectExternalUrl(url)
    }
}

extension ArticlePageView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if hasImage {
            updateImageSize()
            handleHeaderShift()
        }
        handleTitleShift()
    }
}
