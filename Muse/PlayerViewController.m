//
//  ViewController.m
//  Muse
//
//  Created by zhu peijun on 2013/12/05.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "PlayerViewController.h"

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


@end

@implementation PlayerViewController


- (void)setup
{
    self.playStatus = 0;
}

- (void)setupView
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _moviePlayer = [[MPMoviePlayerController alloc] init];
    
    [self.view addSubview:_moviePlayer.view];
    
    _moviePlayer.contentURL = [NSURL URLWithString:@"http://m1.file.xiami.com/1/664/56664/310797/3441531_248862_l.mp3"];
    
    

    [_moviePlayer play];
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

@end
