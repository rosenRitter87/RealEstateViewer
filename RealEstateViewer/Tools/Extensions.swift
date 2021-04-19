//
//  Extensions.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 18/04/2021.
//

import Foundation
import AlamofireImage
import RxSwift

//Set AlamofireImage ready for rxswift
extension ImageDownloader: ReactiveCompatible {}
extension Reactive where Base: ImageDownloader {
    //Image download method
    public func download(urlString: String) -> Observable<UIImage> {
        return Observable.create { observer in
            guard let url = URL(string: urlString) else {
                observer.onError(ServicesErrors.invalidURL)
                return Disposables.create {}
            }
            let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            let requestReceipt = ImageDownloader.default.download(urlRequest) { response in
                if let error = response.error {
                    observer.onError(error)
                } else if let image = response.value {
                    observer.onNext(image)
                    observer.onCompleted()
                }
            }
            return Disposables.create {
               requestReceipt?.request.cancel()
            }
        }
    }
}

//Set userDefaults ready for codables

extension UserDefaults {
    func setCodable<T: Codable>(object: T, forKey: String) throws {
        let jsonData = try JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }
    
    func getCodable<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }
        return try JSONDecoder().decode(objectType, from: result)
    }
}


extension Double {
    func getCurrencyFormat() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.maximumFractionDigits = 0

        return formatter.string(from: NSNumber(value: self)) ?? "__"
    }
    
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}


extension String {
    mutating func removeOccurencesOfCharacters(characters: Set<String>) -> String {
        for character in characters {
            self = self.replacingOccurrences(of: character, with: "")
        }
        return self
    }
}
