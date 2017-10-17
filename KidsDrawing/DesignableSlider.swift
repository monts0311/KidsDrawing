//
//  DesignableSlider.swift
//  KidsDrawing
//
//  Created by HONGYONG SOO on 2017. 10. 13..
//  Copyright © 2017년 com.monts. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableSlider: UISlider {
    @IBInspectable var mImageThumb: UIImage? {
        didSet {
            setThumbImage(mImageThumb, for: .normal)
        }
    }
    
    @IBInspectable var mImageBg: UIImage? {
        didSet {
            let clearImage = UIImage()
            setMinimumTrackImage(clearImage, for: .normal)
            setMaximumTrackImage(clearImage, for: .normal)
        }
    }
    
    func addBackgroundView() {
        print("mImageBg \(mImageBg)")
        if let bgImage = mImageBg {
            let bgIv = UIImageView()
            bgIv.image = bgImage
            bgIv.frame = self.frame
            
            bgIv.contentMode = .scaleAspectFill
            print("size : + \(bgIv.frame)")
            
            self.addSubview(bgIv)
            print("subviews : + \(self.subviews)")

        }
    }
}
