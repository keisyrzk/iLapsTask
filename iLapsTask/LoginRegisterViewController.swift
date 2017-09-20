//
//  LoginRegisterViewController.swift
//  iLapsTask
//
//  Created by keisyrzk on 19.09.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginRegisterViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    fileprivate let mainDisposeBag = DisposeBag()
    
    fileprivate var lrViewModel: LRViewModel!
    fileprivate var registerCtrl: RegisterViewController!
    fileprivate var loginCtrl: LoginViewController!
    
    
    
    func assignDependencies() {
        
        self.lrViewModel = LRViewModel(selectedSegment: .Login)
        
        let registerCtrl = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "lrRegister") as! RegisterViewController
        self.registerCtrl = registerCtrl
        
        let loginCtrl = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "lrLogin") as! LoginViewController
        self.loginCtrl = loginCtrl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assignDependencies()
        
        setupSegmentedControlView()
        applyBindings()
    }

    func applyBindings()
    {
        segmentedControl.rx.selectedSegmentIndex
            .map { (index) -> LRViewModel.SelectedController in
                switch index {
                case 0:
                    return .Login
                case 1:
                    return .Register
                default:
                    return .Login
                }
            }
            .bindTo(self.lrViewModel.selectedSegment)
            .addDisposableTo(mainDisposeBag)
        
        lrViewModel.selectedSegment.asObservable()
            .subscribe(onNext: { [weak self] (selectedController) in
                self?.showChild(selectedController: selectedController)
            })
            .addDisposableTo(mainDisposeBag)
        
    }
    
    func setupSegmentedControlView()
    {
        segmentedControl.setTitle(String.localized(key: .lr_login_title), forSegmentAt: 0)
        segmentedControl.setTitle(String.localized(key: .lr_register_title), forSegmentAt: 1)
        segmentedControl.backgroundColor = UIColor.clear
        switch self.lrViewModel.selectedSegment.value {
        case .Login:
            segmentedControl.selectedSegmentIndex = 0
        case .Register:
            segmentedControl.selectedSegmentIndex = 1
        }
    }
    
    func showChild(selectedController: LRViewModel.SelectedController)
    {
        var nextCtrl: UIViewController
        
        if selectedController == .Register
        {
            nextCtrl = registerCtrl
        }
        else
        {
            nextCtrl = loginCtrl
        }
        
        if let previousCtrl = childViewControllers.last
        {
            previousCtrl.removeFromParentViewController()
            
            for subview in containerView.subviews
            {
                subview.removeFromSuperview()
            }
        }
        
        addChildViewController(nextCtrl)
        nextCtrl.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nextCtrl.view)
        
        NSLayoutConstraint.activate([
            nextCtrl.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nextCtrl.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            nextCtrl.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            nextCtrl.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        nextCtrl.didMove(toParentViewController: self)
    }

}
