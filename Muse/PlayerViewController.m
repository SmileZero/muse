//
//  ViewController.m
//  Muse
//
//  Created by zhu peijun on 2013/12/05.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//
#import "PlayerViewController.h"
#import "SWRevealViewController.h"
#import "User.h"
#import "Player.h"

#define degreesToRadians(x) -(M_PI * x / 180.0)

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
@property (weak, nonatomic) IBOutlet UIImageView *pauseImageV3;
@property (weak, nonatomic) IBOutlet UIImageView *pauseImageV2;
@property (weak, nonatomic) IBOutlet UILabel *musicTimeLabel;


@end

@implementation PlayerViewController


- (void)initPlayer
{
    _moviePlayer = [Player getMoviePlayer];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:   self
     selector:      @selector(moviePlaybackDidFinish:)
     name:          MPMoviePlayerPlaybackDidFinishNotification
     object         :_moviePlayer];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:   self
     selector:      @selector(moviePlaybackStateDidChange:)
     name:          MPMoviePlayerPlaybackStateDidChangeNotification
     object:        _moviePlayer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateTimeLine) userInfo:nil repeats:true];
    [_timer fire];
    
    
    _rotateTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(rotateLoadPicture) userInfo:nil repeats:true];
    [_rotateTimer fire];
    
    
    self.playStatus = 0;
}


- (void)rotateLoadPicture
{
    [_loadingImage setTransform:CGAffineTransformMakeRotation(degreesToRadians(_rotated))];
    
    _rotated += 1;
    
    if (_rotated > 360) {
        _rotated = 0;
    }
}

- (void)updateTimeLine
{
    if ([_moviePlayer playbackState] == 2) {
        return ;
    }
    
    int time = [_moviePlayer currentPlaybackTime];
    
    if (time < 0) {
        time = 0;
    }
    
    int minute = floor(time / 60);
    int second = time - minute * 60;

    _musicTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", minute, second];
}

- (void)loadCurrentMusicInformation
{
    _musicNameLabel.text = _currentMusic.title;
    _musicPictureImageView.image = _currentMusic.cover;
    _artistNameLabel.text = _currentMusic.artist;
}

- (void)loadMusic
{
    XiamiConnection * conn = [[XiamiConnection alloc] init];
    srand((int)conn);
    
    _currentMusic = [conn getMusicWithIdentifier:[NSString stringWithFormat:@"%d", rand() % 5000]];
    [Player setCurrentMusic:_currentMusic];
    
    _moviePlayer.contentURL = [NSURL URLWithString:_currentMusic.musicURL];
    _musicNameLabel.text = _currentMusic.title;
    _musicPictureImageView.image = _currentMusic.cover;
    _artistNameLabel.text = _currentMusic.artist;
    
    [self.moviePlayer play];
    
    _playStatus = 1;
    
    [Player setCurrentPlayStatus:_playStatus];
}

- (void)viewDidLoad
{
    
    if ([User getUser]) {
        if ([[User getUser] signinWithRememberToken]) {
        }
        else{
            NSLog(@"remember_token is incorrent");
        }
    }

    [super viewDidLoad];
    [self initPlayer];
    
    if ([Player getCurrentMusic] == NULL) {
        [self loadMusic];
    } else {
        _currentMusic = [Player getCurrentMusic];
        _playStatus = [Player getCurrentPlayStatus];
        
        NSLog(@"%d", _playStatus);
        [self loadCurrentMusicInformation];
    }
    
    
    
    
    [_settingButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    NSLog(@"clicked");
    
    if (self.playStatus == 0) {
        [Player setCurrentPlayStatus:_playStatus];
        self.playStatus = 1;
        [self moviePlay];
    } else {
        [Player setCurrentPlayStatus:_playStatus];
        self.playStatus = 0;
        [self moviePause];
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

- (void)moviePlaybackStateDidChange:(NSNotification *)notification {
    
    NSLog(@"state change");
    
    //NSLog(@"moviePlaybackStateDidChange = %f", [_moviePlayer currentPlaybackTime]);
    
    int isPlay = [_moviePlayer playbackState];
    
    if (isPlay == 2) {
        _pauseImageV2.hidden = YES;
        _pauseImageV3.hidden = NO;
        
    } else {
        _pauseImageV2.hidden = NO;
        _pauseImageV3.hidden = YES;
    }
    
    
    NSLog(@"C: %d M:%d", _playStatus, isPlay);
    
    if (isPlay == 2 && _playStatus == 1) {
        NSLog(@"try once!");
        
        [self performSelector: @selector(moviePlay) withObject:nil afterDelay:3];
    }
}

- (void)moviePlay
{
    if ([_moviePlayer playbackState] == 2) {
        [_moviePlayer play];
    }
}

- (void)moviePause
{
    if ([_moviePlayer playbackState] == 1) {
        [_moviePlayer pause];
    }
}

@end
