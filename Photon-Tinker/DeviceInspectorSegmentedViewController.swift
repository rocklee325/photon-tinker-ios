//
//  DeviceInspectorSegmentedViewController.swift
//  Particle
//
//  Created by Ido Kleinman on 8/8/16.
//  Copyright © 2016 spark. All rights reserved.
//

import UIKit
//import MXSegmentedPager


class DeviceInspectorSegmentedViewController: MXSegmentedPagerController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.segmentedPager.backgroundColor = ParticleUtils.particleAlmostWhiteColor
        // Parallax Header
        self.segmentedPager.parallaxHeader.view = DeviceInspectorTopView.instanceFromNib()
        self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderMode.Fill;
        self.segmentedPager.parallaxHeader.height = 88;
        self.segmentedPager.parallaxHeader.minimumHeight = 20;
        
        // Segmented Control customization
        self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        self.segmentedPager.segmentedControl.backgroundColor = ParticleUtils.particleAlmostWhiteColor
        self.segmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor(), NSFontAttributeName: ParticleUtils.particleRegularFont];
        self.segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : ParticleUtils.particleCyanColor]
        self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        self.segmentedPager.segmentedControl.selectionIndicatorColor = ParticleUtils.particleCyanColor
        
    }
 
    var device : SparkDevice?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var deviceNameLabel : UILabel!
    
   
    @IBOutlet weak var topBarView: UIView!
    
    override func segmentedPager(segmentedPager: MXSegmentedPager, titleForSectionAtIndex index: Int) -> String {
        return ["Info", "Data", "Events"][index];
    }
    

    override func numberOfPagesInSegmentedPager(segmentedPager: MXSegmentedPager) -> Int {
        return 3;
    }
    
    override func segmentedPager(segmentedPager: MXSegmentedPager, segueIdentifierForPageAtIndex index: Int) -> String {
        return self.segmentedPager(segmentedPager, titleForSectionAtIndex: index).lowercaseString
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? DeviceInspectorChildViewController {
            vc.device = self.device
            
        }
        
    }
    

}
