//
//  ViewController.m
//  Muse
//
//  Created by zhu peijun on 2013/12/05.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//
#import "PlayerViewController.h"
#import "SWRevealViewController.h"

@interface PlayerViewController ()
@property int playStatus;


@property (weak, nonatomic) IBOutlet UIImageView *musicPictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *musicPictureMaskImageView;
@property (weak, nonatomic) IBOutlet UIImageView *musicPictureBorderImageView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UIButton *pasueButton;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *hateButton;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;


@end

@implementation PlayerViewController


- (void)initPlayer
{
    _moviePlayer = [[MPMoviePlayerController alloc] init];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:   self
     selector:      @selector(moviePlaybackDidFinish:)
     name:          MPMoviePlayerPlaybackDidFinishNotification
     object         :_moviePlayer];
    
    self.playStatus = 0;
}



- (void)loadMusic
{
    XiamiConnection * conn = [[XiamiConnection alloc] init];
    
    _currentMusic = [conn getMusicWithIdentifier:[NSString stringWithFormat:@"%d", rand() % 5000]];
    _moviePlayer.contentURL = [NSURL URLWithString:_currentMusic.musicURL];
    _musicNameLabel.text = _currentMusic.title;
    _musicPictureImageView.image = _currentMusic.cover;
    _artistNameLabel.text = _currentMusic.artist;
    [_moviePlayer play];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPlayer];
    [self loadMusic];
    
    
    [_settingButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pauseButtonClicked:(id)sender {
    
    if (self.playStatus == 0) {
        self.playStatus = 1;
        [_moviePlayer pause];
    } else {
        self.playStatus = 0;
        [_moviePlayer play];
    }
    
}
- (IBAction)nextButtonClicked:(id)sender {
    
    [self loadMusic];
}


- (void)moviePlaybackDidFinish:(NSNotification *)notification {
    NSLog(@"moviePlaybackDidFinish = %@",[notification userInfo]);
    if ([[[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue] == MPMoviePlaybackStateStopped) {
        [self loadMusic];
    }
}

@end
