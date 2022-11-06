import UIKit

final class PlaceholderView: UIView {
    private enum Constants {
        static let errorImageName = "ErrorImage"
        static let backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

        static let retryTitle = "Reload"
        static let retryBorderWidth = 1.0
        static let retryCornerRadius = 20.0
        static let retryBorderColor = UIColor.black
        static let retryBackgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 0.5)

        static let errorTitle = "Error"
        static let errorNumberOfLines = 0
    }

    // MARK: Public properties

    var onRetry: (() -> ())?

    // MARK: Private properties

    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()

    private let retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.retryTitle, for: .normal)
        button.backgroundColor = Constants.retryBackgroundColor
        button.layer.cornerRadius = Constants.retryCornerRadius
        button.layer.borderWidth = Constants.retryBorderWidth
        button.layer.borderColor = Constants.retryBorderColor.cgColor
        button.isHidden = true
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = Constants.errorNumberOfLines
        label.text = Constants.errorTitle
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let noConnectionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Constants.errorImageName)
        imageView.isHidden = true
        return imageView
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.backgroundColor
        addSubview(noConnectionImage)
        addSubview(errorLabel)
        addSubview(retryButton)
        addSubview(loader)
        
        retryButton.addTarget(self, action: #selector(onRetryHandler), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            noConnectionImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            noConnectionImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            
            errorLabel.topAnchor.constraint(equalTo: noConnectionImage.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 100),
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 8),
            retryButton.heightAnchor.constraint(equalToConstant: 50),
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public
    
    func startLoading() {
        noConnectionImage.isHidden = true
        errorLabel.isHidden = true
        retryButton.isHidden = true
        loader.startAnimating()
    }

    func stopAnimating() {
        loader.stopAnimating()
    }

    func showRetryButton() {
        noConnectionImage.isHidden = false
        errorLabel.isHidden = false
        retryButton.isHidden = false
    }
    
    func setError(text: String) {
        errorLabel.text = text
    }

    // MARK: — Private

    @objc
    private func onRetryHandler() {
        guard let onRetry = onRetry else { return }
        onRetry()
    }
}
