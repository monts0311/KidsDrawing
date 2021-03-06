//
//  DrawingViewController.swift
//  KidsDrawing
//
//  Created by HONGYONG SOO on 2017. 10. 12..
//  Copyright © 2017년 com.monts. All rights reserved.
//

import UIKit

class DrawingViewController : UIViewController {
    @IBOutlet weak var mIvSave: UIImageView!
    @IBOutlet weak var mIvBg: UIImageView!
    @IBOutlet weak var mIvDoubleBuffer: UIImageView!
    @IBOutlet weak var mIvDraw: UIImageView!
    @IBOutlet weak var mSliderThickness: DesignableSlider!
    
    override func viewDidLoad() {
        mIvBg.image = UIImage(named:"background_frame")?.resizableImage(withCapInsets: UIEdgeInsets(top: 78, left: 92, bottom: 8, right: 70))
        
        mIvSave.image = UIImage(named:NSLocalizedString("SAVE", comment: ""))
        
        mSliderThickness.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        mSliderThickness.frame = CGRect(x: 0, y: mIvBg.frame.origin.y + 46, width: 46, height: mIvBg.frame.height - 95 - 46)
        mSliderThickness.addBackgroundView()

    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onEraseMode(_ sender: Any) {
        mEraseMode = !mEraseMode
    }
    
    var mLastPoint = CGPoint.zero
    var mRed: CGFloat = 0.0
    var mGreen: CGFloat = 0.0
    var mBlue: CGFloat = 0.0
    var mBrushWidth: CGFloat = 10.0
    var mOpacity: CGFloat = 1.0
    var mSwiped = false
    var mEraseMode = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mSwiped = false
        if let touch = touches.first {
            mLastPoint = touch.location(in: self.mIvDoubleBuffer)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(mIvDoubleBuffer.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        if mEraseMode == false {
            mIvDoubleBuffer.image?.draw(in: CGRect(x: 0, y: 0, width: mIvDoubleBuffer.frame.size.width, height: mIvDoubleBuffer.frame.size.height))
        } else {
            mIvDraw.image?.draw(in: CGRect(x: 0, y: 0, width: mIvDraw.frame.size.width, height: mIvDraw.frame.size.height))
        }
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(mBrushWidth)
        context?.setStrokeColor(red: mRed, green: mGreen, blue: mBlue, alpha: 1.0)
        context?.setBlendMode(mEraseMode == false ? CGBlendMode.normal : CGBlendMode.clear)
        
        context?.strokePath()
        
        if mEraseMode == false {
            mIvDoubleBuffer.image = UIGraphicsGetImageFromCurrentImageContext()
            mIvDoubleBuffer.alpha = mOpacity
        } else {
            mIvDraw.image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        mSwiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.mIvDoubleBuffer)
            drawLineFrom(fromPoint: mLastPoint, toPoint: currentPoint)
            mLastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !mSwiped {
            // draw a single point
            drawLineFrom(fromPoint: mLastPoint, toPoint: mLastPoint)
        }
        
        if mEraseMode == false {
            UIGraphicsBeginImageContext(mIvDoubleBuffer.frame.size)
            mIvDraw.image?.draw(in: CGRect(x: 0, y: 0, width: mIvDraw.frame.size.width, height: mIvDraw.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
            mIvDoubleBuffer.image?.draw(in: CGRect(x: 0, y: 0, width: mIvDoubleBuffer.frame.size.width, height: mIvDoubleBuffer.frame.size.height), blendMode: CGBlendMode.normal, alpha: mOpacity)
            mIvDraw.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            mIvDoubleBuffer.image = nil
        }
    }
}
