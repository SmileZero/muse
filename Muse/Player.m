//
//  Player.m
//  Muse
//
//  Created by zhu peijun on 2013/12/16.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "Player.h"


@implementation Player

static MPMoviePlayerController * moviePlayer = NULL;
static XiamiObject * currentMusic = NULL;
static int currentPlayStatus = 0;

+ (MPMoviePlayerController *) getMoviePlayer
{
    if (moviePlayer == NULL) {
        moviePlayer = [[MPMoviePlayerController alloc] init];
        [moviePlayer prepareToPlay];
        NSLog(@"player init");
    }
    return moviePlayer;
}

+ (XiamiObject *) getCurrentMusic
{
    return currentMusic;
}

+ (void) setCurrentMusic: (XiamiObject *) music
{
    currentMusic = music;
    NSLog(@"set: %@", currentMusic.title);
    
}


+ (int) getCurrentPlayStatus
{
    return currentPlayStatus;
}

+ (void) setCurrentPlayStatus:(int)playStatus
{
    currentPlayStatus = playStatus;
}





@end
