//
//  StartViewController.m
//  Muse
//
//  Created by yan runchen on 2013/12/20.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "StartViewController.h"
#import "SWRevealViewController.h"
#import "User.h"
#import "Tag.h"
#import "Reachability.h"
#import <FacebookSDK/FacebookSDK.h>

@interface StartViewController ()

@end

@implementation StartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"museStart.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

- (void)exitApplication {
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:(UIViewAnimationTransition)UIViewAnimationOptionCurveEaseOut forView:self.view.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.view.layer.opacity = 0;
    [UIView commitAnimations];
}
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            NSLog(@"retry");
            [self connectAndSignIn];
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            NSLog(@"exit");
            [self exitApplication];
            break;
    }
    
}

- (void) connectAndSignIn
{
    Reachability *r = [Reachability reachabilityWithHostName: SERVER_IP];
    NSLog(@"%d",[r currentReachabilityStatus]);
    if ([r currentReachabilityStatus] == NotReachable) {
        UIAlertView * alert =
        [[UIAlertView alloc] initWithTitle:@"Error"
                                   message:@"Network connection is not well!"
                                  delegate:self
                         cancelButtonTitle:nil
                         otherButtonTitles:@"Retry",@"Exit", nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:false];
    }
    else{
        if ([User getUser]) {
            NSString *result = [[User getUser] signinWithRememberToken];
            if ([result isEqual:@"ok"]) {
                if ([Tag getAll]) {
                    [self performSegueWithIdentifier:@"jumpToPlay" sender:self];
                } else {
                    UIAlertView * alert =
                    [[UIAlertView alloc] initWithTitle:@"Error"
                                               message:@"Network connection is not well!"
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"Retry",@"Exit", nil];
                    
                    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:false];
                }
            }
            else{
                NSLog(@"%@",result);
                [FBSession.activeSession closeAndClearTokenInformation];
                [FBSession.activeSession close];
                [FBSession setActiveSession:nil];
                [self performSegueWithIdentifier:@"goToSign" sender:self];
            }
        }
        else{
            [FBSession.activeSession closeAndClearTokenInformation];
            [FBSession.activeSession close];
            [FBSession setActiveSession:nil];
            [self performSegueWithIdentifier:@"goToSign" sender:self];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self connectAndSignIn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
