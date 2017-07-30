//
//  ViewController.swift
//  CoreVision
//
//  Created by Avijeet Sachdev on 7/30/17.
//  Copyright © 2017 Avijeet Sachdev. All rights reserved.
//

import UIKit

class CameraVC: UIViewController {
    @IBOutlet weak var captureImageView: RoundedShadowImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var identificationLabel: UILabel!
    @IBOutlet var roundedLabelView: RoundedShadowView!
    @IBOutlet weak var flashBtn: RoundedShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

