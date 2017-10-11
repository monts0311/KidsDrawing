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
            imageView.image = nil;
            imageView.af_setImage(withURL: URL(string:mItem[indexPath.row].thumbnailUrl)!)
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
        if let images = mItemImage {
            for image in images.imgList {
                if (image.menuNumber == 0) {
                    var item = ItemBackgroudImage()
                    item.bServerUrl = true
                    item.thumbnailUrl = SERVER_URL + "/Img/" + image.thumbnailUrl
                    item.backgroundUrl = SERVER_URL + "/Img/" + image.backgroundUrl
                    mItem.append(item)
                }
            }
        }
        
        print("ImageCount : \(mItem.count)")
    }
}
