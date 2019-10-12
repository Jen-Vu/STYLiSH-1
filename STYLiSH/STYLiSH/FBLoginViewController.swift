//
//  FBLoginViewController.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/29.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FBLoginViewController: UIViewController {

    @IBOutlet weak var loginFBView: UIView!
    @IBOutlet weak var loginAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var yConstraint: NSLayoutConstraint!
    
    let loginManger = LoginAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        yConstraint.constant = -220
        loginAlertView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, animations: {
            
                self.yConstraint.constant = 0
            
                self.view.layoutIfNeeded()
        })
    
    }
    
    @IBAction func fbLoginBtn(_ sender: Any) {
        
        let fbLoginManger = LoginManager()
        self.loginFBView.isHidden = true
        
        fbLoginManger.logIn(permissions: ["public_profile", "email"], from: self) { (action, _) in
            if action != nil {
                if let cancel = action?.isCancelled {
                    let tokenInfo = action?.token
//                    let uid = tokenInfo?.userID
                    let tokenString = tokenInfo?.tokenString
                    
                    if !cancel {
                        self.loginManger.getUserLoginInfo(token: tokenString ?? "")
                        self.loginStatus(true)

                    } else {
                        self.loginStatus(false)
                        print("=========fail to login")
                    }
                }
            } else {
                print("fail to login")
            }
        }
    }
    
    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    
    func loginStatus(_ login: Bool) {

        loginAlertView.isHidden = false
        
        if login {
            loginImage.image = #imageLiteral(resourceName: "Icons_44px_Success01")
            loginLabel.text = NSLocalizedString("Loginsuccess", comment: "")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.backtoVC()
            }

        } else {
            loginImage.image = #imageLiteral(resourceName: "Icons_44px_Failed")
            loginLabel.text = NSLocalizedString("Loginfail", comment: "")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.backtoVC()
            }
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        backtoVC()
    }
    
    func backtoVC() {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.yConstraint.constant = -220
            
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
            
            self.dismiss(animated: false, completion: nil)
        })
        
    }
    func setupLayout() {
        //設定圓角角度
        loginFBView.layer.cornerRadius = 12
        //設定哪個角需要加上圓角
        loginFBView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleLabel.text = NSLocalizedString("Login", comment: "")
        titleLabel.tintColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)        
        noticeLabel.text = NSLocalizedString("Loginfirst", comment: "")
        noticeLabel.tintColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
    }
    
}
