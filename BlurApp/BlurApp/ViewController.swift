//
//  ViewController.swift
//  BlurApp
//
//  Created by Владимир Моторкин on 01.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let imageSet = ["HSE1.jpg", "HSE2.jpg", "HSE3.jpg", "HSE4.jpeg"]
    var blurEffectView: UIVisualEffectView?
    @IBOutlet var backgroundImageView:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Randomly pick an image
        let selectedImageIndex = Int(arc4random_uniform(4))
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: imageSet[selectedImageIndex])
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView!)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        blurEffectView?.frame = view.bounds
    }
    
}

