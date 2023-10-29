//
//  ProfileCustomUIView.swift
//  TwitterClone
//
//  Created by Саша Восколович on 10.10.2023.
//

import UIKit

class ProfileCustomUIView: UIView {

    private var color = UIColor.red
    private let borderWidth: CGFloat = 5.0
    private let borderColor =  UIColor.white
     
    
    override func draw(_ rect: CGRect) {
        drawCircle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureState()
    }
    
    private func configureState() {
           backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
           isOpaque = false
           contentMode = .redraw
           layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
       }
    
    private func drawCircle() {
        color.setFill()
        color.setStroke()
        pathForCircle(in: bounds)
    }
    
    private func pathForCircle(in rect: CGRect) {
        let path = UIBezierPath()
               
        let radius = min(rect.size.width, rect.size.height) / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)
               
        path.addArc(withCenter: center,
                                radius: radius,
                                startAngle: 0.0,
                                endAngle: CGFloat.pi * 2,
                                clockwise: true)
        path.fill()
    }
}

extension CGRect {
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}
extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
