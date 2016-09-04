//
//  GraphicView.swift
//  Calculator
//
//  Created by Артем on 02/09/16.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit

class GraphicView: UIView {
    
    var axes = AxesDrawer()
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay()} }
    var origin: CGPoint? { didSet { setNeedsDisplay() } }
    var calcOrigin: CGPoint {
        get {
            return origin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        }
        set {
            origin = newValue
        }
    }
    
    override func drawRect(rect: CGRect) {
        axes.contentScaleFactor = contentScaleFactor
        axes.drawAxesInRect(bounds, origin: calcOrigin, pointsPerUnit: scale)
    }
 
    // MARK: - Guester Handlers
    func scale(guester: UIPinchGestureRecognizer) {
        if guester.state == .Changed {
            scale *= guester.scale
            guester.scale = 1.0
        }
    }
    
    func shiftOrigin(guester: UIPanGestureRecognizer) {
        switch guester.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = guester.translationInView(self)
            calcOrigin.x += translation.x
            calcOrigin.y += translation.y
            guester.setTranslation(CGPointZero, inView: self)
        default: break
            
        }
    }
    
    func changeOrigin(guester: UITapGestureRecognizer) {
        if guester.state == .Ended {
            calcOrigin = guester.locationInView(self)
        }
    }
}

