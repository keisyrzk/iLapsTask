//
//  RegisterViewController.swift
//  iLapsTask
//
//  Created by keisyrzk on 19.09.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import Firebase
import FirebaseAuth


class RegisterViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    fileprivate let mainDisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupObservables()
    }

    private func setup() {
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        titleLabel.text = String.localized(key: .r_title)
        emailLabel.text = String.localized(key: .global_email_title)
        passwordLabel.text = String.localized(key: .global_password_title)
        registerButton.setTitle(String.localized(key: .r_register_button_title), for: .normal)
    }
    
    private func setupObservables() {
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: {[weak self] keyboardVisibleHeight in
                self?.scrollView.contentInset.bottom = keyboardVisibleHeight + 10
            })
            .addDisposableTo(mainDisposeBag)
        
        registerButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] _ in
                
                self?.registerAction()
            })
            .addDisposableTo(mainDisposeBag)
    }
    
    private func registerAction() {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            
            alert(title: String.localized(key: .global_error),
                  text: String.localized(key: .alert_email_and_password),
                  actions: [.Ok])
                .subscribe(onNext: { _ in
                })
                .addDisposableTo(mainDisposeBag)
        }
        else {
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {[weak self] (user, error) in
                
                if error == nil {
                    let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    self?.present(mainVC!, animated: true, completion: nil)
                    
                }
                else {
                    
                    guard let strongSelf = self else { return }
                    strongSelf.alert(title: String.localized(key: .global_error),
                          text: error?.localizedDescription,
                          actions: [.Ok, .Retry])
                        .subscribe(onNext: { [weak strongSelf] action in
                            
                            switch action {
                                
                            case .Retry:
                                strongSelf?.registerAction()
                                
                            default:
                                break
                            }
                        })
                        .addDisposableTo(strongSelf.mainDisposeBag)
                }
            }
        }
    }
}
