//
//  DrawingMenuViewController.swift
//  KidsDrawing
//
//  Created by HONGYONG SOO on 2017. 10. 10..
//  Copyright © 2017년 com.monts. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DrawingMenuViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - var
    var mItem:[ItemBackgroudImage] = []
    
    // MARK: - IBOutlet
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        makeItemList()
    }

    // MARK: - IBAction
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSelectedAction(_ sender: Any) {
        if let view = sender as? UIView {
            if let cell = view.parentViewOfType(type: UICollectionViewCell.self) {
                let indexPath = mCollectionView.indexPath(for: cell)
                print(indexPath ?? <#default value#>)
            }
        }
    }
    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mItem.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image",
                                                      for: indexPath)
        // Configure the cell
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            imageView.layer.cornerRadius = 25
            imageView.clipsToBounds = true

            if mItem[indexPath.row].bServerUrl == true {
                imageView.image = nil;
                imageView.af_setImage(withURL: URL(string:mItem[indexPath.row].thumbnailUrl)!)
                
            } else {
                imageView.image = UIImage(named: mItem[indexPath.row].thumbnailUrl)
                
            }

        }
        
        if let imageView = cell.viewWithTag(2) as? UIImageView {
            if mItem[indexPath.row].bNew == true {
                imageView.isHidden = false
                
            } else {
                imageView.isHidden = true
                
            }
        }
        return cell
    }
    
    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = 150
        let cellHeight = 126
        
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20,20,20,20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    // MARK: - private
    func makeItemList() {
        // functional data
        var gallery = ItemBackgroudImage()
        gallery.thumbnailUrl = NSLocalizedString("GALLERY", comment: "")
        gallery.listFunction = FUNCTION_GALLERY
        mItem.append(gallery)
        
        var picture = ItemBackgroudImage()
        picture.thumbnailUrl = NSLocalizedString("PICTURE", comment: "")
        picture.listFunction = FUNCTION_CAMERA
        mItem.append(picture)

        var white = ItemBackgroudImage()
        white.thumbnailUrl = NSLocalizedString("WHITE_SKETCHBOOK", comment: "")
        white.listFunction = FUNCTION_WHITE_BACKGROUND
        mItem.append(white)

        var black = ItemBackgroudImage()
        black.thumbnailUrl = NSLocalizedString("BLACK_SKETCHBOOK", comment: "")
        black.listFunction = FUNCTION_BLACK_BACKGROUND
        mItem.append(black)

        // server Data
        if let images = mItemImage {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            
            // timeIntervalSince1970 : 초 기준...
            let twoWeeksAgo = Date().timeIntervalSince1970 - 14 * 24 * 60 * 60
            for image in images.imgList {
                if (image.menuNumber == 0) {
                    var item = ItemBackgroudImage()
                    item.bServerUrl = true
                    item.thumbnailUrl = SERVER_URL + "Img/" + image.thumbnailUrl
                    item.backgroundUrl = SERVER_URL + "Img/" + image.backgroundUrl
                    
                    if let date = format.date(from: image.regDate) {
                        if (date.timeIntervalSince1970 > twoWeeksAgo) {
                            print("new")
                            item.bNew = true
                        }
                    }
 
                    mItem.append(item)
                }
            }
        }

        // local Data
        let drawing_thumbnail:[String] = [
            "day_mountain_270x220",
            "night_mountain_270x220",
            "day_field_270x220",
            "night_field_270x220_2",
            "day_sea_270x220",
            "night_sea_270x220",
            "inside_sea_270x220_2",
            "day_village_270x220",
            "night_village_270x220",
            "space_270x220",
            "castle_270x220_2"
        ]
        
        let drawing_background:[String] = [
            "day_mountain",
            "night_mountain",
            "day_field",
            "night_field",
            "day_sea",
            "night_sea",
            "inside_sea",
            "day_village",
            "night_village",
            "space",
            "castle"
        ]
        
        for i in 0..<drawing_thumbnail.count {
            var item = ItemBackgroudImage()
            item.thumbnailUrl = drawing_thumbnail[i]
            item.backgroundUrl = drawing_background[i]
            mItem.append(item)
        }

        print("ImageCount : \(mItem.count)")
    }
}

extension UIView {
    func parentViewOfType<T>(type: T.Type) -> T? {
        var currentView = self
        while currentView.superview != nil {
            if currentView is T {
                return currentView as? T
            }
            currentView = currentView.superview!
        }
        return nil
    }
}
