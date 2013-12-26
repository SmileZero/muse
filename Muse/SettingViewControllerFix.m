//
//  SettingViewControllerFix.m
//  Muse
//
//  Created by zhu peijun on 2013/12/26.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "SettingViewControllerFix.h"
#import "SWRevealViewController.h"
#import "User.h"
#import "ServerConnection.h"
#import "Player.h"
#import "FPResponse.h"
#import "PlayerViewController.h"
#import <GracenoteMusicID/GNConfig.h>
#import <GracenoteMusicID/GNOperations.h>
#import <AVFoundation/AVFoundation.h>
#import <FacebookSDK/FacebookSDK.h>

#define VERSION @"1.0.0"


@interface SettingViewControllerFix ()
@property (nonatomic, strong) NSArray *menuItems;
@property (retain, nonatomic) GNConfig *config;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *recogContainer;
@property (nonatomic, strong) UIView *recogView;
@property (nonatomic, strong) UIImageView *border;
@property (nonatomic, strong) UIButton *recogBtn;
@property (nonatomic, strong) UILabel *musicName;
@property (nonatomic, strong) UILabel *artistName;
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property BOOL animating;

@property (weak, nonatomic) IBOutlet UITextField *aOldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *aNewPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextView *licenseTextView;

@end

@implementation SettingViewControllerFix

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.3f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         _border.transform = CGAffineTransformRotate(_border.transform, -M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (_animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

- (void) startSpin {
    if (!_animating) {
        _animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
    }
}

- (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    _animating = NO;
}

- (void)musicInfoHide
{
    _recogBtn.hidden = false;
    _border.hidden = false;
    _musicName.hidden = true;
    _artistName.hidden = true;
    _cover.hidden = true;
    _playBtn.hidden = true;
    [_recogBtn setTitle:@"TOUCH TO BEGIN" forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.view.backgroundColor = [UIColor colorWithWhite:0.17f alpha:1.0f];
    //self.tableView.backgroundColor = [UIColor colorWithWhite:0.17f alpha:1.0f];
    //self.tableView.separatorColor = [UIColor colorWithWhite:0.17f alpha:1.0f];
    
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float screenHeight = screenRect.size.height;
    
    
    CGRect licenseTextViewFrame = _licenseTextView.frame;
    
    if (screenHeight <= 481) {
        licenseTextViewFrame.size.height = 390.0f;
    } else {
        licenseTextViewFrame.size.height = 480.0f;
    }
    
    _licenseTextView.frame = licenseTextViewFrame;
    
    
    
    
    self.config = [GNConfig init:@"4388096-F18341100713290DF7B092A14D9627E6"];
    
    
    _aOldPasswordTextField.layer.cornerRadius = 1;
    _aNewPasswordTextField.layer.cornerRadius = 1;
    _passwordConfirmTextField.layer.cornerRadius = 1;
    _saveButton.layer.cornerRadius = 5;
    
    
    
    _containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    CGRect recogContainerRect = CGRectMake(0.0f, 40.0f, 300.0f, 300.0f);
    _recogContainer = [[UIView alloc] initWithFrame:recogContainerRect];
    _containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    //[[UIImage imageNamed:@"border.png"] drawInRect:_recogContainer.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _recogContainer.backgroundColor = [UIColor colorWithPatternImage:image];
    [_containerView addSubview:_recogContainer];
    
    CGRect recogRect = CGRectMake(22.0, 28.0, 252.0, 250.0);
    _recogView = [[UIView alloc] initWithFrame:recogRect];
    _recogView.backgroundColor = [UIColor colorWithWhite:0.18f alpha:0.0f];
    _recogView.layer.cornerRadius = 5;
    [_recogContainer addSubview:_recogView];
    
    _border = [[UIImageView alloc] initWithFrame:CGRectMake(-10,-10,270,270)];
    _border.image = [UIImage imageNamed:@"circle.png"];
    [_border setContentMode:UIViewContentModeScaleAspectFit];
    [_recogView addSubview: _border];
    
    _recogBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _recogBtn.frame = CGRectMake(20, 20, 213, 213
                                 ); // position in the parent view and set the size of the button
    //_recogBtn.backgroundColor= [UIColor colorWithWhite:1.0f alpha:0.5f];
    _recogBtn.layer.cornerRadius = 107;//half of the width
    [_recogBtn setTitleColor:[UIColor colorWithRed:0.33f green:0.33f blue:0.33f alpha:1.0] forState:UIControlStateNormal];
    [_recogBtn setTitle:@"TOUCH TO BEGIN" forState:UIControlStateNormal];
    [_recogBtn.titleLabel setFont:[UIFont fontWithName:@"Copperplate" size:20]];
    // add targets and actions
    [_recogBtn addTarget:self action:@selector(recogBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    [_recogView addSubview:_recogBtn];
    
    _musicName = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
    _musicName.text = @"Music Title";
    [_musicName setTextColor:[UIColor colorWithWhite:0.33f alpha:1]];
    _musicName.font = [UIFont fontWithName:@"Copperplate" size:20];
    [_recogView addSubview:_musicName];
    
    _artistName = [[UILabel alloc] initWithFrame:CGRectMake(23, 25, 200, 30)];
    _artistName.text = @"Artist Name";
    [_artistName setTextColor:[UIColor colorWithWhite:0.33f alpha:1]];
    _artistName.font = [UIFont fontWithName:@"Copperplate" size:16];
    [_recogView addSubview:_artistName];
    
    _cover = [[UIImageView alloc] initWithFrame:CGRectMake(88,85,150,150)];
    _cover.image = [UIImage imageNamed:@"Example.jpg"];
    [_cover setContentMode:UIViewContentModeScaleAspectFit];
    [_recogView addSubview: _cover];
    
    _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(88,85,150,150)];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"playButton.png"] drawInRect:_playBtn.bounds];
    UIImage *imagePlayBtn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _playBtn.backgroundColor = [UIColor colorWithPatternImage:imagePlayBtn];
    [_recogView addSubview: _playBtn];
    
    [_playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewTapped:)];
    [_containerView addGestureRecognizer:_tap];
    
    [self musicInfoHide];
    
    _menuItems = @[@"SettingTools",@"SettingAbout", @"SettingAccount"];
    _animating = NO;
    
    
    UILabel *labelView = (UILabel *)[self.view viewWithTag:1002];
    
    if ([User getUser]) {
        labelView.text = [User getUser].name;
        //cell.userInteractionEnabled = NO;
    }
    
    
    
    UIView * view = [self.view viewWithTag:901];
    view.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 ) {
        return 113;
    } else if(indexPath.row == 1 || indexPath.row == 2) {
        return 170;
    }
    return 52;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)sessionDidInterrupt:(NSNotification *)notification
{
    switch ([notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue]) {
        case AVAudioSessionInterruptionTypeBegan:
            NSLog(@"Interruption began");
            break;
        case AVAudioSessionInterruptionTypeEnded:
        default:
            NSLog(@"Interruption ended");
            break;
    }
}

- (void)sessionRouteDidChange:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(IBAction)recogBtnClicked:(id)sender
{
    NSLog(@"recog");
    _tap.enabled = NO;
    UIButton *button = (UIButton *)sender;
    [button setTitle:@"RECOGNIZING..." forState:UIControlStateNormal];
    [self startSpin];
    button.userInteractionEnabled = NO;
    id resp = [[FPResponse alloc] initWithNameLabel:_musicName artistLabel:_artistName cover:_cover playBtn:_playBtn recogBtn:_recogBtn border:_border tap:_tap animating:&_animating];
    [GNOperations recognizeMIDStreamFromMic:resp config:self.config];
}


-(IBAction)playBtnClicked:(id)sender
{
    NSLog(@"play");
    [self musicInfoHide];
    [_containerView removeFromSuperview];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    //[Player playMoviePlayer];
    
    PlayerViewController * playViewController = (PlayerViewController *)self.revealViewController.frontViewController;
    
    NSString * resultId = [FPResponse getResultId];
    
    if (resultId != NULL) {
        [playViewController loadMusicWithIdentifier:resultId];
        
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    }
}

- (void)containerViewTapped:(UITapGestureRecognizer *)gr {
    UIView *containerView = (UIImageView *)gr.view;
    [self musicInfoHide];
    [containerView removeFromSuperview];
    //[Player playMoviePlayer];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    
    //play
    PlayerViewController * playViewController = (PlayerViewController *)self.revealViewController.frontViewController;
    
    if (playViewController.currentPlayStatus == 1) {
        [playViewController musicPlay];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)recognizeButtonClicked:(id)sender {
    
    UIView * recMenuView = [self.view viewWithTag:909];
    
    [recMenuView addSubview:_recogContainer];
    
    
    CGRect beforeViewFrame  = recMenuView.frame;
    beforeViewFrame.origin.x = 320;
    recMenuView.frame = beforeViewFrame;
    
    recMenuView.hidden = NO;
    [UIView animateWithDuration: 0.7f delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
                         CGRect afterViewFrame  = recMenuView.frame;
                         afterViewFrame = recMenuView.frame;
                         afterViewFrame.origin.x = 54;
                         recMenuView.frame = afterViewFrame;
                         
                     }
                     completion: ^(BOOL finished) {}];
    
    //[self.view.window addSubview:_containerView];
    
    NSError *error = nil;
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(sessionDidInterrupt:) name:AVAudioSessionInterruptionNotification object:nil];
    [center addObserver:self selector:@selector(sessionRouteDidChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    
    //[Player stopMoviePlayer];
    PlayerViewController * playViewController = (PlayerViewController *)self.revealViewController.frontViewController;
    [playViewController musicPause];
}




- (IBAction)licenseButtonClicked:(id)sender {
    
    UIView * view = [self.view viewWithTag:901];
    
    CGRect beforeViewFrame  = view.frame;
    beforeViewFrame.origin.x = 320;
    view.frame = beforeViewFrame;
    
    view.hidden = NO;
    [UIView animateWithDuration: 0.7f delay: 0.0f
            options: UIViewAnimationOptionCurveEaseInOut
            animations: ^{
                CGRect afterViewFrame  = view.frame;
                afterViewFrame = view.frame;
                afterViewFrame.origin.x = 54;
                view.frame = afterViewFrame;
                
            }
            completion: ^(BOOL finished) {}];
}
- (IBAction)changePasswordViewClicked:(id)sender {
    UIView * view = [self.view viewWithTag:902];
    
    CGRect beforeViewFrame  = view.frame;
    beforeViewFrame.origin.x = 320;
    view.frame = beforeViewFrame;
    
    view.hidden = NO;
    [UIView animateWithDuration: 0.7f delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
                         CGRect afterViewFrame  = view.frame;
                         afterViewFrame = view.frame;
                         afterViewFrame.origin.x = 54;
                         view.frame = afterViewFrame;
                         
                     }
                     completion: ^(BOOL finished) {}];

}

- (IBAction)updatePasswordViewCloseButtonClicked:(id)sender {
    
    [self hideKeyBoard];
    
    UIView * view = [self.view viewWithTag:902];
    
    [UIView animateWithDuration: 0.6f delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
                         CGRect afterViewFrame  = view.frame;
                         afterViewFrame = view.frame;
                         afterViewFrame.origin.x = 320;
                         view.frame = afterViewFrame;
                         
                     }
                     completion: ^(BOOL finished) {
                         view.hidden = YES;
                     }];
}


- (IBAction)signOutButtonClicked:(id)sender {
    if ([[User getUser] signout]) {
        PlayerViewController * playViewController = (PlayerViewController *)self.revealViewController.frontViewController;
        
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
        [FBSession setActiveSession:nil];
        [self performSegueWithIdentifier:@"signOut" sender:self];
        
        [playViewController musicPause];
        [Player setCurrentMusic:NULL];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Sign out failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}
- (IBAction)LicenseViewCloseButtonClicked:(id)sender {
    
    UIView * view = [self.view viewWithTag:901];
    
    [UIView animateWithDuration: 0.6f delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
                         CGRect afterViewFrame  = view.frame;
                         afterViewFrame = view.frame;
                         afterViewFrame.origin.x = 320;
                         view.frame = afterViewFrame;
                         
                     }
                     completion: ^(BOOL finished) {
                         view.hidden = YES;
                     }];
}

- (void) hideKeyBoard
{
    [_aNewPasswordTextField resignFirstResponder];
    [_aOldPasswordTextField resignFirstResponder];
    [_passwordConfirmTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)passwordChangeButtonClicked:(id)sender {
    
    
    [self hideKeyBoard];
    
    NSString * oldPassword = _aOldPasswordTextField.text;
    NSString * newPassword = _aNewPasswordTextField.text;
    NSString * confirmPassword = _passwordConfirmTextField.text;
    
    UIAlertView * alert = NULL;
    
    
    
    
    if ([newPassword isEqualToString:confirmPassword] == NO) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Error Message" message: @"The two password not matched." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",  nil];
        
        [alert show];
    } else if([newPassword length] < 6) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Error Message" message: @"Password is less than 6 characters" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",  nil];
        
        [alert show];
        
    } else {
    
        User * user = [User getUser];
        
        if (!user) {
            alert = [[UIAlertView alloc] initWithTitle:@"Update Failed" message: @"Login information have been invalid. Please login again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",  nil];
            
            [alert show];
        } else {
            [user updatePasswordWithOldPassword:oldPassword NewPassword:newPassword];
        }
    }
}

- (IBAction)recoganizeViewCloseButtonClicked:(id)sender {
    
    UIView * recMenuView = [self.view viewWithTag:909];
    
    recMenuView.hidden = NO;
    
    [UIView animateWithDuration: 0.6f delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
                         CGRect afterViewFrame  = recMenuView.frame;
                         afterViewFrame = recMenuView.frame;
                         afterViewFrame.origin.x = 320;
                         recMenuView.frame = afterViewFrame;
                         
                     }
                     completion: ^(BOOL finished) {
                         recMenuView.hidden = YES;
                     }];
}
- (IBAction)versionButtonClicked:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Version" message: VERSION delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",  nil];
    
    [alert show];
}


@end
