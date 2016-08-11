//
//  DeviceInspectorSegmentedViewController.swift
//  Particle
//
//  Created by Ido Kleinman on 8/8/16.
//  Copyright © 2016 spark. All rights reserved.
//

import UIKit
//import MXSegmentedPager


class DeviceInspectorSegmentedViewController: MXSegmentedPagerController, SparkDeviceDelegate, DeviceInspectorTopViewDelegate, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topBarView = DeviceInspectorTopView.instanceFromNib() as? DeviceInspectorTopView
        self.topBarView!.deviceNameLabel.text = self.device?.name
        ParticleUtils.animateOnlineIndicatorImageView(self.topBarView!.deviceIndicatorImageView, online: self.device!.connected, flashing: self.device!.isFlashing)
        self.topBarView!.delegate = self
        self.device!.delegate = self
        
        self.segmentedPager.backgroundColor = UIColor.whiteColor()
        // Parallax Header
        self.segmentedPager.parallaxHeader.view = self.topBarView
        self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderMode.Fill;
        self.segmentedPager.parallaxHeader.height = 96;
        self.segmentedPager.parallaxHeader.minimumHeight = 20;
        self.segmentedPager.delegate = self
        
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
    
    override func heightForSegmentedControlInSegmentedPager(segmentedPager: MXSegmentedPager) -> CGFloat {
        return 32.0
    }
    
    override func segmentedPager(segmentedPager: MXSegmentedPager, didSelectViewWithIndex index: Int) {
        
        let vc = self.segmentedPager(segmentedPager, viewControllerForPageAtIndex: index) as! DeviceInspectorChildViewController
//        print ("didSelectViewWithIndex "+String(index)+" "+vc.description) // debug
        vc.showTutorial()
        
//        vc.viewDidAppear(true)
    }
    
    var topBarView: DeviceInspectorTopView?
    
//    override func segmentedPager(segmentedPager: MXSegmentedPager, viewControllerForPageAtIndex index: Int) -> UIViewController {
//        let vcName = self.segmentedPager(segmentedPager, titleForSectionAtIndex: index)
//        let vcStoryboardIdentifier = "deviceInspector"+vcName
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(vcStoryboardIdentifier) as! DeviceInspectorChildViewController
//        print("going to VC: "+vc.description)
//        vc.device = self.device
////        vc.viewWillAppear(true)
//        return vc
//    }
    
    
    
    override func segmentedPager(segmentedPager: MXSegmentedPager, titleForSectionAtIndex index: Int) -> String {
        return ["Info", "Events", "Data"][index];
        
        // The reason for this particular order is that for "Events" to be in the middle - MXSegmentedPager will trigger a viewDidLoad whenever a non-neiboring view is selected - since "Events" is in the middle of 3 views selections - this will never happen and the Events VC will always stay alive, and thus, aggregated events as they get published. The "Data" and "Info" VCs will be reinitialized whenever user tap those without going through the middle "Events" one
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
//            print("pager segue : "+segue.description)
            
        }
        
    }
    
    // MARK: DeviceInspectorTopViewDelegate functions
    
    func backButtonTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func moreActionsButtonTapped() {
        
        // heading
        view.endEditing(true)
        let dialog = ZAlertView(title: "More Actions", message: nil, alertType: .MultipleChoice)
        
        
        
        dialog.addButton("Reflash Tinker", font: ParticleUtils.particleBoldFont, color: ParticleUtils.particleCyanColor, titleColor: ParticleUtils.particleAlmostWhiteColor) { (dialog : ZAlertView) in
            
            dialog.dismiss()
            self.reflashTinker()
            
        }
        
        
        dialog.addButton("Rename device", font: ParticleUtils.particleBoldFont, color: ParticleUtils.particleCyanColor, titleColor: ParticleUtils.particleAlmostWhiteColor) { (dialog : ZAlertView) in
            
            dialog.dismiss()
            self.renameDialog = ZAlertView(title: "Rename device", message: nil, isOkButtonLeft: true, okButtonText: "Rename", cancelButtonText: "Cancel",
                                           okButtonHandler: { [unowned self] alertView in
                                            
                                            let tf = alertView.getTextFieldWithIdentifier("name")
                                            self.renameDevice(tf!.text)
                                            alertView.dismiss()
                },
                                           cancelButtonHandler: { alertView in
                                            alertView.dismiss()
                }
            )
            self.renameDialog!.addTextField("name", placeHolder: self.device!.name!)
            let tf = self.renameDialog!.getTextFieldWithIdentifier("name")
            tf?.text = self.device?.name
            tf?.delegate = self
            tf?.tag = 100
            
            self.renameDialog!.show()
            tf?.becomeFirstResponder()
        }
        
        
        
        dialog.addButton("Refresh data", font: ParticleUtils.particleBoldFont, color: ParticleUtils.particleCyanColor, titleColor: ParticleUtils.particleAlmostWhiteColor) { (dialog : ZAlertView) in
            dialog.dismiss()
            
            self.refreshData()
        }
        
        
        dialog.addButton("Signal for 10sec", font: ParticleUtils.particleBoldFont, color: ParticleUtils.particleCyanColor, titleColor: ParticleUtils.particleAlmostWhiteColor) { (dialog : ZAlertView) in
            dialog.dismiss()
            
            self.device?.signal(true, completion: nil)
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.device?.signal(false, completion: nil)
            }
            
            
        }
        
        dialog.addButton("Support/Documentation", font: ParticleUtils.particleBoldFont, color: ParticleUtils.particleEmeraldColor, titleColor: ParticleUtils.particleAlmostWhiteColor) { (dialog : ZAlertView) in
            
            dialog.dismiss()
            self.popDocumentationViewController()
        }
        
        
        dialog.addButton("Cancel", font: ParticleUtils.particleRegularFont, color: ParticleUtils.particleGrayColor, titleColor: UIColor.whiteColor()) { (dialog : ZAlertView) in
            dialog.dismiss()
        }
        
        
        dialog.show()
        
        
    }
    
    var renameDialog : ZAlertView?
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 100 {
            self.renameDevice(textField.text)
            renameDialog?.dismiss()
            
        }
        
        return true
    }
    
    
    func renameDevice(newName : String?) {
        self.device?.rename(newName!, completion: {[unowned self] (error : NSError?) in
            
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.topBarView!.deviceNameLabel.text = newName!.stringByReplacingOccurrencesOfString(" ", withString: "_")
                    self.topBarView!.deviceNameLabel.setNeedsLayout()
                }
                
            }
            })
    }
    
    
    
    func popDocumentationViewController() {
        self.performSegueWithIdentifier("help", sender: self)
    }
    
    
    func refreshData() {
        self.device?.refresh({[unowned self] (err: NSError?) in
            
            
            // test what happens when device goes offline and refresh is triggered
            if (err == nil) {
                // do stuff on visible VC
                
                
            }
            })
    }
    
    var flashedTinker : Bool = false
    
    
    // 2
    func reflashTinker() {
        
        //        if !self.device!.connected {
        //            TSMessage.showNotificationWithTitle("Device offline", subtitle: "Device must be online to be flashed", type: .Error)
        //            return
        //        }
        
        func flashTinkerBinary(binaryFilename : String?)
        {
            let bundle = NSBundle.mainBundle()
            let path = bundle.pathForResource(binaryFilename, ofType: "bin")
            let binary = NSData(contentsOfURL: NSURL(fileURLWithPath: path!))
            let filesDict = ["tinker.bin" : binary!]
            self.flashedTinker = true
            self.device!.flashFiles(filesDict, completion: { [unowned self] (error:NSError?) -> Void in
                if let e=error
                {
                    self.flashedTinker = false
                    TSMessage.showNotificationWithTitle("Flashing error", subtitle: "Error flashing device. Are you sure it's online? \(e.localizedDescription)", type: .Error)
                    
                }
                })
        }
        
        
        switch (self.device!.type)
        {
        case .Core:
            //                                        Mixpanel.sharedInstance().track("Tinker: Reflash Tinker",
            Mixpanel.sharedInstance().track("Tinker: Reflash Tinker", properties: ["device":"Core"])
            self.flashedTinker = true
            self.device!.flashKnownApp("tinker", completion: { (error:NSError?) -> Void in
                if let e=error
                {
                    TSMessage.showNotificationWithTitle("Flashing error", subtitle: "Error flashing device: \(e.localizedDescription)", type: .Error)
                }
            })
            
        case .Photon:
            Mixpanel.sharedInstance().track("Tinker: Reflash Tinker", properties: ["device":"Photon"])
            flashTinkerBinary("photon-tinker")
            
        case .Electron:
            Mixpanel.sharedInstance().track("Tinker: Reflash Tinker", properties: ["device":"Electron"])
            
            let dialog = ZAlertView(title: "Flashing Electron", message: "Flashing Tinker to Electron via cellular will consume data from your data plan, are you sure you want to continue?", isOkButtonLeft: true, okButtonText: "No", cancelButtonText: "Yes",
                                    okButtonHandler: { alertView in
                                        alertView.dismiss()
                                        
                },
                                    cancelButtonHandler: { alertView in
                                        alertView.dismiss()
                                        flashTinkerBinary("electron-tinker")
                                        
                }
            )
            
            
            
            dialog.show()
            
        default:
            TSMessage.showNotificationWithTitle("Reflash Tinker", subtitle: "Cannot flash Tinker to a non-Particle device", type: .Warning)
            
            
        }
        
    }
    
    
    
    
    func showTutorial() {
        
        if ParticleUtils.shouldDisplayTutorialForViewController(self) {
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                
                if self.navigationController?.visibleViewController == self {
                    // viewController is visible
                    
                    // 3
                    //                    var tutorial = YCTutorialBox(headline: "Additional actions", withHelpText: "Tap the three dots button for more actions such as reflashing the Tinker firmware, force refreshing the device info/data, signal the device (LED shouting rainbows), changing device name and easily accessing Particle documentation and support portal.")
                    //                    tutorial.showAndFocusView(self.moreActionsButton)
                    //
                    //                    // 2
                    //                    tutorial = YCTutorialBox(headline: "Modes", withHelpText: "Device inspector has 3 modes - tap 'Info' to see your device network parameters, tap 'data' to interact with your device exposed functions and variables, tap 'events' to view a searchable list of the device published events.")
                    //
                    //                    tutorial.showAndFocusView(self.modeSegmentedControl)
                    
                    
                    // 1
                    let tutorial = YCTutorialBox(headline: "Welcome to Device Inspector", withHelpText: "Here you can see advanced information on your device and interact with it further than Tinker. Tap the blue clipboard icon to copy the corresponding field to the clipboard.", withCompletionBlock: {
                        // 2
                        let tutorial = YCTutorialBox(headline: "Modes", withHelpText: "Device inspector has 3 modes - tap 'Info' to see your device network parameters, tap 'data' to interact with your device exposed functions and variables, tap 'events' to view a searchable list of the device published events.", withCompletionBlock:  {
                            let tutorial = YCTutorialBox(headline: "Additional actions", withHelpText: "Tap the three dots button for more actions such as reflashing the Tinker firmware, force refreshing the device info/data, signal the device (LED shouting rainbows), changing device name and easily accessing Particle documentation and support portal.")
                            
                            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
                            dispatch_after(delayTime, dispatch_get_main_queue()) {
                                tutorial.showAndFocusView(self.topBarView!.moreActionsButton)
                            }
                            
                            
                        })
                        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
                        dispatch_after(delayTime, dispatch_get_main_queue()) {
                            
                            tutorial.showAndFocusView(self.segmentedPager)
                        }
                        
                    })
                    
                    tutorial.showAndFocusView(self.view)
                    
                    ParticleUtils.setTutorialWasDisplayedForViewController(self)
                }
                
            }
        }
    }
    
    
    func sparkDevice(device: SparkDevice, didReceiveSystemEvent event: SparkDeviceSystemEvent) {
        ParticleUtils.animateOnlineIndicatorImageView(self.topBarView!.deviceIndicatorImageView, online: self.device!.connected, flashing: self.device!.isFlashing)
        if self.flashedTinker && event == .FlashSucceeded {
            
            dispatch_async(dispatch_get_main_queue()) {
                TSMessage.showNotificationWithTitle("Flashing successful", subtitle: "Your device has been flashed with Tinker firmware successfully", type: .Success)
            }
            self.flashedTinker = false
            //            self.refreshData()
            
        }
    }
    
    
}