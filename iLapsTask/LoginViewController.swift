//
//  LoginViewController.swift
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

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    fileprivate let mainDisposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupObservables()
    }

    private func setup() {
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        titleLabel.text = String.localized(key: .l_title)
        emailLabel.text = String.localized(key: .global_email_title)
        passwordLabel.text = String.localized(key: .global_password_title)
        loginButton.setTitle(String.localized(key: .l_login_button_title), for: .normal)
    }
    
    private func setupObservables() {
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: {[weak self] keyboardVisibleHeight in
                self?.scrollView.contentInset.bottom = keyboardVisibleHeight + 10
            })
            .addDisposableTo(mainDisposeBag)
        
        loginButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] _ in
                
                self?.loginAction()
            })
            .addDisposableTo(mainDisposeBag)
    }

    private func loginAction() {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            alert(title: String.localized(key: .global_error),
                  text: String.localized(key: .alert_email_and_password),
                  actions: [.Ok])
                .subscribe(onNext: { _ in
                })
                .addDisposableTo(mainDisposeBag)
        }
        else {
            
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) {[weak self] (user, error) in
                
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
                                strongSelf?.loginAction()
                                
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
