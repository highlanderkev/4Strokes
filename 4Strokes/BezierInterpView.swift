//
//  BezierInterpView.swift
//  4Strokes
//
//  Created by Kevin Westropp on 4/6/15.
//  Copyright (c) 2015 KPW. All rights reserved.
//

import UIKit

class BezierInterpView : UIView {

    let path = UIBezierPath()
    var incrementalImage: UIImage? = UIImage()
    var pts: [CGPoint?] = Array(count: 4, repeatedValue: CGPoint())
    var ctr: Int = 0

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        path.lineWidth = 2.0
    }

    override func drawRect(rect: CGRect) {
        incrementalImage?.drawInRect(rect)
        path.stroke()
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        ctr = 0
        var touch: AnyObject? = touches.first
        pts[0] = touch?.locationInView(self)
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch: AnyObject? = touches.first
        var p = touch?.locationInView(self)
        ctr++
        pts[ctr] = p
        if(ctr == 3){
            path.moveToPoint(pts[0]!)
            // this is how a Bezier curve is appended to a path. We are adding a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
            path.addCurveToPoint(pts[3]!, controlPoint1: pts[1]!, controlPoint2: pts[2]!)
            self.setNeedsDisplay()
            pts[0] = path.currentPoint
            ctr = 0
        }
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        drawBitmap()
        self.setNeedsDisplay()
        pts[0] = path.currentPoint
        path.removeAllPoints()
        ctr = 0
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
