import UIKit

final class DataProvider {
    private enum Constants {
        static let dataUrlString = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        static let cacheDelay = 3600.0

        static let invalidUrlText = "Incorrect Url"
    }

    enum DataProviderError: Error {
        case invalidUrl
        case error(Error)

        var description: String {
            switch self {
                case .invalidUrl:
                    return Constants.invalidUrlText
                case .error(let error):
                    return error.localizedDescription
            }
        }
    }

    // MARK: — Public properties

    var company: Company?

    // MARK: — Private properties

    private var dataCache = NSCache<NSString, CachingModel>()

    // MARK: — Public

    func downloadData(completion: @escaping(Result<Company, DataProviderError>) -> ()) {
        guard let url = URL(string: Constants.dataUrlString) else {
            completion(.failure(.invalidUrl))
            return
        }

        if let cachedData = getDataFromCache(url: url) {
            guard let timestamp = cachedData.timestamp else { return }
            if timestamp < Date.timeIntervalBetween1970AndReferenceDate + Constants.cacheDelay {
                guard let company = cachedData.company else { return }
                completion(.success(company))
            } else {
                dataCache.removeObject(forKey: NSString(string: url.absoluteString))
            }
        }

        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(.error(error)))
            }

            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                return
            }

            guard let newCompany = self?.companyData(from: data, errorHandler: completion)?.company else { return }
            self?.cache(company: newCompany, for: NSString(string: url.absoluteString))

            DispatchQueue.main.async {
                self?.company = newCompany
                completion(.success(newCompany))
            }
        }
        dataTask.resume()
    }

    // MARK: — Private
    
    private func companyData(from data: Data, errorHandler: (Result<Company, DataProviderError>) -> ()) -> CompanyResponse? {
        let decoder = JSONDecoder()
        do {
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let companyData = try decoder.decode(CompanyResponse.self, from: data)
            return companyData
        }
        catch let jsonError {
            errorHandler(.failure(.error(jsonError)))
        }
        return nil
    }
    
    private func cache(company: Company, for key: NSString) {
        dataCache.setObject(CachingModel(company: company, timestamp: Date.timeIntervalBetween1970AndReferenceDate), forKey: key)
    }
    
    private func getDataFromCache(url: URL) -> CachingModel? {
        let url = NSString(string: url.absoluteString)
        guard let cachedData = dataCache.object(forKey: url) else { return nil }
        return cachedData
    }
}

