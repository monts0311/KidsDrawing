//
//  ViewController.swift
//  KidsDrawing
//
//  Created by HONGYONG SOO on 2017. 8. 17..
//  Copyright © 2017년 com.monts. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    // MARK: - Const
    let SERVER_URL: String = "http://kidsking.co/hong/"
    let SERVER_LIST_FILE: String = "list_test.json"
    let SERVER_STICKER_LIST_FILE: String = "list_sticker.json"
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        requestImageList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController {
    func requestImageList() {
        Alamofire.request(SERVER_URL + SERVER_LIST_FILE).responseJSON { response in
            if let json = response.result.value {
                print("JSON: \(json)")
                
                self.requestStickerList()
            }
        }
    }
    
    func requestStickerList() {
        Alamofire.request(SERVER_URL + SERVER_STICKER_LIST_FILE).responseJSON { response in
            if let json = response.result.value {
                print("JSON: \(json)")
            }
        }
    }
}
