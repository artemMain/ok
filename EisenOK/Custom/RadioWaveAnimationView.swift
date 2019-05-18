//
//  RadioWaveAnimationView.swift
//  EisenOK
//
//  Created by Ярослав  on 03.07.2018.
//  Copyright © 2018 UkropSoft. All rights reserved.
//

import UIKit

class RadioWaveAnimationView: UIView {
    
    var animatableLayer : CAShapeLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.bounds.height/2
        
        self.animatableLayer = CAShapeLayer()
        self.animatableLayer?.fillColor = self.backgroundColor?.cgColor
        self.animatableLayer?.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.animatableLayer?.frame = self.bounds
        self.animatableLayer?.cornerRadius = self.bounds.height/2
        self.animatableLayer?.masksToBounds = true
        self.layer.addSublayer(self.animatableLayer!)
        self.startAnimation()
}

    func startAnimation()
    {
        let layerAnimation = CABasicAnimation(keyPath: "transform.scale")
        layerAnimation.fromValue = 0
        layerAnimation.toValue = 2
        layerAnimation.isAdditive = false
        
        let layerAnimation2 = CABasicAnimation(keyPath: "opacity")
        layerAnimation2.fromValue = 1
        layerAnimation2.toValue = 0
        layerAnimation2.isAdditive = false
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [layerAnimation,layerAnimation2]
        groupAnimation.duration = CFTimeInterval(2)
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.isRemovedOnCompletion = true
        groupAnimation.repeatCount = .infinity
        
        self.animatableLayer?.add(groupAnimation, forKey: "growingAnimation")
}
/*
 // Only override draw() if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func draw(_ rect: CGRect) {
 // Drawing code
 }
 */
}
