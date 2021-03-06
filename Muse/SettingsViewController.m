//
//  SettingsViewController.m
//  Muse
//
//  Created by yan runchen on 2013/12/13.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "SWRevealViewController.h"
#import "User.h"
#import "ServerConnection.h"
#import "Player.h"
#import "FPResponse.h"
#import <GracenoteMusicID/GNConfig.h>
#import <GracenoteMusicID/GNOperations.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SettingsViewController ()
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
@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    self.config = [GNConfig init:@"4388096-F18341100713290DF7B092A14D9627E6"];
    
    
    _containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    CGRect recogContainerRect = CGRectMake(10.0, 150.0, 300.0, 300.0);
    _recogContainer = [[UIView alloc] initWithFrame:recogContainerRect];
    _containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"border.png"] drawInRect:_recogContainer.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _recogContainer.backgroundColor = [UIColor colorWithPatternImage:image];
    [_containerView addSubview:_recogContainer];
    
    CGRect recogRect = CGRectMake(22.0, 28.0, 252.0, 250.0);
    _recogView = [[UIView alloc] initWithFrame:recogRect];
    _recogView.backgroundColor = [UIColor colorWithWhite:0.18f alpha:1.0f];
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
    [_recogBtn setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [_recogBtn setTitle:@"TOUCH TO BEGIN" forState:UIControlStateNormal];
    [_recogBtn.titleLabel setFont:[UIFont fontWithName:@"Copperplate" size:20]];
    // add targets and actions
    [_recogBtn addTarget:self action:@selector(recogBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    [_recogView addSubview:_recogBtn];
    
    _musicName = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
    _musicName.text = @"Music Title";
    [_musicName setTextColor:[UIColor colorWithWhite:0.5f alpha:1]];
    _musicName.font = [UIFont fontWithName:@"Copperplate" size:20];
    [_recogView addSubview:_musicName];
    
    _artistName = [[UILabel alloc] initWithFrame:CGRectMake(23, 25, 200, 30)];
    _artistName.text = @"Artist Name";
    [_artistName setTextColor:[UIColor colorWithWhite:0.5f alpha:1]];
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
    
    _menuItems = @[@"user",@"recognize"];
    _animating = NO;
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
    if (indexPath.row == 0) {
        return 103;
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
    
    if (indexPath.row == 0) {
        UIView *scrollView = cell.subviews[0];
        UIView *content = scrollView.subviews[0];
        UIImageView *imageView = content.subviews[0];
        
        imageView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        //imageView.layer.borderColor = [UIColor colorWithWhite:0.2f alpha:1.0f].CGColor;
        //imageView.layer.borderWidth = 7.0f;
        
        UILabel *labelView = content.subviews[1];
        
        if ([User getUser]) {
            
            NSData *data = [ServerConnection getRequestToURL:[NSString stringWithFormat:@"%@/%@", SERVER_URL, [User getUser].avatar]];
            UIImage *avatar = [UIImage imageWithData:data];
            imageView.image = avatar;
            labelView.text = [User getUser].name;
            //cell.userInteractionEnabled = NO;
        }
    }
    else if (indexPath.row == 1){
    }
    
    return cell;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
//    if ([segue.identifier isEqualToString:@"showSignIn"]) {
//        SignInView *signin = (SignInView*)segue.destinationViewController;
//    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //where indexPath.row is the selected cell
    if (indexPath.row == 1) {
        [self.view.window addSubview:_containerView];
        
        NSError *error = nil;
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(sessionDidInterrupt:) name:AVAudioSessionInterruptionNotification object:nil];
        [center addObserver:self selector:@selector(sessionRouteDidChange:) name:AVAudioSessionRouteChangeNotification object:nil];
        
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
        [audioSession setActive:YES error: &error];

        //[Player stopMoviePlayer];
    }
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
    [[AVAudioSession sharedInstance] setActive:NO error: nil];
    //[Player playMoviePlayer];

}

- (void)containerViewTapped:(UITapGestureRecognizer *)gr {
    UIView *containerView = (UIImageView *)gr.view;
    [self musicInfoHide];
    [containerView removeFromSuperview];
    //[Player playMoviePlayer];
    [[AVAudioSession sharedInstance] setActive:NO error: nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
