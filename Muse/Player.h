//
//  Player.h
//  Muse
//
//  Created by zhu peijun on 2013/12/16.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "XiamiObject.h"

@interface Player : NSObject

+ (MPMoviePlayerController *) getMoviePlayer;

+ (XiamiObject *) getCurrentMusic;
+ (void) setCurrentMusic: (XiamiObject *) music;


+ (int) getCurrentPlayStatus;
+ (void) setCurrentPlayStatus: (int) playStatus;

+ (void) stopMoviePlayer;
+ (void) playMoviePlayer;

+ (void) setPlayType: (int) type;
+ (int) getPlayType;
+ (void) setPlayList: (NSArray *) list : (int) index;
+ (NSArray *) getPlayList;
+ (void) updatePlayListDataToFav;


@end
