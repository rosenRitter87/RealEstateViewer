//
//  LoaderView.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 19/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

//MARK: - Delegate
protocol LoaderViewDelegate: NSObjectProtocol {
    func didRetry(loaderView: LoaderView)
}

class LoaderView: UIView {
    
    //MARK: - IBOutlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    //MARK: - Public variables
    weak var delegate: LoaderViewDelegate?
    
    //MARK: - private variables
    private let viewModel = LoaderViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LoaderView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupBinding()
    }
    
    
    //MARK: - RxSwift
    private func setupBinding() {
        viewModel
            .activityIndicatorIsHidden
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .loaderLabelIsHidden
            .bind(to: loadingLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .errorLabelIsHidden
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .retryButtonIsHidden
            .bind(to: retryButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Public methods
    func setupStatus(status: WebserviceStatus) {
        viewModel.status.accept(status)
    }
    
    //MARK: - IBActions
    @IBAction func retryButtonPressed(_ sender: UIButton) {
        delegate?.didRetry(loaderView: self)
    }
    
}
