//
//  CPSimpleHUD.swift
//  CPSimpleHUD
//
//  Created by Carlos Pages on 28/08/2014.
//  Copyright (c) 2014 Carlos Pages. All rights reserved.
//

import Foundation
import UIKit

enum WaitingType{
    case WaitingTypeUnlimited
    case WaitingTypeImageSplash
}


private let _singletoneInstance = CPSimpleHUD(center: CGPointMake(
            UIScreen.mainScreen().bounds.size.width/2,
            UIScreen.mainScreen().bounds.size.height/2)
                                            )
private let DARK_VIEW_HEIGHT:CGFloat = 150
private let DARK_VIEW_WIDTH:CGFloat = 150

private let ACTIVITY_INDICATOR_VIEW_HEIGHT:CGFloat = 65
private let ACTIVITY_INDICATOR_VIEW_WIDTH:CGFloat = 65

private let NUMBER_OF_LINES_LOADING_LINES = 2

class CPSimpleHUD : UIView{
    /*
        Dark view in the background over the window and under the activity indicator
    */
    let darkView:UIView
    private let activityIndicatorView:UIActivityIndicatorView
    /*
        Label shown when the activity indicator is running, if it's nil or the text it's empty nothing will show and the activity indicator will be placed in the middle of the dark view
    */
    let loadingLabel:UILabel
    
    private let DARK_VIEW_CODER_KEY = "DARK_VIEW_CODER_KEY"
    private let ACTIVITY_INDICATOR_VIEW_CODER_KEY = "ACTIVITY_INDICATOR_VIEW_CODER_KEY"
    private let LOADING_LABEL_CODER_KEY = "LOADING_LABEL_CODER_KEY"
    
//MARK: - Init Methods
    required init(coder aDecoder: NSCoder) {
        self.darkView = aDecoder.decodeObjectForKey(DARK_VIEW_CODER_KEY) as UIView
        self.activityIndicatorView = aDecoder.decodeObjectForKey(ACTIVITY_INDICATOR_VIEW_CODER_KEY) as UIActivityIndicatorView
        self.loadingLabel = aDecoder.decodeObjectForKey(LOADING_LABEL_CODER_KEY) as UILabel
        
        super.init(coder: aDecoder)
        
    }
    
    init(center: CGPoint){
        
        //Customization
        self.darkView = UIView(frame: CGRect(origin: CGPointZero,
            size: CGSizeMake(DARK_VIEW_WIDTH,
                DARK_VIEW_HEIGHT))
        )
        
        self.darkView.center = center
        self.darkView.layer.cornerRadius = 10.0
        self.darkView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        // create new dialog box view and component
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        self.activityIndicatorView.bounds = CGRect(origin: CGPointZero,
            size: CGSizeMake(ACTIVITY_INDICATOR_VIEW_WIDTH,
                ACTIVITY_INDICATOR_VIEW_HEIGHT)
        )
        
        //We place the activity view in the center of the dark view
        self.activityIndicatorView.center = CGPointMake(self.darkView.frame.size.width / 2.0,
            self.darkView.frame.size.height / 2.0)
        
        self.activityIndicatorView.hidesWhenStopped = true
        
        //We set up the label
        self.loadingLabel = UILabel(frame: CGRect(x: 0,
            y: self.activityIndicatorView.frame.size.height,
            width: self.darkView.frame.size.width,
            height: self.darkView.frame.size.height - self.activityIndicatorView.frame.size.height)
        )
        self.loadingLabel.backgroundColor = UIColor.clearColor()
        self.loadingLabel.textColor = UIColor.whiteColor()
        self.loadingLabel.numberOfLines = NUMBER_OF_LINES_LOADING_LINES
        self.loadingLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        self.loadingLabel.textAlignment = .Center
        
        //We add the subviews
        self.darkView.addSubview(self.loadingLabel)
        self.darkView.addSubview(self.activityIndicatorView)
        
        //Finally we call our super
        super.init(frame: CGRect(origin: CGPointZero, size: UIScreen.mainScreen().bounds.size))
        
        self.addSubview(self.darkView)
    }
    
    //Computed Property
    class var shareWaitingView:CPSimpleHUD{
        
        //We create a struct with the static and the predicate
        struct Static{
            static var singletoneInstance = CPSimpleHUD(center: CGPointMake(
                UIScreen.mainScreen().bounds.size.width/2,
                UIScreen.mainScreen().bounds.size.height/2)
            )
            static var token: dispatch_once_t = 0
        }
        
            dispatch_once(&Static.token){
                Static.singletoneInstance = CPSimpleHUD(center: CGPointMake(
                    UIScreen.mainScreen().bounds.size.width/2,
                    UIScreen.mainScreen().bounds.size.height/2)
                )
            }            
        return Static.singletoneInstance
    }
    
//MARK: - Notification Methods
    
    func orientationHasChanged(notification:NSNotification)
    {
        self.frame = CGRect(origin: CGPointZero, size: UIScreen.mainScreen().bounds.size)
        let center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height/2)
        self.darkView.center = center
    }
    

//MARK: - Public Methods
    
    override func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.darkView, forKey: DARK_VIEW_CODER_KEY)
        aCoder.encodeObject(self.activityIndicatorView, forKey: ACTIVITY_INDICATOR_VIEW_CODER_KEY)
        aCoder.encodeObject(self.loadingLabel, forKey: LOADING_LABEL_CODER_KEY)
        
        super.encodeWithCoder(aCoder)
    }
    
    /*
        This method show the HUD checking first the device orientation.
    */
    func show()
    {
        self.frame = CGRect(origin: CGPointZero, size: UIScreen.mainScreen().bounds.size)
        let center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height/2)
        self.darkView.center = center
        
        //We get the window
        let keyWindow:UIWindow = UIApplication.sharedApplication().keyWindow
        
        //We add the view in the windows
        keyWindow.addSubview(self)
        self.activityIndicatorView.startAnimating()
        
        //If we have text we move the activity indicator
        let text:NSString! = self.loadingLabel.text;
        if  (text != nil && text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0) {
            self.activityIndicatorView.center = CGPointMake(self.darkView.frame.size.width/2.0, self.darkView.frame.size.height/2.0)
        }
        else{
            if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)){
                self.activityIndicatorView.center = CGPointMake(self.darkView.frame.size.width / 2.0, self.activityIndicatorView.frame.size.height / 2.0)
            }
            else{
                self.activityIndicatorView.center = CGPointMake(self.darkView.frame.size.width / 2.0, self.activityIndicatorView.frame.size.height / 2.0)
            }
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("orientationHasChanged:"), name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    }
    
    /*
        This method hide the HUD
    */
    func hide()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIApplicationDidChangeStatusBarOrientationNotification , object: nil)
        self.removeFromSuperview()
    }
    
    
    
}