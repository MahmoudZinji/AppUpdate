//
//  AddTheseToYourAppDelegate.swift
//  Call Signature
//
//  Created by User on 26/07/2021.
//  Copyright © 2021 Monty Mobile. All rights reserved.
//



//These should be added in your appDelegate
//var remoteConfig: RemoteConfig?

//Then call the setupRemoteConfig() in didFinishLaunchingWithOptions

//func setupRemoteConfig(){
//
//    remoteConfig = RemoteConfig.remoteConfig()
//    remoteConfig?.configSettings = RemoteConfigSettings()
//
//    //set in app defaults
//    let defaults : [String : Any] = [
//        ForceUpdateChecker.FORCE_UPDATE_REQUIRED : false,
//        ForceUpdateChecker.FORCE_UPDATE_CURRENT_VERSION : "1.0(1)",
//        ForceUpdateChecker.FORCE_UPDATE_STORE_URL : "https://itunes.apple.com/us/app/myapp/id12345678?ls=1&mt=8"
//    ]
//
//    remoteConfig?.setDefaults(defaults as? [String : NSObject])
//
//    let expirationDuration = 60
//
//    remoteConfig?.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { [weak self] (status, error) in
//        if status == .success {
//            print("config fetch done")
//            self?.remoteConfig?.activate(completion: { (success, error) in
//                if success {
//                    print(self?.remoteConfig?.configValue(forKey: "force_update_required").boolValue ?? false)
//                    ForceUpdateChecker(listener: self!).check()
//                }
//            })
//        } else {
//            print("Config not fetched")
//            print("Error: \(error?.localizedDescription ?? "No error available.")")
//        }
//    }
//}
