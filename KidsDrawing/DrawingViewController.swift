//
//  DrawingViewController.swift
//  KidsDrawing
//
//  Created by HONGYONG SOO on 2017. 10. 12..
//  Copyright © 2017년 com.monts. All rights reserved.
//

import UIKit

class DrawingViewController : UIViewController {
    @IBOutlet weak var mIvBg: UIImageView!
    @IBOutlet weak var mIvDoubleBuffer: UIImageView!
    @IBOutlet weak var mIvDraw: UIImageView!
    override func viewDidLoad() {
        mIvBg.image = UIImage(named:"background_frame")?.resizableImage(withCapInsets: UIEdgeInsets(top: 78, left: 92, bottom: 8, right: 70))
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.mIvDoubleBuffer)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(mIvDoubleBuffer.frame.size)
        let context = UIGraphicsGetCurrentContext()
        mIvDoubleBuffer.image?.draw(in: CGRect(x: 0, y: 0, width: mIvDoubleBuffer.frame.size.width, height: mIvDoubleBuffer.frame.size.height))
        
        // 2
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        // 3
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        // 4
        context?.strokePath()
        
        // 5
        mIvDoubleBuffer.image = UIGraphicsGetImageFromCurrentImageContext()
        mIvDoubleBuffer.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.mIvDoubleBuffer)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        UIGraphicsBeginImageContext(mIvDoubleBuffer.frame.size)
        mIvDraw.image?.draw(in: CGRect(x: 0, y: 0, width: mIvDraw.frame.size.width, height: mIvDraw.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        mIvDoubleBuffer.image?.draw(in: CGRect(x: 0, y: 0, width: mIvDoubleBuffer.frame.size.width, height: mIvDoubleBuffer.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mIvDraw.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        mIvDoubleBuffer.image = nil
    }
}
