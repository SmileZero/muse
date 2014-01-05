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
#import "Tag.h"
#import "TagViewController.h"

#define degreesToRadians(x) -(M_PI * x / 180.0)

@interface PlayerViewController ()
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
@property (weak, nonatomic) IBOutlet UIImageView *loadingImageNegative;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImageMask;
@property (weak, nonatomic) IBOutlet UILabel *loadingText;

@property (weak, nonatomic) IBOutlet UIImageView *pauseImageV3;
@property (weak, nonatomic) IBOutlet UIImageView *pauseImageV2;
@property (weak, nonatomic) IBOutlet UILabel *musicTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *disloveButton;

@property (weak, nonatomic) IBOutlet UIImageView *loveAnimationImageView;

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
    
    
    self.currentPlayStatus = 0;
}


- (void)rotateLoadPicture
{
    [_loadingImage setTransform:CGAffineTransformMakeRotation(degreesToRadians(_rotated))];
    [_loadingImageNegative setTransform:CGAffineTransformMakeRotation(degreesToRadians(-_rotated))];
    
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
    
    NSString * isLike = _currentMusic.mark;
    
    //NSLog(@"%@", isLike);
    
    [self setMarkButtonWithStatus:[isLike isEqualToString:@"0"]];
   
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:_currentMusic.title forKey:MPMediaItemPropertyTitle];
        [dict setObject:_currentMusic.artist forKey:MPMediaItemPropertyArtist];
        [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:_currentMusic.cover] forKey:MPMediaItemPropertyArtwork];
        
        //[[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
    
    _musicPictureImageView.layer.opacity = 0.5;
    
    [UIView animateWithDuration:2 delay:0.0
            options:0
            animations:^{
                _musicPictureImageView.layer.opacity = 1;
         } completion:^(BOOL finished) {
             
    }];
    
}

- (void)setDisplayView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float screenWidth = screenRect.size.width;
    float screenHeight = screenRect.size.height;
    
    NSLog(@"screen width: %f, height: %f", screenWidth, screenHeight);
    
    _pauseImageV2.hidden = YES;
    _pauseImageV3.hidden = NO;
    
    if (screenHeight <= 481) {
        
        float PIC_Y_POS_DELTA = 20;
        float PLAY_Y_BUTTON_POS_DELTA = 40;
        float NAME_Y_LABEL_DELTA = 60;
        float ARTIST_Y_LABEL_DELTA = 70;
        float SETTING_Y_BUTTON_DELTA = 0;
        float LOVE_Y_BUTTON_DELTA = 80;
        
        
        CGRect loveAnimationImageViewFrame = _loveAnimationImageView.frame;
        loveAnimationImageViewFrame.origin.y -= LOVE_Y_BUTTON_DELTA;
        [_loveAnimationImageView setFrame:loveAnimationImageViewFrame];
    
        CGRect loadingImageNegativeFrame = _loadingImageNegative.frame;
        loadingImageNegativeFrame.origin.y -= PIC_Y_POS_DELTA;
        [_loadingImageNegative setFrame:loadingImageNegativeFrame];
        
        CGRect loadingImageMaskFrame = _loadingImageMask.frame;
        loadingImageMaskFrame.origin.y -= PIC_Y_POS_DELTA;
        [_loadingImageMask setFrame:loadingImageMaskFrame];
        
        CGRect loadingTextFrame = _loadingText.frame;
        loadingTextFrame.origin.y -= PIC_Y_POS_DELTA;
        [_loadingText setFrame:loadingTextFrame];
        
        
        CGRect musicPictureImageViewFrame = _musicPictureImageView.frame;
        musicPictureImageViewFrame.origin.y -= PIC_Y_POS_DELTA;
        [_musicPictureImageView setFrame:musicPictureImageViewFrame];
        
        CGRect musicPictureMaskImageViewFrame = _musicPictureMaskImageView.frame;
        musicPictureMaskImageViewFrame.origin.y -= PIC_Y_POS_DELTA;
        [_musicPictureMaskImageView setFrame:musicPictureMaskImageViewFrame];
        
        CGRect musicPictureBorderImageViewFrame = _musicPictureBorderImageView.frame;
        musicPictureBorderImageViewFrame.origin.y -= PIC_Y_POS_DELTA;
        [_musicPictureBorderImageView setFrame:musicPictureBorderImageViewFrame];
        
        CGRect menuButtonFrame = _menuButton.frame;
        menuButtonFrame.origin.y -= SETTING_Y_BUTTON_DELTA;
        [_menuButton setFrame:menuButtonFrame];
        
        CGRect settingButtonFrame = _settingButton.frame;
        settingButtonFrame.origin.y -= SETTING_Y_BUTTON_DELTA;
        [_settingButton setFrame:settingButtonFrame];
        
        CGRect nextButtonFrame = _nextButton.frame;
        nextButtonFrame.origin.y -= PLAY_Y_BUTTON_POS_DELTA;
        [_nextButton setFrame:nextButtonFrame];
        
        CGRect lastButtonFrame = _lastButton.frame;
        lastButtonFrame.origin.y -= PLAY_Y_BUTTON_POS_DELTA;
        [_lastButton setFrame:lastButtonFrame];
        
        CGRect pasueButtonFrame = _pasueButton.frame;
        pasueButtonFrame.origin.y -= PLAY_Y_BUTTON_POS_DELTA;
        [_pasueButton setFrame:pasueButtonFrame];
        
        CGRect musicNameLabelFrame = _musicNameLabel.frame;
        musicNameLabelFrame.origin.y -= NAME_Y_LABEL_DELTA;
        [_musicNameLabel setFrame:musicNameLabelFrame];
        
        CGRect artistNameLabelFrame = _artistNameLabel.frame;
        artistNameLabelFrame.origin.y -= ARTIST_Y_LABEL_DELTA;
        [_artistNameLabel setFrame:artistNameLabelFrame];
        
        CGRect loveButtonFrame = _loveButton.frame;
        loveButtonFrame.origin.y -= LOVE_Y_BUTTON_DELTA;
        [_loveButton setFrame:loveButtonFrame];
        
        CGRect hateButtonFrame = _hateButton.frame;
        hateButtonFrame.origin.y -= LOVE_Y_BUTTON_DELTA;
        [_hateButton setFrame:hateButtonFrame];
        
        CGRect loadingImageFrame = _loadingImage.frame;
        loadingImageFrame.origin.y -= PIC_Y_POS_DELTA;
        [_loadingImage setFrame:loadingImageFrame];
        
        CGRect pauseImageV3Frame = _pauseImageV3.frame;
        pauseImageV3Frame.origin.y -= PLAY_Y_BUTTON_POS_DELTA;
        [_pauseImageV3 setFrame:pauseImageV3Frame];
        
        CGRect pauseImageV2Frame = _pauseImageV2.frame;
        pauseImageV2Frame.origin.y -= PLAY_Y_BUTTON_POS_DELTA;
        [_pauseImageV2 setFrame:pauseImageV2Frame];
        
        CGRect musicTimeLabelFrame = _musicTimeLabel.frame;
        musicTimeLabelFrame.origin.y -= PLAY_Y_BUTTON_POS_DELTA;
        [_musicTimeLabel setFrame:musicTimeLabelFrame];
        
        CGRect disloveButtonFrame = _disloveButton.frame;
        disloveButtonFrame.origin.y -= LOVE_Y_BUTTON_DELTA;
        [_disloveButton setFrame:disloveButtonFrame];
    }
    
    
    NSMutableArray * loveAnimationImages = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 12; i++) {
        NSString * imageName = [NSString stringWithFormat:@"am_love_000%02d.png", i];
        [loveAnimationImages addObject:[UIImage imageNamed:imageName]];
    }
    _loveAnimationImageView.animationImages = loveAnimationImages;
    _loveAnimationImageView.animationDuration = 0.4f;
    _loveAnimationImageView.animationRepeatCount = 1;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setMarkButtonWithStatus: (BOOL) status
{
    if (status) {
        _loveButton.hidden = YES;
        _disloveButton.hidden = NO;
    } else {
        _loveButton.hidden = NO;
        _disloveButton.hidden = YES;
    }
}


- (void)loadMusicWithIdentifier:(NSString *) identifier
{
    XiamiConnection * conn = [[XiamiConnection alloc] init];
    srand((int)conn);
    
    XiamiObject * music = NULL;

    music = [conn getMusicWithIdentifier:identifier];
    
    
    if (!music) {
        [self performSelectorOnMainThread:@selector(internetErrorAlert)withObject:nil waitUntilDone:YES];
    } else {
        _currentMusic = music;
        [Player setCurrentMusic:_currentMusic];
        //_moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        _moviePlayer.contentURL = [NSURL URLWithString:_currentMusic.musicURL];
        
        [self loadCurrentMusicInformation];
        
        
        
        [self.moviePlayer play];
        
        _currentPlayStatus = 1;
        
        [Player setCurrentPlayStatus:_currentPlayStatus];
    }
}

- (void)loadMusic
{
    self.currentloadingState = 1;
    
    [_moviePlayer stop];
    
    [self showLoadingView];
    [self disableButton];
    [self performSelectorInBackground:@selector(loadMusicInTheBackgroundThread) withObject:nil];
}


- (void)loadMusicInTheBackgroundThread
{
    XiamiConnection * conn = [[XiamiConnection alloc] init];
    srand((int)conn);
    
    XiamiObject * music = NULL;
    
    int playType = [Player getPlayType];
    
    if (playType == 0) {
        music = [conn getRecemmondMusic];
    } else {
        NSArray * ar = [Player getPlayList];
        
        _playList = ar;
        
        int n = (int)[_playList count];
        
        if (n == 0) {
            TagViewController * tagViewController = (TagViewController *)self.revealViewController.rearViewController;
            
            tagViewController.currentIndex = [TagViewController getGuessTagIndex];
            [tagViewController realoadTableData];
            
            [Player setPlayType: 0];
            music = [conn getRecemmondMusic];
            
        } else {
            music = [conn getMusicWithIdentifier:[Player getNextMusicFromPlayList]];
        }
    }
    
    NSLog(@"%@", music.identifier);
    
    _currentMusic = music;
    [Player setCurrentMusic:_currentMusic];
    
    //[self loadCurrentMusicInformation];
    
    //[self.moviePlayer play];
    
    _currentloadingState = 0;
    
    NSLog(@"%@", music);
    
    [Player setCurrentPlayStatus:_currentPlayStatus];
    
    [self performSelectorOnMainThread:@selector(hideLoadingView)withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(enableButton)withObject:nil waitUntilDone:YES];
    
    if (_currentMusic) {
        [self performSelectorOnMainThread:@selector(loadCurrentMusicInformation) withObject:nil waitUntilDone:YES];

        [self performSelectorOnMainThread:@selector(startPlayer) withObject:nil waitUntilDone:YES];

       
    } else {
        [self performSelectorOnMainThread:@selector(internetErrorAlert)withObject:nil waitUntilDone:YES];
    }
}

- (void) internetErrorAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
     message:@"Can not connect to the server."
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    
    [alert show];
}

- (void) startPlayer
{
    
    NSLog(@"%d", _moviePlayer.playbackState);
    //[_moviePlayer pause];
    //_moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    
    self.moviePlayer.contentURL = [NSURL URLWithString:_currentMusic.musicURL];
    
    [_moviePlayer play];
    
    _currentPlayStatus = 1;
}

- (IBAction)unLoveMusicButtonClicked:(id)sender {
    
    XiamiConnection * conn = [[XiamiConnection alloc] init];
    BOOL result = [conn disLoveSongWithIdentifier:_currentMusic.identifier];
    
    
    if (result) {
        [self setMarkButtonWithStatus:YES];
        [self updateTagView];
    }
    
}
- (IBAction)hateMusicButtonClicked:(id)sender {
    
    XiamiConnection * conn = [[XiamiConnection alloc] init];
    BOOL result = [conn hateSongWithIdentifier:_currentMusic.identifier];
    
    if (result) {
        [self updateTagView];
        [self loadMusic];
    }
    
}


- (IBAction)loveMusicButtonClicked:(id)sender {
    
    XiamiConnection * conn = [[XiamiConnection alloc] init];
    BOOL result = [conn loveSongWithIdentifier:_currentMusic.identifier];
    
    
    if (result) {
        [self setMarkButtonWithStatus:NO];
        [self updateTagView];
        [self.loveAnimationImageView startAnimating];
    }
}



- (void)viewDidLoad
{
    //[Tag getAll]

    [super viewDidLoad];
    [self initPlayer];
    
    NSLog(@"player view did load");
    
    _currentloadingState = 0;
    
    if ([Player getCurrentMusic] == NULL) {
        NSLog(@"Load new music!");
        [self loadMusic];
    } else {
        
        _moviePlayer = [Player getMoviePlayer];
        
        _currentMusic = [Player getCurrentMusic];
        _currentPlayStatus = [Player getCurrentPlayStatus];
        
        NSLog(@"Load %d", _currentPlayStatus);
        [self loadCurrentMusicInformation];
    }
    
    [_settingButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _pauseImageV2.hidden = NO;
    _pauseImageV3.hidden = YES;
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    [self setDisplayView];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self musicPlay];
                break;
            case UIEventSubtypeRemoteControlPause:
                [self musicPause];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self loadMusic];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if (_moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
                    [self musicPause];
                }
                else {
                    [self musicPlay];
                }
                break;
            default:
                break;
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pauseButtonClicked:(id)sender {
    
    NSLog(@"clicked");
    if (self.currentPlayStatus == 0) {
        self.currentPlayStatus = 1;
        [self moviePlay];
    } else {
        self.currentPlayStatus = 0;
        [self moviePause];
    }
    
    [Player setCurrentPlayStatus:_currentPlayStatus];
    
    NSLog(@"statuse change to %d", _currentPlayStatus);
}
- (IBAction)nextButtonClicked:(id)sender {
    _currentPlayStatus = 0;
    [self loadMusic];
}


- (void)moviePlaybackDidFinish:(NSNotification *)notification {
    NSLog(@"moviePlaybackDidFinish = %@",[notification userInfo]);
    
    if (_currentloadingState == 1) {
        return ;
    }
    
    if ([[[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue] == MPMoviePlaybackStateStopped) {
        [self loadMusic];
    }
}


- (void)moviePlaybackStateDidChange:(NSNotification *)notification {
    
    //NSLog(@"state change");
    
    //NSLog(@"moviePlaybackStateDidChange = %f", [_moviePlayer currentPlaybackTime]);
    
    int isPlay = (int)[_moviePlayer playbackState];
    float playTime = [_moviePlayer currentPlaybackTime];
    
    if (isPlay == 2) {
        _pauseImageV2.hidden = YES;
        _pauseImageV3.hidden = NO;
        
    } else {
        _pauseImageV2.hidden = NO;
        _pauseImageV3.hidden = YES;
    }
    
    
    NSLog(@"C: %d M:%d T: %f", _currentPlayStatus, isPlay, playTime);
    
    if (isPlay == 2 && _currentPlayStatus == 1 && playTime > 4) {
        NSLog(@"try once!");
        
        [self performSelector: @selector(moviePlay) withObject:nil afterDelay:5];
    }
}


- (void) updateTagView
{
    [Tag reloadFav];
    
    TagViewController * tagViewController = (TagViewController * ) self.revealViewController.rearViewController;

    [tagViewController realoadTableData];

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

- (void)musicPlay
{
    if (_currentPlayStatus == 0) {
        //[self enableButton];
        
        self.currentPlayStatus = 1;
        [Player setCurrentPlayStatus:_currentPlayStatus];
        [_moviePlayer play];
    }
}

- (void)musicPause
{
    
    NSLog(@"current play status: %d", _currentPlayStatus );
    
    if (_currentPlayStatus == 1) {
        
        //[self disableButton];
        
        NSLog(@"music pause");
        
        _currentPlayStatus = 0;
        [Player setCurrentPlayStatus:_currentPlayStatus];
        [_moviePlayer pause];
    }
}

- (void)musicStop
{
    if ([_moviePlayer playbackState] == 1) {
        [_moviePlayer pause];
        self.currentPlayStatus = 0;
        [Player setCurrentMusic:NULL];
    }
}

- (void)stopMusic
{
    [_moviePlayer stop];
}


- (void) showLoadingView
{
    _loadingImageMask.layer.opacity = 1;
    _loadingImageNegative.layer.opacity = 1;
    _loadingText.layer.opacity = 1;
    
    //_loadingImage.hidden = NO;
    _loadingImageMask.hidden = NO;
    _loadingImageNegative.hidden = NO;
    _loadingText.hidden = NO;
}

- (void) hideLoadingView
{
    //_loadingImage.hidden = YES;
    
    [UIView animateWithDuration:0.8 delay:0.0
                        options:0
                     animations:^{
                         _loadingImageMask.layer.opacity = 0;
                         _loadingImageNegative.layer.opacity = 0;
                         _loadingText.layer.opacity = 0; }
                     completion:^(BOOL finished) {
                         _loadingImageMask.hidden = YES;
                         _loadingImageNegative.hidden = YES;
                         _loadingText.hidden = YES;
    }];
    
}

- (void) disableButton
{
    _pasueButton.enabled = NO;
    _nextButton.enabled = NO;
    _loveButton.enabled = NO;
    _hateButton.enabled = NO;
    _disloveButton.enabled = NO;
}

- (void) enableButton
{
    _pasueButton.enabled = YES;
    _nextButton.enabled = YES;
    _loveButton.enabled = YES;
    _hateButton.enabled = YES;
    _disloveButton.enabled = YES;
}

@end
