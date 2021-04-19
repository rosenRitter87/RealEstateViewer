//
//  LoaderViewModel.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 19/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class LoaderViewModel {
    //MARK: - Input
    let status : BehaviorRelay<WebserviceStatus> = BehaviorRelay(value: .none)
    
    //MARK: - Output
    let activityIndicatorIsHidden : BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let loaderLabelIsHidden : BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let errorLabelIsHidden : BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let retryButtonIsHidden : BehaviorRelay<Bool> = BehaviorRelay(value: true)
    
    //MARK: - Local variables
    private let disposeBag = DisposeBag()
    
    //MARK: - Setup
    init() {
        setupBindng()
    }
    
    private func setupBindng() {
        status
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { [weak self] status in
                guard let self = self else { return }
                self.handleStatus(status: status)
            }).disposed(by: disposeBag)
    }
}

//MARK: - UI
extension LoaderViewModel {
    private func handleStatus(status: WebserviceStatus) {
        switch status {
        case .failed:
            activityIndicatorIsHidden.accept(true)
            loaderLabelIsHidden.accept(true)
            errorLabelIsHidden.accept(false)
            retryButtonIsHidden.accept(false)
            break
        case .none:
            break
        case .loading:
            activityIndicatorIsHidden.accept(false)
            loaderLabelIsHidden.accept(false)
            errorLabelIsHidden.accept(true)
            retryButtonIsHidden.accept(true)
            break
        case .success:
            break
        }
    }
}
