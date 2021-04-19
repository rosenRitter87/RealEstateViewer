//
//  RealEstateViewModel.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 19/04/2021.
//

import Foundation
import RxSwift
import RxRelay

class RealEstateViewModel  {
    //MARK: - Inputs
    let realEstateId: BehaviorRelay<Int?> = BehaviorRelay(value: nil)
    
    //MARK: - Outputs
    let webServiceStatus : BehaviorRelay<WebserviceStatus> = BehaviorRelay(value: .none)
    let realEstate: BehaviorRelay<RealEstate?> = BehaviorRelay(value: nil)
    let image : BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    let typeText : BehaviorRelay<String> = BehaviorRelay(value: "N/A")
    let priceText : BehaviorRelay<String> = BehaviorRelay(value: "N/A")
    let cityText : BehaviorRelay<String> = BehaviorRelay(value: "N/A")
    let professionalText : BehaviorRelay<String> = BehaviorRelay(value: "N/A")
    let roomsText : BehaviorRelay<String> = BehaviorRelay(value: "")
    let bedroomsText : BehaviorRelay<String> = BehaviorRelay(value: "")
    let surfaceText : BehaviorRelay<String> = BehaviorRelay(value: "")
    let roomsIsHidden : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let bedroomsIsHidden : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let surfaceIsHidden : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //MARK: - Local variables
    private let disposeBag = DisposeBag()
    private let servicesClient = RealEstateServicesClient()
    
    //MARK: - Setup
    
    init() {
        setupBindng()
    }
    
    private func setupBindng() {
        realEstate
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { [weak self] realEstate in
                guard let self = self else { return }
                guard let realEstate = realEstate else {
                    return
                }
                CacheManager.setRealEstateAsViewed(realEstate: realEstate)
                self.downloadImage(urlString: realEstate.url)
                self.getType(realEstate: realEstate)
                self.getPrice(realEstate: realEstate)
                self.getCity(realEstate: realEstate)
                self.getProperties(realEstate: realEstate)
                self.getProfessional(realEstate: realEstate)
            }).disposed(by: disposeBag)
        
        realEstateId
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { [weak self] id in
                guard let self = self, let id = id else { return }
                self.getRealEstate(id: id)
            }).disposed(by: disposeBag)
    }
    
    
    //MARK: - Public methods
    
    func getRealEstate(id: Int) {
        //Check for cache
        if let cachedRealEstate = CacheManager.getCachedRealEstate(id: id) {
            self.realEstate.accept(cachedRealEstate)
            return
        }
        
        //If no cache is found call web service
        webServiceStatus.accept(.loading)
        servicesClient
            .getRealEstate(id: id)
            .subscribe(
                onNext: { [weak self] realEstate in
                    guard let self = self else { return }
                    self.webServiceStatus.accept(.success)
                    CacheManager.cacheRealEstate(realEstate: realEstate)
                    self.realEstate.accept(realEstate)
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


//MARK: - Helpers

extension RealEstateViewModel {
    // download image
    private func downloadImage(urlString: String?) {
        guard let urlString = urlString else {
            self.image.accept(UIImage(named: "photo-not-available"))
            return
        }
        servicesClient
            .downloadImage(urlString: urlString)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] (image) in
                guard let self = self else { return }
                self.image.accept(image)
            } onError: { (error) in
                self.image.accept(UIImage(named: "photo-not-available"))
                print(error.localizedDescription)
            }.disposed(by: self.disposeBag)
    }
    
    private func getType(realEstate: RealEstate) {
        typeText.accept(realEstate.propertyType ?? "N/A")
    }
    
    private func getPrice(realEstate: RealEstate) {
        priceText.accept(realEstate.price.getCurrencyFormat())
    }
    
    private func getCity(realEstate: RealEstate) {
        cityText.accept(realEstate.city ?? "")
    }
    
    private func getProperties(realEstate: RealEstate) {
        if let area = realEstate.area {
            surfaceText.accept("Surface de \(area.clean)㎡")
            surfaceIsHidden.accept(false)
        } else {
            surfaceIsHidden.accept(true)
        }
        
        if let rooms = realEstate.rooms {
            roomsText.accept("\(rooms) pièces")
            roomsIsHidden.accept(false)
        } else {
            roomsIsHidden.accept(true)
        }
        
        if let bedrooms = realEstate.bedrooms {
            bedroomsText.accept("\(bedrooms) chambres")
            bedroomsIsHidden.accept(false)
        } else {
            bedroomsIsHidden.accept(true)
        }
    }
    
    private func getProfessional(realEstate: RealEstate?) {
        professionalText.accept(realEstate?.professional ?? "N/A")
    }
}
