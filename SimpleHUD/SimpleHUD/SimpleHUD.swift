//
//  SimpleHUD.swift
//  SimpleHUD
//
//  Created by Carlos Pages on 28/08/2014.
//  Copyright (c) 2014 k4Nt30. All rights reserved.
//

import Foundation
import UIKit

enum WaitingType{
    case WaitingTypeUnlimited
    case WaitingTypeImageSplash
}


private let _singletoneInstance = SimpleHUD(center: CGPointMake(
                                                                            UIScreen.mainScreen().bounds.size.width/2,
                                                                            UIScreen.mainScreen().bounds.size.height/2)
                                            )
private let DARK_VIEW_HEIGHT:CGFloat = 150
private let DARK_VIEW_WIDTH:CGFloat = 150

private let ACTIVITY_INDICATOR_VIEW_HEIGHT:CGFloat = 65
private let ACTIVITY_INDICATOR_VIEW_WIDTH:CGFloat = 65

private let NUMBER_OF_LINES_LOADING_LINES = 2
class SimpleHUD : UIView{
    var loadingText:NSString
    var darkView:UIView?
    var activityIndicatorView:UIActivityIndicatorView?
    var loadingLabel:UILabel?
    
    required init(coder aDecoder: NSCoder!) {
        self.loadingText = ""

        super.init(coder: aDecoder)
    }
    
    init(center: CGPoint){
        self.loadingText = ""

        
        super.init(frame: CGRect(origin: CGPointZero, size: UIScreen.mainScreen().bounds.size))
        
        //Customization
        self.darkView = UIView(frame: CGRect(origin: CGPointZero,
                                             size: CGSizeMake(DARK_VIEW_WIDTH,
                                                              DARK_VIEW_HEIGHT))
                              )
        self.darkView!.center = center
        self.darkView!.layer.cornerRadius = 10.0
        self.darkView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        // create new dialog box view and component
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        self.activityIndicatorView!.bounds = CGRect(origin: CGPointZero,
                                                    size: CGSizeMake(ACTIVITY_INDICATOR_VIEW_WIDTH,
                                                                     ACTIVITY_INDICATOR_VIEW_HEIGHT)
                                                    )

        self.activityIndicatorView!.center = CGPointMake(self.darkView!.frame.size.width / 2.0,
                                                         self.darkView!.frame.size.height / 2.0)
        
        self.activityIndicatorView!.hidesWhenStopped = true
        
        self.loadingLabel = UILabel(frame: CGRect(x: 0,
                                                  y: self.activityIndicatorView!.frame.size.height,
                                                  width: self.darkView!.frame.size.width,
                                                  height: self.darkView!.frame.size.height - self.activityIndicatorView!.frame.size.height)
                                    )
        self.loadingLabel!.backgroundColor = UIColor.clearColor()
        self.loadingLabel!.textColor = UIColor.whiteColor()
        self.loadingLabel!.numberOfLines = NUMBER_OF_LINES_LOADING_LINES
        self.loadingLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        self.loadingLabel!.textAlignment = .Center
        
        if let _darkView = self.darkView{
            _darkView.addSubview(self.loadingLabel!)
            _darkView.addSubview(self.activityIndicatorView!)
            
            self.addSubview(_darkView)
        }
    }
    
    //Computed Property
    class var shareWaitingView:SimpleHUD{
        
        
        struct Static{
            static var singletoneInstance = SimpleHUD(center: CGPointMake(
                UIScreen.mainScreen().bounds.size.width/2,
                UIScreen.mainScreen().bounds.size.height/2)
            )
            static var token: dispatch_once_t = 0
        }
        
            dispatch_once(&Static.token){
                Static.singletoneInstance = SimpleHUD(center: CGPointMake(
                    UIScreen.mainScreen().bounds.size.width/2,
                    UIScreen.mainScreen().bounds.size.height/2)
                )
            }
        Static.singletoneInstance.loadingText = ""
            
        return Static.singletoneInstance
    }
    
}


