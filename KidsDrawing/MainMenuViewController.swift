//
//  ViewController.swift
//  KidsDrawing
//
//  Created by HONGYONG SOO on 2017. 8. 17..
//  Copyright © 2017년 com.monts. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire

class MainMenuViewController: UIViewController {
    // MARK: - Const
    let SERVER_URL: String = "http://kidsking.co/hong/"
    let SERVER_LIST_FILE: String = "list_test.json"
    let SERVER_STICKER_LIST_FILE: String = "list_sticker.json"
    
    // MARK: - Global
    var mItemImage:ItemImage?
    var mItemStickersInfo:[ItemStickerGroupInfo]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var mIvDrawName: UIImageView!
    @IBOutlet weak var mIvStickerName: UIImageView!
    @IBOutlet weak var mIvPaintName: UIImageView!
    @IBOutlet weak var mIvAlbumName: UIImageView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = true
        setLocalizeImage();
        requestImageList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBAction
    @IBAction func onSelectedDrawing(_ sender: Any) {
        print("onSelectedDrawing")
    }
    
    @IBAction func onSelectedSticker(_ sender: Any) {
        print("onSelectedSticker")
    }
    
    @IBAction func onSelectedColoring(_ sender: Any) {
        print("onSelectedColoring")
    }
    
    @IBAction func onSelectedAlbum(_ sender: Any) {
        print("onSelectedAlbum")
    }
}

extension MainMenuViewController {
    func setLocalizeImage() {
        // 2017.10.10 : Localize
        mIvDrawName.image = UIImage(named:NSLocalizedString("DRAW",comment:""))
        mIvStickerName.image = UIImage(named:NSLocalizedString("STICKER", comment:""))
        mIvPaintName.image = UIImage(named:NSLocalizedString("PAINT", comment:""))
        mIvAlbumName.image = UIImage(named:NSLocalizedString("ALBUM", comment:""))
    }
    
    func requestImageList() {
        let decoder = JSONDecoder()
        Alamofire.request(SERVER_URL + SERVER_LIST_FILE).responseDecodableObject(decoder: decoder) { (response: DataResponse<ItemImage>) in
            if let item = response.result.value {
                self.mItemImage = item
//                print(self.mItemImage)
                self.requestStickerList()
            }
        }
    }
    
    func requestStickerList() {
        let decoder = JSONDecoder()
        Alamofire.request(SERVER_URL + SERVER_STICKER_LIST_FILE).responseDecodableObject(keyPath: "itemStickerGroups", decoder: decoder) { (response: DataResponse<[ItemStickerGroupInfo]>) in
            if let item = response.result.value {
                self.mItemStickersInfo = item
//                print("\n\n")
//                print(self.mItemStickersInfo)
            }
        }
    }
}

struct ItemImage : Decodable {
    let adver:Int
    let noti:Int
    let imgList:[ItemImageInfo]
    
    // 2017.09.28: 특정 key(문자열) mapping 필요시에 아래와 같이 선언
    // 선언할때에는 전체를 정의해야 하는듯...
    private enum CodingKeys: String, CodingKey {
        case adver
        case noti
        case imgList
        // 2017.09.28: 아래와 같은 식으로 mapping 한다
//        case randomDateCommit = "random_date_commit"
    }
    
}

struct ItemImageInfo : Decodable {
    let id:Int
    let thumbnailUrl:String
    let backgroundUrl:String
    let menuNumber:Int
    let categoryNumber:Int
    let regDate:String
    let license:String?
}

struct ItemStickerGroupInfo : Decodable {
    let groupId:Int
    let isNew:Int
    let itemStickers:[ItemStickerInfo]
    let licence:String?
}

struct ItemStickerInfo : Decodable {
    let filePath:String
    let thumbnail:String
}


