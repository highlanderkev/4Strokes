//
//  LinearInterpView.swift
//  4Strokes
//
//  Created by Kevin Westropp on 3/18/15.
//  Copyright (c) 2015 KPW. All rights reserved.
//

import UIKit

// Naive Approach to Drawing, never caches swipes.
class LinearInterpView : UIView {
    
    let path = UIBezierPath()

    // Required to init and set the path linewidth
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        path.lineWidth = 2.0;

    }
    
    override func drawRect(rect: CGRect) {
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
        self.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        self.touchesEnded(touches, withEvent: event)
    }
    
}

