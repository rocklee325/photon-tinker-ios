//
//  DeviceInspectorTopView.swift
//  Particle
//
//  Created by Ido Kleinman on 8/8/16.
//  Copyright © 2016 spark. All rights reserved.
//

import UIKit


protocol DeviceInspectorTopViewDelegate {
    
    func backButtonTapped()
    func moreActionsButtonTapped()
    
}

class DeviceInspectorTopView: UIView {
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "DeviceInspectorTopView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceIndicatorImageView: UIImageView!
    
    @IBOutlet weak var moreActionsButton: UIButton!
    @IBAction func moreActionsButtonTapped(sender: UIButton) {
        if let d = self.delegate {
            d.moreActionsButtonTapped()
        }
    }

    @IBAction func backButtonTapped(sender: UIButton) {
        if let d = self.delegate {
            d.backButtonTapped()
        }
    }
    
    var delegate : DeviceInspectorTopViewDelegate?
    
}
