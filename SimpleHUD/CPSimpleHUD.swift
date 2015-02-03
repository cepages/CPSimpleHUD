//
//  CPSimpleHUD.swift
//  CPSimpleHUD
//
//  Created by Carlos Pages on 28/08/2014.
//  Copyright (c) 2014 Carlos Pages. All rights reserved.
//

import Foundation
import UIKit

enum WaitingType: Int{
    case Unlimited
    case SmallCubesLinear
    case SmallCubesBorders
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
    
    var waitingMode:WaitingType = .Unlimited {
        didSet {
            if(self.waitingMode != oldValue){
                self.setUpWaitingType(waitingMode)
            }
        }
    }
    
    /**
    Dark view will be our canvas to draw and add subviews.
    */
    let darkView:UIView
    
    let heightDarkViewContraint:NSLayoutConstraint
    let widthDarkViewContraint:NSLayoutConstraint
    
//MARK Unlimited
    private let activityIndicatorView:UIActivityIndicatorView
    /**
        Label shown when the activity indicator is running, if it's nil or the text it's empty nothing will show and the activity indicator will be placed in the middle of the dark view
    */
    let loadingLabel:UILabel
    /**
        This is the HUD type, by default is set as Unlimited
    */
    
    private var contraintActivityIndicator_loadingLabel:NSLayoutConstraint
    
    private let DARK_VIEW_CODER_KEY = "DARK_VIEW_CODER_KEY"
    private let ACTIVITY_INDICATOR_VIEW_CODER_KEY = "ACTIVITY_INDICATOR_VIEW_CODER_KEY"
    private let LOADING_LABEL_CODER_KEY = "LOADING_LABEL_CODER_KEY"
    private let ACTIVITY_INDICATOR_LOADING_LABEL_CODER_KEY = "ACTIVITY_INDICATOR_LOADING_LABEL_CODER_KEY"
    private let HEIGHT_DARK_VIEW_CONTRAINT_CODER_KEY = "HEIGHT_DARK_VIEW_CONTRAINT_CODER_KEY"
    private let WIDTH_DARK_VIEW_CONTRAINT_CODER_KEY = "WIDTH_DARK_VIEW_CONTRAINT_CODER_KEY"

    
//MARK SmallCubes
    
    
    private var pathOfCubes:NSMutableArray?
    private var timer:NSTimer?
    private var cubeAnimating:Int=0
    private var timerShouldInvalidate:Bool = false
    
    
//MARK: - Init Methods
    required init(coder aDecoder: NSCoder) {
        self.darkView = aDecoder.decodeObjectForKey(DARK_VIEW_CODER_KEY) as UIView
        self.activityIndicatorView = aDecoder.decodeObjectForKey(ACTIVITY_INDICATOR_VIEW_CODER_KEY) as UIActivityIndicatorView
        self.loadingLabel = aDecoder.decodeObjectForKey(LOADING_LABEL_CODER_KEY) as UILabel
        self.contraintActivityIndicator_loadingLabel = aDecoder.decodeObjectForKey(ACTIVITY_INDICATOR_LOADING_LABEL_CODER_KEY) as NSLayoutConstraint
        self.widthDarkViewContraint = aDecoder.decodeObjectForKey(WIDTH_DARK_VIEW_CONTRAINT_CODER_KEY) as NSLayoutConstraint
        self.heightDarkViewContraint = aDecoder.decodeObjectForKey(HEIGHT_DARK_VIEW_CONTRAINT_CODER_KEY) as NSLayoutConstraint
        
        super.init(coder: aDecoder)
        
    }
    
    init(center: CGPoint){
        
        self.darkView = UIView(frame: CGRect(origin: CGPointZero,
            size: CGSizeMake(CGFloat(DARK_VIEW_WIDTH),
                CGFloat(DARK_VIEW_HEIGHT)))
        )
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

        self.loadingLabel = UILabel(frame: CGRect(x: 0,
            y: self.activityIndicatorView.frame.size.height,
            width: self.darkView.frame.size.width,
            height: self.darkView.frame.size.height - self.activityIndicatorView.frame.size.height)
        )
        self.contraintActivityIndicator_loadingLabel = NSLayoutConstraint(item: self.activityIndicatorView, attribute: .Bottom, relatedBy: .Equal, toItem: self.loadingLabel, attribute: .Top, multiplier: 1.0, constant: 0)
        //Customization
        
        self.heightDarkViewContraint = NSLayoutConstraint(item: self.darkView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.darkView.frame.size.height)
        self.widthDarkViewContraint = NSLayoutConstraint(item: self.darkView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.darkView.frame.size.width)
        
        //Finally we call our super
        super.init(frame: CGRect(origin: CGPointZero, size: UIScreen.mainScreen().bounds.size))
        
        
        self.addSubview(self.darkView)
        self.setUpWaitingTypeUnlimited()
        
    }
    
    private func setUpDarkViewAutoLayout(){
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
        
        self.addConstraint(self.heightDarkViewContraint)
        self.addConstraint(self.widthDarkViewContraint)
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
    
    private func orientationHasChanged(notification:NSNotification)
    {
        self.frame = CGRect(origin: CGPointZero, size: UIScreen.mainScreen().bounds.size)
        let center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height/2)
        self.darkView.center = center
    }
//MARK: - Private Methods
//MARK: Setup Waiting Types
    
    private func setUpWaitingType(waitingType:WaitingType){
        //First we remove the dark view from the superview
        for view in self.darkView.subviews {
            view.removeFromSuperview()
        }

        switch waitingType{
        case .SmallCubesLinear,.SmallCubesBorders:
                self.setUpSmallCubes()
        default:
            
            self.setUpWaitingTypeUnlimited()
            self
            
        }
    }
    
    private func setUpWaitingTypeUnlimited(){
        
        self.darkView.center = center
        self.darkView.layer.cornerRadius = 10.0
        self.darkView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        // create new dialog box view and component
        self.activityIndicatorView.bounds = CGRect(origin: CGPointZero,
            size: CGSizeMake(CGFloat(ACTIVITY_INDICATOR_VIEW_WIDTH),
                CGFloat(ACTIVITY_INDICATOR_VIEW_HEIGHT))
        )
        
        //We place the activity view in the center of the dark view
        self.activityIndicatorView.center = CGPointMake(self.darkView.frame.size.width / 2.0,
            self.darkView.frame.size.height / 2.0)
        
        self.activityIndicatorView.hidesWhenStopped = true
        
        //We set up the label
        
        self.loadingLabel.backgroundColor = UIColor.clearColor()
        self.loadingLabel.textColor = UIColor.whiteColor()
        self.loadingLabel.numberOfLines = NUMBER_OF_LINES_LOADING_LINES
        self.loadingLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        self.loadingLabel.textAlignment = .Center
        self.loadingLabel.text = ""
        
        //We add the subviews
        self.darkView.addSubview(self.loadingLabel)
        self.darkView.addSubview(self.activityIndicatorView)
        
        self.setUpDarkViewAutoLayout()
    }
    
    
    
    func setUpSmallCubes()
    {
        let MARGIN = 5 as Int
        let DISTANCE_BETWEEN_CUBES = 2
        
        let cubesInX = 6;
        let cubesInY = 6;
        
        let cubeSizeX = (((Int(self.darkView.frame.size.width) - MARGIN * 2 - Int(DISTANCE_BETWEEN_CUBES))-(cubesInX * DISTANCE_BETWEEN_CUBES))/cubesInX)
        let cubeSizeY = (((Int(self.darkView.frame.size.width) - MARGIN * 2 - Int(DISTANCE_BETWEEN_CUBES))-(cubesInY * DISTANCE_BETWEEN_CUBES))/cubesInY)

        var xPosition = 0
        var yPosition = 0
        var tag = 1
        var listOfCubes = NSMutableArray(capacity: cubesInX * cubesInY)
        
        let sizeCubeView = cubeSizeX * cubesInX + (cubesInX - 1) * DISTANCE_BETWEEN_CUBES
        let cubeView:UIView = UIView(frame: CGRect(origin: CGPointZero, size: CGSizeMake(CGFloat(sizeCubeView), CGFloat(sizeCubeView))));
        
        let metricsCube:NSDictionary = ["distanceBetweenCubes":NSNumber(integer: DISTANCE_BETWEEN_CUBES)] as NSDictionary


        for indexY in 1...cubesInY{
            for index in 1...cubesInX{
                let cube = UIView()
                cube.tag = tag
                cube.backgroundColor = UIColor.clearColor()
                tag++
                
                xPosition += DISTANCE_BETWEEN_CUBES + cubeSizeX
                cubeView.addSubview(cube)
                cube.setTranslatesAutoresizingMaskIntoConstraints(false)

                cube.setContentCompressionResistancePriority(0, forAxis: .Horizontal)
                cube.setContentCompressionResistancePriority(0, forAxis: .Vertical)
                cube.setContentHuggingPriority(1000, forAxis: .Horizontal)
                cube.setContentHuggingPriority(1000, forAxis: .Vertical)
                
                
                switch index{
                case 1:
                    
                    let views:NSDictionary = ["cube":cube] as NSDictionary
                    
                    [cubeView .addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cube]", options: NSLayoutFormatOptions(0), metrics: nil, views: views))]
                    
                    break;
                case cubesInX:
                    let previousCube:UIView = listOfCubes.objectAtIndex(listOfCubes.count - 1) as UIView
                    
                    let views:NSDictionary = ["cube":cube,"previousCube":previousCube] as NSDictionary
                    [cubeView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[previousCube]-distanceBetweenCubes-[cube]|", options: NSLayoutFormatOptions(0), metrics: metricsCube, views: views))]
                    [cubeView.addConstraint(NSLayoutConstraint(item: cube, attribute: .Width, relatedBy: .Equal, toItem: previousCube, attribute: .Width, multiplier: 1, constant: 0))];
                
                break;
                default:
                    let previousCube:UIView = listOfCubes.objectAtIndex(listOfCubes.count - 1) as UIView

                    let views:NSDictionary = ["cube":cube,"previousCube":previousCube] as NSDictionary
                    [cubeView .addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[previousCube]-distanceBetweenCubes-[cube]", options: NSLayoutFormatOptions(0), metrics: metricsCube, views: views))]
                    [cubeView.addConstraint(NSLayoutConstraint(item: cube, attribute: .Width, relatedBy: .Equal, toItem: previousCube, attribute: .Width, multiplier: 1, constant: 0))];
                }

                switch indexY
                {
                case 1:
                    let views:NSDictionary = ["cube":cube] as NSDictionary
                    
                    [cubeView .addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cube]", options: NSLayoutFormatOptions(0), metrics: nil, views: views))]

                    break;
                case cubesInY:
                    let previousCube:UIView = listOfCubes.objectAtIndex(listOfCubes.count - cubesInX) as UIView
                    
                    let views:NSDictionary = ["cube":cube,"previousCube":previousCube] as NSDictionary
                    [cubeView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[previousCube]-distanceBetweenCubes-[cube]|", options: NSLayoutFormatOptions(0), metrics: metricsCube, views: views))]
                    [cubeView.addConstraint(NSLayoutConstraint(item: cube, attribute: .Height, relatedBy: .Equal, toItem: previousCube, attribute: .Height, multiplier: 1, constant: 0))];
                    
                    break;
                    
                default:
                    let previousCube:UIView = listOfCubes.objectAtIndex(listOfCubes.count - cubesInX) as UIView

                    
                    let views:NSDictionary = ["cube":cube,"previousCube":previousCube] as NSDictionary
                    [cubeView .addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[previousCube]-distanceBetweenCubes-[cube]", options: NSLayoutFormatOptions(0), metrics: metricsCube, views: views))]
                    [cubeView.addConstraint(NSLayoutConstraint(item: cube, attribute: .Height, relatedBy: .Equal, toItem: previousCube, attribute: .Height, multiplier: 1, constant: 0))];
                }
                listOfCubes.addObject(cube)
            }
            yPosition += DISTANCE_BETWEEN_CUBES + cubeSizeY
            xPosition = 0
        }
        cubeView.backgroundColor = UIColor.clearColor()
        self.darkView.addSubview(cubeView);
        cubeView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let metrics:NSDictionary = ["margin":NSNumber(integer:MARGIN)] as NSDictionary
        let views:NSDictionary = ["cubeview":cubeView] as NSDictionary
        
        [self.darkView .addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-margin-[cubeview]-margin-|", options: NSLayoutFormatOptions(0), metrics: metrics, views: views))]
        [self.darkView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-margin-[cubeview]-margin-|", options: NSLayoutFormatOptions(0), metrics: metrics, views: views))]
        
        [self.darkView .addConstraint(NSLayoutConstraint(item: cubeView, attribute: .CenterX, relatedBy: .Equal, toItem: self.darkView, attribute: .CenterX, multiplier: 1, constant: 0))]
        [self.darkView .addConstraint(NSLayoutConstraint(item: cubeView, attribute: .CenterY, relatedBy: .Equal, toItem: self.darkView, attribute: .CenterY, multiplier: 1, constant: 0))]
        
        self.pathOfCubes = NSMutableArray();
        switch(self.waitingMode){
        case .SmallCubesBorders:
            for index in 0...(cubesInX-1){
                self.pathOfCubes?.addObject(listOfCubes[index])
            }
            for index in 2...(cubesInY-1){
                self.pathOfCubes?.addObject(listOfCubes[(cubesInX * index) - 1])
            }
            for var index:Int = listOfCubes.count-1; (listOfCubes.count-1)-(cubesInX-1) <= index; index-- {
                self.pathOfCubes?.addObject(listOfCubes[index])
            }
            for index in 2...(cubesInY-1){
                self.pathOfCubes?.addObject(listOfCubes[(cubesInX * (cubesInY - index))])
            }
            
        default:
            self.pathOfCubes = listOfCubes
        }
        
        
    }

//MARK: Timer Small Cubes
    func cleanCubes(listOfCubes:NSArray){
        for var index = 0; index < listOfCubes.count; ++index{
            let view = listOfCubes[index] as UIView
            view.backgroundColor = UIColor.clearColor()
        }
        self.cubeAnimating = 0
    }
    func timerCubes(timer:NSTimer){
        
        if var listOfCubes = self.pathOfCubes
        {
            if (self.cubeAnimating == listOfCubes.count) {
                self.cleanCubes(listOfCubes)
            }
            for var index:Int = self.cubeAnimating; 0 <= index ; --index{
                
                switch index{
                case self.cubeAnimating:
                    let cubeViewCurrent = listOfCubes[self.cubeAnimating] as UIView
                    cubeViewCurrent.backgroundColor = UIColor.whiteColor()
                    
                case self.cubeAnimating - 1:
                    let cubeViewPrevious = listOfCubes[self.cubeAnimating - 1] as UIView
                    cubeViewPrevious.backgroundColor = UIColor(red: 209.0/255.0, green: 209.0/255.0, blue: 209.0/255.0, alpha: 1)
                case self.cubeAnimating - 2:
                    let cubeViewPrevious = listOfCubes[self.cubeAnimating - 2] as UIView
                    cubeViewPrevious.backgroundColor = UIColor(red: 156.0/255.0, green: 156.0/255.0, blue: 156.0/255.0, alpha: 1)
                case self.cubeAnimating - 3:
                    let cubeViewPrevious = listOfCubes[self.cubeAnimating - 3] as UIView
                    cubeViewPrevious.backgroundColor = UIColor(red: 96.0/255.0, green: 96.0/255.0, blue: 96.0/255.0, alpha: 1)
                    
                default:
                    let cubeViewPreviousPrevious = listOfCubes[index] as UIView
                    cubeViewPreviousPrevious.backgroundColor = UIColor.clearColor()
                }
            }
            self.cubeAnimating += 1

            if self.timerShouldInvalidate{
                self.cleanCubes(listOfCubes)

                timer.invalidate()
            }
        }
        else{
            timer.invalidate()
        }

    }
    
//MARK: - Public Methods
    
    override func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.darkView, forKey: DARK_VIEW_CODER_KEY)
        aCoder.encodeObject(self.activityIndicatorView, forKey: ACTIVITY_INDICATOR_VIEW_CODER_KEY)
        aCoder.encodeObject(self.loadingLabel, forKey: LOADING_LABEL_CODER_KEY)
        aCoder.encodeObject(self.widthDarkViewContraint,forKey: WIDTH_DARK_VIEW_CONTRAINT_CODER_KEY)
        aCoder.encodeObject(self.heightDarkViewContraint,forKey: HEIGHT_DARK_VIEW_CONTRAINT_CODER_KEY)
        aCoder.encodeObject(self.contraintActivityIndicator_loadingLabel,forKey: ACTIVITY_INDICATOR_LOADING_LABEL_CODER_KEY)
        
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
        let keyWindow:UIWindow = UIApplication.sharedApplication().keyWindow!
        
        //We add the view in the windows
        keyWindow.addSubview(self)
        
        var transform:CGAffineTransform = CGAffineTransformIdentity
        let orientation:UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation;
        
        switch orientation{
            case .LandscapeLeft:
                self.darkView.transform = CGAffineTransformMakeRotation(CGFloat(3 * M_PI_2))
            case .LandscapeRight:
                self.darkView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            case .PortraitUpsideDown:
                self.darkView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            default:
                self.darkView.transform = CGAffineTransformIdentity;
        }
        
        switch self.waitingMode{
            case .SmallCubesLinear,.SmallCubesBorders:
                self.timerShouldInvalidate = false
                self.cubeAnimating = 0
                self.timer? = NSTimer.scheduledTimerWithTimeInterval(0.08, target: self, selector: Selector("timerCubes:"), userInfo:nil , repeats: true)
            

            default:
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
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("orientationHasChanged:"), name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    }
    
    /*
        This method hide the HUD
    */
    func hide()
    {
        switch self.waitingMode{
        case .SmallCubesLinear,.SmallCubesBorders:
            self.timerShouldInvalidate = true
            self.loadingLabel.text = ""

            NSNotificationCenter.defaultCenter().removeObserver(self, name:UIApplicationDidChangeStatusBarOrientationNotification , object: nil)

        default:
            NSNotificationCenter.defaultCenter().removeObserver(self, name:UIApplicationDidChangeStatusBarOrientationNotification , object: nil)

        }
        self.removeFromSuperview()
        
        self.loadingLabel.text = nil;
    }
    
    override func intrinsicContentSize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    
}
