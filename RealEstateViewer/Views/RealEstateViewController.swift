//
//  RealEstateViewController.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 17/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class RealEstateViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var surfaceLabel: UILabel!
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var bedroomsLabel: UILabel!
    @IBOutlet weak var agencyLabel: UILabel!
    @IBOutlet weak var loaderView: LoaderView!
    
    //MARK: - Public Variables
    var realEstateId: Int?
    
    //MARK: - Private variables
    private let viewModel = RealEstateViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupBinding()
        loaderView.delegate = self
        viewModel.realEstateId.accept(realEstateId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    //MARK: - RxSwift
    func setupBinding() {
        viewModel
            .image
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel
            .typeText
            .bind(to: typeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .surfaceText
            .bind(to: surfaceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .roomsText
            .bind(to: roomsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .bedroomsText
            .bind(to: bedroomsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .priceText
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .cityText
            .bind(to: cityLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .professionalText
            .bind(to: agencyLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .surfaceIsHidden
            .bind(to: surfaceLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .roomsIsHidden
            .bind(to: roomsLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .bedroomsIsHidden
            .bind(to: bedroomsLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .webServiceStatus
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] webServiceStatus in
                guard let self = self else { return }
                self.handleLoaderView(webServiceStatus: webServiceStatus)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - IBActions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - LoaderViewDelegate
extension RealEstateViewController: LoaderViewDelegate {
    func didRetry(loaderView: LoaderView) {
        viewModel.realEstateId.accept(realEstateId)
    }
}

//MARK: - Helpers

extension RealEstateViewController {
    
    //show proper HUD view
    private func handleLoaderView(webServiceStatus: WebserviceStatus) {
        loaderView.setupStatus(status: webServiceStatus)
        switch webServiceStatus {
        case.loading, .failed:
            loaderView.isHidden = false
            break
        case .success, .none:
            loaderView.isHidden = true
            break
        }
    }
}
