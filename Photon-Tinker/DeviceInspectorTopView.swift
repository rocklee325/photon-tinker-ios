//
//  DeviceInspectorTopView.swift
//  Particle
//
//  Created by Ido Kleinman on 8/8/16.
//  Copyright © 2016 spark. All rights reserved.
//

import UIKit

class DeviceInspectorTopView: UIView {
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "DeviceInspectorTopView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
