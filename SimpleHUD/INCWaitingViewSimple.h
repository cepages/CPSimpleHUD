//
//  INCWaitingView.h
//
//  Created by Carlos Pages on 31/03/2014.
//  Copyright (c) 2014 IncunaLTD. All rights reserved.
//
/*
 How use INCWaitingViewSimple: 
 Just create the view with: initDefaultSizeAndCenter and add it to your view.
 */
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WaitingType) {
    WaitingTypeUnlimited,
    WaitingTypeImageSplash
};

@interface INCWaitingViewSimple : UIView

@property(nonatomic,strong)NSString *loadingText;

@property(nonatomic,assign)CGPoint darkCenterView;
+(INCWaitingViewSimple *)shareWaitingView;

-(void)show;
-(void)hide;
@property(nonatomic,assign,readonly)BOOL isShown;

@property(nonatomic,assign)WaitingType waitingType;
-(void)setImageSplash:(UIImage *)image;

@end
