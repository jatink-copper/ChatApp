//
//  UIViewExtension.swift
//  liveApp
//
//  Created by Jatin on 16/11/16.
//  Copyright © 2016 coppermobile. All rights reserved.
//

import UIKit

extension UIView {
  func makeItCircle () {
    layer.cornerRadius = min(frame.width/2, frame.height/2)
    layer.masksToBounds = true
  }
    func makeCircleWithShadow () -> UIView {
        let superView =  UIView(frame: self.frame)
        superView.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0))
        superView.layer.shadowOpacity = 0.8
        superView.layer.shadowRadius = 5.0
        superView.layer.shadowColor = UIColor.red.cgColor
        layer.cornerRadius = min(frame.width/2, frame.height/2)
        layer.masksToBounds = true

        return superView
        
    }
  
  func addBorder (withColor : UIColor ,andBorderWidth: CGFloat) {
    layer.borderWidth = andBorderWidth
    layer.borderColor = withColor.cgColor
  }
  
  func enableRoudedCorner(fixedValue: Bool = false) {
    layer.cornerRadius = fixedValue ? 5.0 : min(frame.width, frame.height)/10.0
    layer.masksToBounds = true
  }
}
class UpperTriangularView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX ), y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX ), y: rect.maxY))
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.closePath()
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        context.fillPath()
    }
}
class UpperLeftTriangularView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX ), y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.minX ), y: rect.maxY))
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.closePath()
        context.setFillColor(red: 126.0/255.0, green: 178.0/255.0, blue: 12.0/255.0, alpha: 0.5)
        context.fillPath()
    }
}
