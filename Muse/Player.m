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
static int currentPlayListIndex = 0;

static NSMutableArray * playList = NULL;

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
    playList = [NSMutableArray arrayWithArray:list];
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

+ (void) shuffle
{
    int n = (int)[playList count];
    
    srand((int)&n);
    
    for(int i = 0;i < n; i++) {
        int index = rand() % (n - i);
        id music = playList[n - i - 1];
        playList[n - i - 1] = playList[index];
        playList[index] = music;
    }
}

+ (NSString *)getNextMusicFromPlayList
{
    int n = (int)[playList count];
    
    currentPlayListIndex = (currentPlayListIndex + 1) % n;
    
    if (currentPlayListIndex == n - 1) {
        [self shuffle];
    }
    
    return [NSString stringWithFormat:@"%@", playList[currentPlayListIndex]];
}

+ (void) addMusicToCurrentPlayListWithIdentifier: (NSString *) identifier
{
    [playList addObject:identifier];
}

+ (void) removeMusicFromCurrentPlayList:(XiamiObject *) music
{
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    
    int n = (int)[playList count];
    
    for (int i = 0; i < n; i++) {
        NSString * playListMusicId = [NSString stringWithFormat:@"%@", playList[i]];
        NSString * musicId = [NSString stringWithFormat:@"%@", music.identifier];
        
        NSLog(@"%@ %@", playListMusicId, musicId);
        
        if ([playListMusicId isEqualToString:musicId]) {
            
            [array addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    int m = (int)[array count];
    
    for (int j = m - 1; j >= 0; j--) {
        NSLog(@"remove: %d",(int) [array[j] integerValue]);
        [playList removeObjectAtIndex:[array[j] integerValue]];
    }
    
    NSLog(@"%d", (int)[playList count]);
}



@end
