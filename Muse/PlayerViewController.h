//
//  ViewController.h
//  Muse
//
//  Created by zhu peijun on 2013/12/05.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "XiamiObject.h"
#import "XiamiConnection.h"

@interface PlayerViewController : UIViewController

@property (weak, nonatomic) MPMoviePlayerController * moviePlayer;

@property (weak, nonatomic) XiamiObject * currentMusic;

@property (weak, nonatomic) NSTimer * timer;

@property (weak, nonatomic) NSTimer * rotateTimer;

@property int rotated;
@property int currentPlayStatus;

@property (weak, nonatomic) NSArray * playList;

- (void)loadMusic;
- (void)musicPlay;
- (void)musicPause;

@end
