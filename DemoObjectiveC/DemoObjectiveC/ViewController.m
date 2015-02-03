//
//  ViewController.m
//  DemoObjectiveC
//
//  Created by Carlos Pages on 03/02/2015.
//  Copyright (c) 2015 cepages. All rights reserved.
//

#import "ViewController.h"
#import "DemoObjectiveC-Swift.h"

static NSInteger INITIAL_REMAIN_TIME = 10;


@interface ViewController ()

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger remainTime;

@property (weak, nonatomic) IBOutlet UIButton *simpleHUDButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)activateSimpleHUDToucheIn:(id)sender {
    
    
    CPSimpleHUD *hud = [CPSimpleHUD shareWaitingView];
    hud.loadingLabel.text = @"Simple HUD";
    hud.heightDarkViewContraint.constant = 250;
    hud.widthDarkViewContraint.constant = 250;
    
    [hud show];
    
    
    self.remainTime = INITIAL_REMAIN_TIME;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
}


-(void)timerFire:(NSTimer *)timer
{
    self.remainTime--;
    
    [self.simpleHUDButton setTitle:[NSString stringWithFormat:@"Time remaining %li",(long)self.remainTime] forState:UIControlStateNormal];

    if (self.remainTime == 0) {
        [[CPSimpleHUD shareWaitingView] hide];
        [self.simpleHUDButton setTitle:@"Activate Simple HUD" forState:UIControlStateNormal];
        
        [self.timer invalidate];
        self.timer = nil;
    }
    
    //We update the button label
}

@end
