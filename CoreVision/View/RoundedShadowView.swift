//
//  RoundedShadowView.swift
//  CoreVision
//
//  Created by Avijeet Sachdev on 7/30/17.
//  Copyright © 2017 Avijeet Sachdev. All rights reserved.
//

import UIKit

class RoundedShadowView: UIView {
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
        self.layer.cornerRadius = self.frame.height / 2
    }
}
