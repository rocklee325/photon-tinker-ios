//
//  ViewController.swift
//  Photon-Tikner
//
//  Created by Ido on 4/7/15.
//  Copyright (c) 2015 particle. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, ParticleSetupMainControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        
        let backgroundImage = UIImageView(image: UIImage(named: "imgTrianglifyBackgroundBlue"))
        backgroundImage.frame = UIScreen.main.bounds
        backgroundImage.contentMode = .scaleToFill;
//        backgroundImage.alpha = 0.85
        self.view.addSubview(backgroundImage)
        self.view.sendSubview(toBack: backgroundImage)
        let layer = self.getStartedButton.layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 3.0
        layer.borderWidth = 2.0
        let verStr = "V"+(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        self.versionLabel.text = verStr
        
        if let _ = ParticleCloud.sharedInstance().loggedInUsername
        {
            self.performSegue(withIdentifier: "start_no_animation", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func checkFontNames()
    {
        for family in UIFont.familyNames
        {
            print("\(family)\n", terminator: "")
            for name in UIFont.fontNames(forFamilyName: family )
            {
                print("   \(name)\n", terminator: "")
            }
            
        }
    }
    

    // Function will be called when setup finishes
    func particleSetupViewController(_ controller: ParticleSetupMainController!, didFinishWith result: ParticleSetupMainControllerResult, device: ParticleDevice!) {
        
        if result == .loggedIn
        {
            self.performSegue(withIdentifier: "start", sender: self)
            
            let email = ParticleCloud.sharedInstance().loggedInUsername
            SEGAnalytics.shared().identify(email!)
            
            
        }
        
        if result == .skippedAuth
        {
            self.performSegue(withIdentifier: "start", sender: self)
        }
    }
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func customizeSetupForLoginFlow()
    {
//        self.checkFontNames()
        // Do customization for Particle Setup wizard UI
        let c = ParticleSetupCustomization.sharedInstance()
        
        c?.allowSkipAuthentication = true
        c?.skipAuthenticationMessage = "Skipping authentication will run Particle app in limited functionality mode - you would only be able to setup Wi-Fi credentials to Photon based devices but not claim them to your account nor use Tinker or device inspector. Are you sure you want to continue?"
        c?.pageBackgroundImage = UIImage(named: "imgTrianglifyBackgroundBlue")
        c?.normalTextFontName = "Gotham-Book"
        c?.boldTextFontName = "Gotham-Medium"
        c?.headerTextFontName = "Gotham-Light" // new
        //c.fontSizeOffset = 1;
        c?.normalTextColor = UIColor.white
        c?.linkTextColor = UIColor.white

        // UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.25)

        c?.linkTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        c?.elementTextColor = UIColor(red: 0, green: 186.0/255.0, blue: 236.0/255.0, alpha: 1.0) //(patternImage: UIImage(named: "imgOrangeGradient")!)
        c?.elementBackgroundColor = UIColor.white
        c?.brandImage = UIImage(named: "particle-horizontal-head")
        c?.brandImageBackgroundColor = .clear
        c?.brandImageBackgroundImage = nil
//        c.deviceImage = UIImage(named: "imgPhoton")
        c?.tintSetupImages = true
        c?.allowPasswordManager = true
        c?.lightStatusAndNavBar = true
        
        #if ORG_TEST_MODE
            
            ParticleSetupCustomization.sharedInstance().organization = true
            ParticleSetupCustomization.sharedInstance().organizationSlug = "dinobots"
            ParticleSetupCustomization.sharedInstance().productSlug = "ido-test-product-1"
            
            // for creating customers (signup) to work you need:
            ParticleCloud.sharedInstance().OAuthClientId = orgTestClientId
            ParticleCloud.sharedInstance().OAuthClientSecret = orgTestSecret

            
            print("Tinker app in ORG_TEST_MODE")
            
        #endif

       
    }
    
      
    @IBOutlet weak var versionLabel: UILabel!
    @IBAction func startButtonTapped(_ sender: UIButton)
    {
        if let _ = ParticleCloud.sharedInstance().loggedInUsername
        {
//            self.customizeSetupForSetupFlow()
            self.performSegue(withIdentifier: "start", sender: self)
        }
        else
        {
            self.customizeSetupForLoginFlow()
            // lines required for invoking the Particle Setup wizard
            if let vc = ParticleSetupMainController(authenticationOnly: true)
            {
                
                
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
      
}

