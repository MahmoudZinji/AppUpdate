//
//  UpdateAppViewController.swift
//  Call Signature
//
//  Created by User on 13/07/2021.
//  Copyright © 2021 Monty Mobile. All rights reserved.
//

import UIKit
import Foundation
import FirebaseRemoteConfig

class UpdateAppViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var alertViewStoryBoard: UIView!
    
    // MARK: - Properties
    var url : String?
    
    // MARK: - Action Methods
    @IBAction func onBtnUpdateClick(_ sender: UIButton) {
        openURL(withURL: URL(string: url!)!)
    }
    
    @IBAction func NoBtnUpdateClick(_ sender: UIButton) {
        let root = UIApplication.shared.keyWindow?.rootViewController
        root?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        //Add a blur effect in the background
        let effect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = self.view.bounds
        view.insertSubview(blurView, at: 0)
        
        
        alertViewStoryBoard.addShadow(ofColor: .lightGray, radius: 3, offset: .zero, opacity: 0.3)
    }
}

//MARK:- Extension for the AppDelegate in order to just have this file in any project
extension AppDelegate : OnUpdateNeededListener {
    func onUpdateNeeded(updateUrl: String) {
        DispatchQueue.main.async {
            let controller = UIStoryboard(name: "UpdateAppViewController", bundle: nil).instantiateViewController(withIdentifier: "UpdateAppViewController") as! UpdateAppViewController
            controller.url = updateUrl
            controller.modalPresentationStyle = .overFullScreen
            
            UIApplication.getViewControllerOnTop()?.present(controller, animated: false, completion: {
                controller.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
            })
        }
    }
    
    func onNoUpdateNeeded() {
        print("onNoUpdateNeeded()")
        if UIApplication.getViewControllerOnTop() is UpdateAppViewController {
            UIApplication.getViewControllerOnTop()?.dismiss(animated: false, completion: nil)
        }
    }
}

//MARK:- RemoteConfig Setup
extension AppDelegate {
    
    //Make sure to add the below line to your AppDelegate file
    //var remoteConfig: RemoteConfig?
    
    func setupRemoteConfig(){
        
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig?.configSettings = RemoteConfigSettings()
        
        //set in app defaults
        let defaults : [String : Any] = [
            ForceUpdateChecker.FORCE_UPDATE_REQUIRED : false,
            ForceUpdateChecker.FORCE_UPDATE_CURRENT_VERSION : "1.0(1)",
            ForceUpdateChecker.FORCE_UPDATE_STORE_URL : "https://itunes.apple.com/us/app/myapp/id12345678?ls=1&mt=8"
        ]
        
        remoteConfig?.setDefaults(defaults as? [String : NSObject])
        
        let expirationDuration = 60

        remoteConfig?.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { [weak self] (status, error) in
            if status == .success {
                print("config fetch done")
                self?.remoteConfig?.activate(completion: { (success, error) in
                    if success {
                        print(self?.remoteConfig?.configValue(forKey: "force_update_required").boolValue ?? false)
                        ForceUpdateChecker(listener: self!).check()
                    }
                })
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}

//MARK:-Extension UIApplication
extension UIApplication {
    class func getViewControllerOnTop(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getViewControllerOnTop(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getViewControllerOnTop(base: selected)

        } else if let presented = base?.presentedViewController {
            return getViewControllerOnTop(base: presented)
        }
        return base
    }
}



























//    func setUpAlertView() {
//
//        [alertView].forEach {
//            (view.addSubview($0))
//        }
//
//        [titleLabel, descriptionLabel, updateButton]
//            .forEach {
//                (alertView.addSubview($0))
//            }
//
//        NSLayoutConstraint.activate([
//
//            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
//            alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
//
//            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
//            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
//            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20),
//
//            descriptionLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
//            descriptionLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
//            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
//
//            updateButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
//            updateButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
//            updateButton.widthAnchor.constraint(equalToConstant: 65),
//            updateButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20),
//        ])
//    }

//        setUpAlertView()

//    @objc func buttonAction() {
//        openURL(withURL: URL(string: url!)!)
//    }

//    var alertView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 1
//        view.layer.shadowOffset = CGSize(width: 5, height: 5)
//        view.layer.shadowRadius = 10
//        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
//
//        view.layer.shouldRasterize = true
//        view.layer.rasterizationScale = UIScreen.main.scale
//        return view
//    }()
//
//    lazy var descriptionLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.textColor = .black
//        lbl.backgroundColor = .clear
//        lbl.font = UIFont.systemFont(ofSize: 17)
//        lbl.textAlignment = .left
//        lbl.numberOfLines = 0
//        lbl.text = "Please, Update application to the new version to continue."
//        lbl.lineBreakMode = .byTruncatingTail
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//
//        return lbl
//    }()
//
//    lazy var titleLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.textColor = .black
//        lbl.backgroundColor = .clear
//        lbl.textAlignment = .left
//        lbl.font = UIFont.boldSystemFont(ofSize: 17)
//        lbl.numberOfLines = 1
//        lbl.text = "New Version Available"
//        lbl.lineBreakMode = .byTruncatingTail
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//
//        return lbl
//    }()
//
//    lazy var updateButton: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("UPDATE", for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
//        btn.isUserInteractionEnabled = true
//        btn.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setTitleColor(UIColor(displayP3Red: 0.196, green: 0.3098, blue: 0.52, alpha: 1), for: .normal)
//
//        return btn
//    }()
