//
//  RealEstateTableViewCell.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 17/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class RealEstateTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var propertiesLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var professionalLabel: UILabel!
    
    //MARK: - Variables
    let viewModel = RealEstateTableViewCellViewModel()
    let disposeBag = DisposeBag()
    var realEstate: RealEstate? {
        didSet {
            setupCell()
        }
    }
    
    //MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBinding()
    }
    
    //MARK: - RxSwift
    func setupBinding() {
        viewModel
            .image
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel
            .typeText
            .bind(to: typeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .propertiesText
            .bind(to: propertiesLabel.rx.text)
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
            .bind(to: professionalLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .isViewed
            .observeOn(MainScheduler.instance)
            .map({ [weak self] isViewed in
                guard let self = self else { return }
                self.photoImageView.alpha = isViewed ? 0.5 : 1
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    //MARK: - Private methods
    private func setupCell() {
        viewModel.realEstate.accept(realEstate)
    }

}
