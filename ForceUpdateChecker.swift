//
//  ForceUpdateChecker.swift
//  Call Signature
//
//  Created by User on 13/07/2021.
//  Copyright © 2021 Monty Mobile. All rights reserved.
//

import Foundation
import Firebase

protocol OnUpdateNeededListener {
    func onUpdateNeeded(updateUrl : String)
    func onNoUpdateNeeded()
}

class ForceUpdateChecker {

    static let TAG = "ForceUpdateChecker"

    static let FORCE_UPDATE_STORE_URL = "force_update_store_url"
    static let FORCE_UPDATE_CURRENT_VERSION = "force_update_current_version"
    static let FORCE_UPDATE_REQUIRED = "force_update_required"
    
    var listener : OnUpdateNeededListener

    init(listener : OnUpdateNeededListener) {
        self.listener = listener
    }

    func check(){
        let remoteConfig = RemoteConfig.remoteConfig()
        let forceRequired = remoteConfig[ForceUpdateChecker.FORCE_UPDATE_REQUIRED].boolValue

        print("\(ForceUpdateChecker.TAG) : forceRequired : \(forceRequired)")
        
        if(forceRequired == true){

            let currentVersion = remoteConfig[ForceUpdateChecker.FORCE_UPDATE_CURRENT_VERSION].stringValue
            print("\(ForceUpdateChecker.TAG) : currentVersion: \(currentVersion!)")

            if(currentVersion != nil){
                let appVersion = getAppVersion()

                if( currentVersion != appVersion){

                    let url = remoteConfig[ForceUpdateChecker.FORCE_UPDATE_STORE_URL].stringValue
                    if(url != nil){
                        listener.onUpdateNeeded(updateUrl: url! )
                    }
                }
                else {
                    listener.onNoUpdateNeeded()
                }
            }
            else {
                listener.onNoUpdateNeeded()
            }
        } else {
            listener.onNoUpdateNeeded()
        }
    }

    func getAppVersion() -> String {
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let version = "\(versionNumber)(\(buildNumber))"
        print("\(ForceUpdateChecker.TAG) : version: \(version)")

        return version
    }
}

