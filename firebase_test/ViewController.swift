//
//  ViewController.swift
//  firebase_test
//
//  Created by Akitsugu Tamagawa on 2017/08/05.
//  Copyright © 2017年 Akitsugu Tamagawa. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var backImage: UIImageView!
    
    var remoteConfig: RemoteConfig!
    let plistName = "firebase_param"
    let configKey = "background_image"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // インスタンス
        self.remoteConfig = RemoteConfig.remoteConfig()
        
        // デバックモードを有効にする
        let remoteConfigSetting = RemoteConfigSettings.init(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSetting!
        
        
        // Plistから値を取得し、デフォルト値としてセットする
        remoteConfig.setDefaults(fromPlist: plistName)
        
        // 値の保持期間の定義
        let expirationDuration = remoteConfig.configSettings.isDeveloperModeEnabled ? 0 : 3600
        
        // フェッチを行う
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if (status == RemoteConfigFetchStatus.success) {
                // フェッチ成功
                print("Config fetched!")
                self.remoteConfig.activateFetched()
            } else {
                // フェッチ失敗
                print("Config not fetched")
                print("Error \(error!.localizedDescription)")
            }
            //背景をセットする
            self.setBackgroundImage()
        }
    }
    
    func setBackgroundImage() {
        // フェッチしてきたvalueの情報を取得する
        let imageName = remoteConfig[configKey].stringValue
        // imageに変換
        let image:UIImage = UIImage(named:imageName!)!
        // セットする
        self.backImage.image = image
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

