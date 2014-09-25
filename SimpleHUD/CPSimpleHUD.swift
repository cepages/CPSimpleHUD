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
private let DARK_VIEW_HEIGHT:Float = 150
private let DARK_VIEW_WIDTH:Float = 150

private let ACTIVITY_INDICATOR_VIEW_HEIGHT:Float = 65
private let ACTIVITY_INDICATOR_VIEW_WIDTH:Float = 65

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
    
    private var contraintActivityIndicator_loadingLabel:NSLayoutConstraint
    
    private let DARK_VIEW_CODER_KEY = "DARK_VIEW_CODER_KEY"
    private let ACTIVITY_INDICATOR_VIEW_CODER_KEY = "ACTIVITY_INDICATOR_VIEW_CODER_KEY"
    private let LOADING_LABEL_CODER_KEY = "LOADING_LABEL_CODER_KEY"
    private let ACTIVITY_INDICATOR_LOADING_LABEL_CODER_KEY = "ACTIVITY_INDICATOR_LOADING_LABEL_CODER_KEY"
    
//MARK: - Init Methods
    required init(coder aDecoder: NSCoder) {
        self.darkView = aDecoder.decodeObjectForKey(DARK_VIEW_CODER_KEY) as UIView
        self.activityIndicatorView = aDecoder.decodeObjectForKey(ACTIVITY_INDICATOR_VIEW_CODER_KEY) as UIActivityIndicatorView
        self.loadingLabel = aDecoder.decodeObjectForKey(LOADING_LABEL_CODER_KEY) as UILabel
        self.contraintActivityIndicator_loadingLabel = aDecoder.decodeObjectForKey(ACTIVITY_INDICATOR_LOADING_LABEL_CODER_KEY) as NSLayoutConstraint
        
        super.init(coder: aDecoder)
        
    }
    
    init(center: CGPoint){
        
        //Customization
        self.darkView = UIView(frame: CGRect(origin: CGPointZero,
            size: CGSizeMake(CGFloat(DARK_VIEW_WIDTH),
                CGFloat(DARK_VIEW_HEIGHT)))
        )
        
        self.darkView.center = center
        self.darkView.layer.cornerRadius = 10.0
        self.darkView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        // create new dialog box view and component
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        self.activityIndicatorView.bounds = CGRect(origin: CGPointZero,
            size: CGSizeMake(CGFloat(ACTIVITY_INDICATOR_VIEW_WIDTH),
                CGFloat(ACTIVITY_INDICATOR_VIEW_HEIGHT))
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
        self.loadingLabel.text = ""
        
        //We add the subviews
        self.darkView.addSubview(self.loadingLabel)
        self.darkView.addSubview(self.activityIndicatorView)
        
        self.contraintActivityIndicator_loadingLabel = NSLayoutConstraint(item: self.activityIndicatorView, attribute: .Bottom, relatedBy: .Equal, toItem: self.loadingLabel, attribute: .Top, multiplier: 1.0, constant: 0)
        
        //Finally we call our super
        super.init(frame: CGRect(origin: CGPointZero, size: UIScreen.mainScreen().bounds.size))
        
        self.addSubview(self.darkView)
    
        self.setUpDarkViewAutoLayout()
    }
    
    func setUpDarkViewAutoLayout(){
        self.loadingLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.activityIndicatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let viewsInDarkView = NSDictionary(objects: [self.loadingLabel,self.activityIndicatorView], forKeys: ["loadingLabel","activityIndicatorView"])
        let metricsInDarkView = ["activityIndicatorViewWidth":NSNumber(float: ACTIVITY_INDICATOR_VIEW_WIDTH),
            "activityIndicatorViewHeight":NSNumber(float: ACTIVITY_INDICATOR_VIEW_HEIGHT)] as NSDictionary
        
        self.darkView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[activityIndicatorView(activityIndicatorViewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsInDarkView, views: viewsInDarkView))
        self.darkView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[activityIndicatorView(activityIndicatorViewHeight)]", options: NSLayoutFormatOptions(0), metrics: metricsInDarkView, views: viewsInDarkView))
        
        
        let centerInY = NSLayoutConstraint(item:self.loadingLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.darkView, attribute: .CenterY, multiplier: 1.0, constant: 0)
        let centerInX = NSLayoutConstraint(item:self.loadingLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.darkView, attribute: .CenterX, multiplier: 1.0, constant: 0)
        let centerInXActivityIndicator = NSLayoutConstraint(item:self.activityIndicatorView, attribute: .CenterX, relatedBy: .Equal, toItem: self.darkView, attribute: .CenterX, multiplier: 1.0, constant: 0)
        
        self.darkView.addConstraint(centerInX)
        self.darkView.addConstraint(centerInY)
        self.darkView.addConstraint(centerInXActivityIndicator)
        
        self.darkView.addConstraint(self.contraintActivityIndicator_loadingLabel)

        
        self.darkView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let contraintCenterX = NSLayoutConstraint(item: self.darkView, attribute:.CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0)
        let contraintCenterY = NSLayoutConstraint(item: self.darkView, attribute:.CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0)
        self.addConstraint(contraintCenterX)
        self.addConstraint(contraintCenterY)
        
        let views = NSDictionary(objects: [self.darkView], forKeys: ["darkView"])
        let metrics = NSDictionary(objects: [NSNumber(float:DARK_VIEW_WIDTH),NSNumber(float:DARK_VIEW_HEIGHT)], forKeys: ["darkViewWidth","darkViewHeight"])
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[darkView(darkViewWidth)]", options: NSLayoutFormatOptions(0), metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[darkView(darkViewHeight)]", options: NSLayoutFormatOptions(0), metrics: metrics, views: views))
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
        self.darkView.removeConstraint(self.contraintActivityIndicator_loadingLabel)

        
        //If we have text we move the activity indicator
        let text:NSString! = self.loadingLabel.text;
        if  (text != nil && text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0) {
            self.contraintActivityIndicator_loadingLabel = NSLayoutConstraint(item:self.activityIndicatorView, attribute: .CenterY, relatedBy: .Equal, toItem: self.darkView, attribute: .CenterY, multiplier: 1.0, constant: 0)
            self.darkView.addConstraint(self.contraintActivityIndicator_loadingLabel)
        }
        else{
            self.contraintActivityIndicator_loadingLabel = NSLayoutConstraint(item: self.activityIndicatorView, attribute: .Bottom, relatedBy: .Equal, toItem: self.loadingLabel, attribute: .Top, multiplier: 1.0, constant: 0)
            
            self.darkView.addConstraint(self.contraintActivityIndicator_loadingLabel)
            
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
    
    override func intrinsicContentSize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    
}
