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
static int currentIndex = -1;

static NSArray * playList = NULL;

// play type
// 0 is recommended music
// 1 is play list's music

static int playType = 0;


+ (MPMoviePlayerController *) getMoviePlayer
{
    if (moviePlayer == NULL) {
        moviePlayer = [[MPMoviePlayerController alloc] init];
        //[moviePlayer prepareToPlay];
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
    //NSLog(@"set: %@", currentMusic.title);
}


+ (int) getCurrentPlayStatus
{
    return currentPlayStatus;
}

+ (void) setCurrentPlayStatus:(int)playStatus
{
    currentPlayStatus = playStatus;
}

+ (void) setPlayType: (int) type
{
    playType = type;
}

+ (void) setPlayList: (NSArray *) list : (int) index
{
    playList = list;
    currentIndex = index;
}

+ (int) getPlayType
{
    return playType;
}

+ (NSArray *) getPlayList
{
    return playList;
}

+ (void) stopMoviePlayer
{
    [moviePlayer pause];
}


+ (void) playMoviePlayer
{
    [moviePlayer play];
}


+ (void) updatePlayListDataToFav
{
    if (currentIndex != 1) {
        return ;
    }
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"TagSource.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"TagSource" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSArray * tagArray = (NSArray *)[NSPropertyListSerialization
                            propertyListFromData:plistXML
                            mutabilityOption:NSPropertyListMutableContainersAndLeaves
                            format:&format
                            errorDescription:&errorDesc];
    
    [Player setPlayList:tagArray[1][@"MusicIds"] : 1];
}


@end
