//
//  RealEstateListViewController.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 17/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class RealEstateListViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Variables
    private let viewModel = RealEstateListViewModel()
    private let disposeBag = DisposeBag()

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
        viewModel.getRealEstates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Reload data here to observe already viewed cells after returning from RealEstateViewController
        tableView.reloadData()
    }
    
    //MARK: - RxSwift
    
    private func setupBinding() {
        //progress HUD
        viewModel
            .webServiceStatus
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] webServiceStatus in
                guard let self = self else { return }
                self.manageHUDView(webServiceStatus: webServiceStatus)
            }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        //TableView
        viewModel
            .datasource
            .asObservable()
            .bind(to: self.tableView.rx.items(cellIdentifier: "RealEstateTableViewCell",
                                              cellType: RealEstateTableViewCell.self))
            { index, realEstate, cell in
                cell.realEstate = realEstate
        }.disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(RealEstate.self)
            .subscribe(onNext: { [weak self] realEstate in
                guard let self = self else { return }
                self.goToRealEstate(realEstate: realEstate)
            })
            .disposed(by: disposeBag)
    }
}


//MARK: - Helpers

extension RealEstateListViewController {
    
    //go To selected RealEstate
    private func goToRealEstate(realEstate: RealEstate) {
        let realEstateViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "RealEstateViewController") as! RealEstateViewController
        realEstateViewController.realEstateId = realEstate.id
        navigationController?.pushViewController(realEstateViewController, animated: true)
    }
    
    //show proper HUD view
    private func manageHUDView(webServiceStatus: WebserviceStatus) {
        switch webServiceStatus {
        case.loading:
            SVProgressHUD.show()
            break
        case .failed:
            SVProgressHUD.showError(withStatus: "Echec")
            break
        case .success:
            SVProgressHUD.dismiss()
            break
        default:
            break
        }
    }
}
