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

//private let _singletoneInstance = SimpleHUD.init(CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2))

class SimpleHUD : UIView{
//    var loadingText:NSString
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        
//        let a = SimpleHUD.init(frame: CGPointMake(UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height/2))
//   
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private let DARK_VIEW_HEIGHT = 150;
    private let DARK_VIEW_WIDTH = 150;
    
    
    leer: https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html
    convenience init(defaultSizeAndCenter: CGPoint){
        
        let size:CGSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.init(frame: CGRectMake(0, 0, size.width, size.height))
        
        
    }
    
//    static NSInteger DARK_VIEW_HEIGHT = 150;
//    static NSInteger DARK_VIEW_WIDTH = 150;
//    -(id)initDefaultSizeAndCenter:(CGPoint)center{
//    
//    self = [super initWithFrame:(CGRect){CGPointMake(0, 0), [UIScreen mainScreen].bounds.size}];
//    if (self) {
//    self.darkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DARK_VIEW_WIDTH, DARK_VIEW_HEIGHT)];
//    self.darkView.center = center;
//    
//    // create new dialog box view and components
//    self.activityIndicatorView = [[UIActivityIndicatorView alloc]
//    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    
//    // other size? change it
//    self.activityIndicatorView.bounds = CGRectMake(0, 0, 65, 65);
//    self.activityIndicatorView.hidesWhenStopped = YES;
//    
//    self.loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.activityIndicatorView.frame.size.height, self.darkView.frame.size.width, self.darkView.frame.size.height - self.activityIndicatorView.frame.size.height)];
//    self.loadingLabel.backgroundColor = [UIColor clearColor];
//    self.loadingLabel.textColor = [UIColor whiteColor];
//    
//    self.loadingLabel.numberOfLines = 2;
//    self.loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
//    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
//    
//    self.darkView.layer.cornerRadius = 10.0f;
//    self.darkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
//    
//    // display it in the center of your view
//    self.loadingLabel.text = @"";
//    [self.darkView addSubview:self.loadingLabel];
//    [self.darkView addSubview:self.activityIndicatorView];
//    self.activityIndicatorView.center = CGPointMake(self.darkView.frame.size.width / 2.0, self.darkView.frame.size.height / 2.0);
//    
//    [self addSubview:self.darkView];
//    }
//    return self;
//    }
    
    
//    class var shareWaitingView:SimpleHUD{
//        return _singletoneInstance
//    }
    
//    +(INCWaitingViewSimple *)shareWaitingView{
//    static dispatch_once_t once;
//    static INCWaitingViewSimple *waitingView;
//    
//    dispatch_once(&once, ^{
//    waitingView = [[INCWaitingViewSimple alloc] initDefaultSizeAndCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
//    });
//    waitingView.loadingText = @"";
//    return waitingView;
//    }
    
}


