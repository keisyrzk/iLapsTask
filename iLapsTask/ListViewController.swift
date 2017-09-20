//
//  ListViewController.swift
//  iLapsTask
//
//  Created by keisyrzk on 19.09.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit
import RxSwift
import CoreBluetooth

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bleTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var listViewModel: ListViewModel!
    fileprivate let mainDisposeBag = DisposeBag()
    
    private var devices: [CBPeripheral] = []
    
    func assignDependencies() {
        
        self.listViewModel = ListViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assignDependencies()
        setup()
        setupObservables()
    }
    
    private func setupObservables() {
        
        listViewModel.devicesObservable
            .subscribe(onNext: { [weak self] foundDevices in
                self?.devices = foundDevices
                self?.tableView.reloadData()
            })
            .addDisposableTo(mainDisposeBag)
        
        listViewModel.errorObservable
            .subscribe(onNext: { [weak self] _ in
                
                self?.alert(title: String.localized(key: .global_error),
                      text: String.localized(key: .alert_ble_message),
                      actions: [.Ok, .Retry])
                    .subscribe(onNext: { [weak self] action in
                        
                        switch action {
                            
                        case .Retry:
                            self?.listViewModel.scanFordevices()
                            
                        default:
                            break
                        }
                    })
                    .addDisposableTo(self!.mainDisposeBag)
            })
            .addDisposableTo(mainDisposeBag)
    }

    private func setup() {
        
        bleTitleLabel.text = String.localized(key: .main_ble_title)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = devices[indexPath.row].name ?? "no name provided"
        
        return cell
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        guard let currentTopVisibleCellIndex = tableView.indexPathsForVisibleRows?.first else {return}
        tableView.scrollToRow(at: currentTopVisibleCellIndex, at: .top, animated: false)
    }
}
