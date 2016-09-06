//
//  GraphicView.swift
//  Calculator
//
//  Created by Артем on 02/09/16.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit

@IBDesignable
class GraphicView: UIView {
    
    var yFuncX: ((x: Double) -> Double)? { didSet { setNeedsDisplay() } }
    
    private var axes = AxesDrawer()
    @IBInspectable
    var scale: CGFloat = 1.0 { didSet { setNeedsDisplay()} }
    private var origin: CGPoint? { didSet { setNeedsDisplay() } }
    private var calcOrigin: CGPoint {
        get {
            return origin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        }
        set {
            origin = newValue
        }
    }
    
    private struct OldPoint {
        var point: CGPoint
        var isNormalPoint: Bool
    }
    
    private func drawGraphicInRect() -> UIBezierPath {
        let path = UIBezierPath()
        var point = CGPoint()
        var x: Double { return Double((point.x - calcOrigin.x) / scale) }
        var oldPoint = OldPoint(point: CGPointZero, isNormalPoint: true)
        
        for i in 0...Int(bounds.size.width * contentScaleFactor) {
            point.x = CGFloat(i) / contentScaleFactor
            guard let y = (self.yFuncX)?(x: x) where y.isFinite else { continue }
            point.y = calcOrigin.y - CGFloat(y) * scale
            if i == 0 {
                path.moveToPoint(point)
            } else {
                if CGRectContainsPoint(bounds, point) {
                    if oldPoint.isNormalPoint {
                    path.addLineToPoint(point)
                    } else {
                        path.moveToPoint(point)
                    }
                    oldPoint.point = point
                    oldPoint.isNormalPoint = true
                } else {
                    oldPoint.point = point
                    oldPoint.isNormalPoint = false
                }
            }
        }
        
        return path
    }
    
    override func drawRect(rect: CGRect) {
        axes.contentScaleFactor = contentScaleFactor
        axes.drawAxesInRect(bounds, origin: calcOrigin, pointsPerUnit: scale)
        
        drawGraphicInRect().stroke()
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

