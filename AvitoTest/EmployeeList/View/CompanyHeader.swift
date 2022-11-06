import UIKit

final class CompanyHeader: UICollectionViewCell {
    private enum Constants {
        static let companyLabelFontSize = 30.0
    }

    // MARK: — Public properties

    static let reuseIdentifier = "headerId"

    var companyName: String? {
        didSet {
            guard let companyName = companyName else { return }
            companyNameLabel.text = companyName
        }
    }

    // MARK: — Private properties

    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.companyLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .red
        return label
    }()
    

    // MARK: — Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(companyNameLabel)
        NSLayoutConstraint.activate([
            companyNameLabel.topAnchor.constraint(equalTo: topAnchor),
            companyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            companyNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            companyNameLabel.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
