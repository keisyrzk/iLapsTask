//
//  ListViewModel.swift
//  iLapsTask
//
//  Created by keisyrzk on 20.09.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import Foundation
import RxSwift
import CoreBluetooth

class ListViewModel: NSObject, CBCentralManagerDelegate {
    
    private var devices = Set<CBPeripheral>()
    private var centralManager: CBCentralManager?
    
    var devicesObservable: Observable<Array<CBPeripheral>> {
        return devicesSubject
    }
    private let devicesSubject = PublishSubject<Array<CBPeripheral>>()
    
    var errorObservable: Observable<Void> {
        return errorSubject
    }
    private let errorSubject = PublishSubject<Void>()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    func scanFordevices() {
        
        self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if (central.state == .poweredOn) {
            
            scanFordevices()
        }
        else {
            errorSubject.onNext()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
            //show only those devices that have a name
        guard let name = peripheral.name else {return}
        
        if !name.isEmpty {
            devices.insert(peripheral)
            devicesSubject.onNext(Array(devices))
        }
    }
}
