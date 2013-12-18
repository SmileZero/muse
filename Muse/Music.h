//
//  Music.h
//  Muse
//
//  Created by yan runchen on 2013/12/18.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "ServerConnection.h"
#import <Foundation/Foundation.h>

@interface Music : NSObject
@property(strong, nonatomic) NSNumber *local_id;
@property(strong, nonatomic) NSNumber *music_id;
@property(strong, nonatomic) NSNumber *resource_id;
@property(strong, nonatomic) NSString *location;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *lyric;
@property(strong, nonatomic) NSString *artist_id;
@property(strong, nonatomic) NSString *artist_name;
@property(strong, nonatomic) NSString *album_id;
@property(strong, nonatomic) NSString *album_name;
@property(strong, nonatomic) NSString *cover_url;
@property(strong, nonatomic) NSNumber *mark;

+ (Music *)musicWithLocalId:(NSNumber *)local_id musicId:(NSNumber *)music_id name:(NSString *)name resourceId:(NSNumber *)resource_id location:(NSString *)location lyric:(NSString *)lyric artistId:(NSString *)artist_id artistName:(NSString *)artist_name albumId:(NSString *)album_id albumName:(NSString *)album_name coverUrl:(NSString *)cover_url mark:(NSNumber *)mark;

+ (Music *)searchByName:(NSString *)name andArtistName:(NSString *)artist_name;

+ (UIImage *) getCoverWithURL:(NSString *) url;

@end
