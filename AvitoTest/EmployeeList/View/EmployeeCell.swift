import UIKit

final class EmployeeCell: UICollectionViewCell {
    private enum Constants {
        static let nameFontSize = 20.0
        static let phoneLabelFontSize = 14.0
        static let borderWidth = 1.0
        static let skillsLabelNumberOfLines = 0
        static let cornerRadius = 20.0
    }

    // MARK: — Public properties

    static let reuseIdentifier = "cellId"

    // MARK: — Private properties

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Employee name"
        label.font = UIFont.boldSystemFont(ofSize: Constants.nameFontSize)
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Employee phone"
        label.font = UIFont.systemFont(ofSize: Constants.phoneLabelFontSize)
        return label
    }()
    
    private let skillsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Skills:\n"
        label.numberOfLines = Constants.skillsLabelNumberOfLines
        return label
    }()

    //MARK: - Public
    
    func setLabels(name: String, phone: String, skills: [String]) {
        nameLabel.text = name
        phoneLabel.text = phone

        var skillsText = "Skills:\n"
        for skill in skills {
            skillsText += skill + "\n"
        }
        skillsLabel.text = skillsText
    }

    // MARK: — Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: — Private

    private func setUpView() {
        contentView.backgroundColor = .lightGray
        contentView.layer.borderWidth = Constants.borderWidth
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.borderColor = UIColor.black.cgColor

        addSubview(nameLabel)
        addSubview(phoneLabel)
        addSubview(skillsLabel)

        setUpConstraints()
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),

            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            phoneLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            phoneLabel.heightAnchor.constraint(equalToConstant: 10),

            skillsLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            skillsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            skillsLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            skillsLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
