//
//  RealEstateTableViewCellViewModel.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 17/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class RealEstateTableViewCellViewModel {
    //MARK: - Inputs
    public let realEstate: BehaviorRelay<RealEstate?> = BehaviorRelay(value: nil)
    
    //MARK: - Outputs
    let image : BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    let typeText : BehaviorRelay<String> = BehaviorRelay(value: "N/A")
    let priceText : BehaviorRelay<String> = BehaviorRelay(value: "N/A")
    let cityText : BehaviorRelay<String> = BehaviorRelay(value: "N/A")
    let propertiesText : BehaviorRelay<String> = BehaviorRelay(value: "N/A")
    let professionalText : BehaviorRelay<String> = BehaviorRelay(value: "N/A")
    let isViewed : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //MARK: - Local variables
    private let disposeBag = DisposeBag()
    private let servicesClient = RealEstateServicesClient()
    
    //MARK: - Setup
    init() {
        setupBinding()
    }
    
    private func setupBinding() {
        realEstate.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { [weak self] realEstate in
                guard let self = self else { return }
                self.downloadImage(urlString: realEstate?.url)
                self.checkIfViewed(realEstate: realEstate)
                self.getType(realEstate: realEstate)
                self.getPrice(realEstate: realEstate)
                self.getCity(realEstate: realEstate)
                self.getProperties(realEstate: realEstate)
                self.getProfessional(realEstate: realEstate)
            }).disposed(by: disposeBag)
    }
    
    
}

//MARK: - Helpers

extension RealEstateTableViewCellViewModel {
    //download image
    private func downloadImage(urlString: String?) {
        guard let urlString = urlString else {
            self.image.accept(UIImage(named: "photo-not-available"))
            return
        }
        servicesClient.downloadImage(urlString: urlString)
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
    
    //check if cell was already viewed
    private func checkIfViewed(realEstate: RealEstate?) {
        guard let realEstate = realEstate else {
            isViewed.accept(false)
            return
        }
        return isViewed.accept(CacheManager.isRealEstateViewed(realEstate: realEstate))
    }
    
    private func getType(realEstate: RealEstate?) {
        typeText.accept(realEstate?.propertyType ?? "N/A")
    }
    
    private func getPrice(realEstate: RealEstate?) {
        priceText.accept(realEstate?.price.getCurrencyFormat() ?? "__")
    }
    
    private func getCity(realEstate: RealEstate?) {
        cityText.accept(realEstate?.city ?? "")
    }
    
    private func getProperties(realEstate: RealEstate?) {
        guard let realEstate = realEstate else {
            propertiesText.accept("")
            return
        }
        
        //Build the properties string
        var string = "\(realEstate.rooms ?? -1)p • \(realEstate.bedrooms ?? -1)ch • \((realEstate.area ?? -1).clean)㎡"
        //remove the null parts
        propertiesText.accept(string.removeOccurencesOfCharacters(characters: ["-1p • ", "-1ch • ", " • -1㎡", "-1㎡"]))
    }
    
    private func getProfessional(realEstate: RealEstate?) {
        professionalText.accept(realEstate?.professional ?? "")
    }
}
