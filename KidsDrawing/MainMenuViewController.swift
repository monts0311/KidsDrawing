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

// MARK: - Global
var mItemImage:ItemImage?
var mItemStickersInfo:[ItemStickerGroupInfo]?

// MARK: - Const
let SERVER_URL: String = "http://kidsking.co/hong/"
let SERVER_LIST_FILE: String = "list_test.json"
let SERVER_STICKER_LIST_FILE: String = "list_sticker.json"

class MainMenuViewController: UIViewController {
    
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

extension Alamofire.SessionManager {
    @discardableResult
    open func requestWithoutCache(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            print(error)
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
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

        // 2017.10.12 : Alamofire Cache 문제 처리
        var urlRequest = URLRequest(url: URL(string:SERVER_URL + SERVER_LIST_FILE)!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("<Auth KEY>", forHTTPHeaderField:"Authorization" )
        urlRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        Alamofire.request(urlRequest).validate().responseDecodableObject(decoder: decoder) { (response: DataResponse<ItemImage>) in
            if let item = response.result.value {
                mItemImage = item
//                print(mItemImage)
                self.requestStickerList()
            }
        }
    }
    
    func requestStickerList() {
        let decoder = JSONDecoder()
        
        // 2017.10.12 : Alamofire Cache 문제 처리
        var urlRequest = URLRequest(url: URL(string:SERVER_URL + SERVER_STICKER_LIST_FILE)!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("<Auth KEY>", forHTTPHeaderField:"Authorization" )
        urlRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData

        Alamofire.request(SERVER_URL + SERVER_STICKER_LIST_FILE).validate().responseDecodableObject(keyPath: "itemStickerGroups", decoder: decoder) { (response: DataResponse<[ItemStickerGroupInfo]>) in
            if let item = response.result.value {
                mItemStickersInfo = item
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



