//
//  RealEstateListViewModel.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 17/04/2021.
//

import Foundation
import RxSwift
import RxRelay

class RealEstateListViewModel {
    
    //MARK: - rx Observables
    let datasource : BehaviorRelay<[RealEstate]> = BehaviorRelay(value: [])
    let webServiceStatus : BehaviorRelay<WebserviceStatus> = BehaviorRelay(value: .none)
    
    //MARK: - Local variables
    private let servicesClient = RealEstateServicesClient()
    private var realEstateList: RealEstateList?
    private let disposeBag = DisposeBag()
    
    
    func getRealEstates() {
        if let cachedRealEstates = CacheManager.getCachedRealEstates(), !cachedRealEstates.isEmpty {
            datasource.accept(cachedRealEstates)
            return
        }
        
        webServiceStatus.accept(.loading)
        servicesClient.getRealEstates()
            .subscribe(
                onNext: { [weak self] realEstatesList in
                    guard let self = self else { return }
                    self.datasource.accept(realEstatesList.items ?? [])
                    self.webServiceStatus.accept(.success)
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    print(error)
                    self.webServiceStatus.accept(.failed)
                }
            )
            .disposed(by: disposeBag)
    }
}
