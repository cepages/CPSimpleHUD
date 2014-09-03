//
//  INCWaitingView.m
//
//  Created by Carlos Pages on 31/03/2014.
//  Copyright (c) 2014 IncunaLTD. All rights reserved.
//

#import "INCWaitingViewSimple.h"
#import <QuartzCore/QuartzCore.h>


@interface INCWaitingViewSimple ()

@property(nonatomic,strong)UIView *darkView;


@property(nonatomic,strong)UILabel *loadingLabel;
@property(nonatomic,strong)UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic,strong)UIImageView *imageViewSplash;
@property(nonatomic,strong)UIGestureRecognizer *tapGesture;
@end

@implementation INCWaitingViewSimple

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+(INCWaitingViewSimple *)shareWaitingView{
    static dispatch_once_t once;
    static INCWaitingViewSimple *waitingView;
    
    dispatch_once(&once, ^{
        waitingView = [[INCWaitingViewSimple alloc] initDefaultSizeAndCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
    });
    waitingView.loadingText = @"";
    return waitingView;
}


static NSInteger DARK_VIEW_HEIGHT = 150;
static NSInteger DARK_VIEW_WIDTH = 150;
-(id)initDefaultSizeAndCenter:(CGPoint)center{
    
    self = [super initWithFrame:(CGRect){CGPointMake(0, 0), [UIScreen mainScreen].bounds.size}];
    if (self) {
        self.darkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DARK_VIEW_WIDTH, DARK_VIEW_HEIGHT)];
        self.darkView.center = center;
        
        // create new dialog box view and components
        self.activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        // other size? change it
        self.activityIndicatorView.bounds = CGRectMake(0, 0, 65, 65);
        self.activityIndicatorView.hidesWhenStopped = YES;
        
        self.loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.activityIndicatorView.frame.size.height, self.darkView.frame.size.width, self.darkView.frame.size.height - self.activityIndicatorView.frame.size.height)];
        self.loadingLabel.backgroundColor = [UIColor clearColor];
        self.loadingLabel.textColor = [UIColor whiteColor];
        
        self.loadingLabel.numberOfLines = 2;
        self.loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        self.loadingLabel.textAlignment = NSTextAlignmentCenter;
     
        self.darkView.layer.cornerRadius = 10.0f;
        self.darkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        // display it in the center of your view
        self.loadingLabel.text = @"";
        [self.darkView addSubview:self.loadingLabel];
        [self.darkView addSubview:self.activityIndicatorView];
        self.activityIndicatorView.center = CGPointMake(self.darkView.frame.size.width / 2.0, self.darkView.frame.size.height / 2.0);

        [self addSubview:self.darkView];
    }
    return self;
}



-(void)show
{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];

    [keyWindow addSubview:self];
    [self.activityIndicatorView startAnimating];
    if (self.loadingLabel == NULL || self.loadingLabel.text.length == 0) {
        self.activityIndicatorView.center = CGPointMake(self.darkView.frame.size.width/2.0, self.darkView.frame.size.height/2.0);
    }
    else{
        self.activityIndicatorView.center = CGPointMake(self.darkView.frame.size.width / 2.0, self.activityIndicatorView.frame.size.height / 2.0);
    }
}

-(void)hide
{
    [self removeFromSuperview];
}

-(void)setLoadingText:(NSString *)loadingText
{
    _loadingText = loadingText;
    self.loadingLabel.text = loadingText;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (newWindow) {
        self.layer.zPosition = MAXFLOAT;
    }

}

-(void)setImageSplash:(UIImage *)image
{
    self.imageViewSplash.image = image;
}

-(BOOL)isShown
{
    if (self.window) {
        return YES;
    }
    else{
        return NO;
    }
}


#pragma mark -
#pragma mark Private Methods

-(void)setDarkCenterView:(CGPoint)darkCenterView
{
    _darkCenterView = darkCenterView;
    self.darkView.center = darkCenterView;
}

-(void)setWaitingType:(WaitingType)waitingType
{
    if (waitingType != _waitingType) {
        _waitingType = waitingType;
        [self setUpWaitingType];
    }
    
}

static NSInteger IMAGE_SPLASH_VERTICAL_PADDING = 10;
static NSInteger IMAGE_SPLASH_HORIZONTAL_PADDING = 10;

-(void)setUpWaitingType
{
    [self.darkView removeFromSuperview];
    self.darkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DARK_VIEW_WIDTH, DARK_VIEW_HEIGHT)];
    
    switch (self.waitingType) {
        case WaitingTypeImageSplash:
        {
            
            self.imageViewSplash = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DARK_VIEW_WIDTH - (IMAGE_SPLASH_HORIZONTAL_PADDING *2), DARK_VIEW_HEIGHT - (IMAGE_SPLASH_VERTICAL_PADDING *2))];
            self.imageViewSplash.center = CGPointMake(self.darkView.frame.size.width/2, self.darkView.frame.size.height/2);
            [self.imageViewSplash setContentMode:UIViewContentModeCenter];
            [self.darkView addSubview:self.imageViewSplash];
            
            self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTapGesture:)];
            [self addGestureRecognizer:self.tapGesture];
        }
            break;
            
        default:
        {
            if (self.tapGesture) {
                [self removeGestureRecognizer:self.tapGesture];
            }
            
            [self.darkView addSubview:self.loadingLabel];
            [self.darkView addSubview:self.activityIndicatorView];
        }
            break;
    }
    
    self.darkView.layer.cornerRadius = 10.0f;
    self.darkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.darkView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    [self addSubview:self.darkView];

}

#pragma mark -
#pragma mark Gestures

-(IBAction)dismissTapGesture:(id)sender
{
    if (self.tapGesture) {
        [self removeGestureRecognizer:self.tapGesture];
    }
    [self hide];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
