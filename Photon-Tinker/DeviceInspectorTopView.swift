//
//  DeviceInspectorTopView.swift
//  Particle
//
//  Created by Ido Kleinman on 8/8/16.
//  Copyright © 2016 spark. All rights reserved.
//

import UIKit

@IBDesignable
class DeviceInspectorTopView: UIView {
    
    class func instanceFromNib(owner: UIViewController?) -> UIView {
        return UINib(nibName: "DeviceInspectorTopView", bundle: nil).instantiateWithOwner(owner, options: nil)[0] as! UIView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    override func prepareForInterfaceBuilder() {
        DeviceInspectorTopView.instanceFromNib(nil)
    }
    
}
