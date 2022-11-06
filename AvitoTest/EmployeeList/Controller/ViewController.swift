import UIKit

final class ViewController:
    UIViewController,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource,
    UICollectionViewDelegate {

    private enum Constants {
        static let collectionHeaderHeight = 150.0
        static let collectionItemHeight = 200.0
        static let collectionItemPadding = 50.0
        static let collectionSectionInsets = UIEdgeInsets(top: 10, left: 1, bottom: 1, right: 1)

        static let collectionBackgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }

    // MARK: — Private properties

    private weak var collectionView: UICollectionView!
    private let placeholder = PlaceholderView()

    private let provider = DataProvider()

    // MARK: — Lifecycle
    
    override func loadView() {
        super.loadView()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        view.addSubview(placeholder)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.onRetry = { [weak self] in self?.loadData() }

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            placeholder.topAnchor.constraint(equalTo: view.topAnchor),
            placeholder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholder.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        self.collectionView = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Constants.collectionBackgroundColor

        collectionView.register(EmployeeCell.self, forCellWithReuseIdentifier: EmployeeCell.reuseIdentifier)
        collectionView.register(
            CompanyHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CompanyHeader.reuseIdentifier
        )

        loadData()
    }
    
    //MARK: - Loading and handling data

    private func loadData() {
        placeholder.startLoading()
        DispatchQueue.global().async {
            self.provider.downloadData { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let company):
                            self?.handleResponse(newValue: company)
                        case .failure(let error):
                            self?.handleError(error: error)
                    }
                }
            }
        }
    }
    
    private func handleResponse(newValue: Company) {
        placeholder.stopAnimating()
        placeholder.isHidden = true
        collectionView.reloadData()
    }

    private func handleError(error: DataProvider.DataProviderError) {
        placeholder.setError(text: error.description)
        placeholder.stopAnimating()
        placeholder.isHidden = false
        placeholder.showRetryButton()
    }
    
    // MARK: - CollectionViewDelegate and DataSource
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CompanyHeader.reuseIdentifier,
            for: indexPath
        ) as? CompanyHeader
        header?.companyName = provider.company?.name

        return header ?? UICollectionReusableView()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: view.frame.width, height: Constants.collectionHeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  provider.company?.sortedEmployees.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: view.frame.width - Constants.collectionItemPadding,
            height: Constants.collectionItemHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return Constants.collectionSectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EmployeeCell.reuseIdentifier,
            for: indexPath
        ) as? EmployeeCell {
            if let employee = provider.company?.sortedEmployees[indexPath.item] {
                cell.setLabels(
                    name: employee.name,
                    phone: employee.phoneNumber,
                    skills: employee.skills
                )
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

