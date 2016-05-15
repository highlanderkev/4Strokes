//
//  CachedLIView.swift
//  4Strokes
//
//  Created by Kevin Westropp on 4/4/15.
//  Copyright (c) 2015 KPW. All rights reserved.
//

import UIKit


class CachedLIView : UIView {

    let path = UIBezierPath()
    var incrementalImage: UIImage? = UIImage()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        path.lineWidth = 2.0
    }

    override func drawRect(rect: CGRect) {
        incrementalImage?.drawInRect(rect)
        path.stroke()
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch: AnyObject? = touches.first
        var p = touch?.locationInView(self)
        path.moveToPoint(p!)
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch: AnyObject? = touches.first
        var p = touch?.locationInView(self)
        path.addLineToPoint(p!)
        self.setNeedsDisplay()
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch: AnyObject? = touches.first
        var p = touch?.locationInView(self)
        path.addLineToPoint(p!)
        drawBitmap()
        self.setNeedsDisplay()
        path.removeAllPoints()
    }

    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        self.touchesEnded(touches, withEvent: event)
    }

    func drawBitmap(){
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        if(incrementalImage != nil){
            var rectpath:UIBezierPath = UIBezierPath(rect: self.bounds)
            rectpath.fill(UIColor.whiteColor().setFill())
        }
        incrementalImage?.drawAtPoint(CGPointZero)
        path.stroke()
        incrementalImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }


}