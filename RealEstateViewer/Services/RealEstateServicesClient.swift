//
//  RealEstateServicesClient.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 17/04/2021.
//

import Foundation
import RxSwift
import Alamofire
import AlamofireImage


class RealEstateServicesClient {
    func getRealEstates() -> Observable<RealEstateList> {
        return Observable.create { observer -> Disposable in
            let header: HTTPHeaders = ["Accept": "application/json"]
            Alamofire
                .SessionManager
                .default
                .request(kBaseUrl + "/listings.json", headers: header)
                .validate()
                .responseJSON {  response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? ServicesErrors.dataNotFound)
                            return
                        }
                        do {
                            let decoder = JSONDecoder()
                            let decodedItem = try decoder.decode(RealEstateList.self, from: data)
                            observer.onNext(decodedItem)
                        } catch let error {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func getRealEstate(id: Int) -> Observable<RealEstate> {
        return Observable.create { observer -> Disposable in
            let header: HTTPHeaders = ["Accept": "application/json"]
            Alamofire
                .SessionManager
                .default
                .request(kBaseUrl + "/listings/\(id).json", headers: header)
                .validate()
                .responseJSON {  response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? ServicesErrors.dataNotFound)
                            return
                        }
                        do {
                            let decoder = JSONDecoder()
                            let decodedItem = try decoder.decode(RealEstate.self, from: data)
                            observer.onNext(decodedItem)
                        } catch let error {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    //Download an image
    func downloadImage(urlString: String) -> Observable<UIImage> {
        return ImageDownloader.default.rx.download(urlString: urlString)
    }
}
