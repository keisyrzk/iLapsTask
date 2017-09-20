//
//  LRViewModel.swift
//  iLapsTask
//
//  Created by keisyrzk on 19.09.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import Foundation
import RxSwift

class LRViewModel {
    
    enum SelectedController{
        case Login
        case Register
    }
    
    fileprivate let mainDisposeBag = DisposeBag()
    
    let selectedSegment: Variable<SelectedController>
    
    init(selectedSegment: SelectedController) {
        
        self.selectedSegment = Variable(selectedSegment)
    }
}
