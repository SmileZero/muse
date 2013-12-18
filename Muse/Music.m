//
//  Music.m
//  Muse
//
//  Created by yan runchen on 2013/12/18.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "Music.h"

@implementation Music

+ (Music *)musicWithLocalId:(NSNumber *)local_id musicId:(NSNumber *)music_id name:(NSString *)name resourceId:(NSNumber *)resource_id location:(NSString *)location lyric:(NSString *)lyric artistId:(NSString *)artist_id artistName:(NSString *)artist_name albumId:(NSString *)album_id albumName:(NSString *)album_name coverUrl:(NSString *)cover_url mark:(NSNumber *)mark
{
    Music *music= [[Music alloc] init];
    music.local_id = local_id;
    music.music_id = music_id;
    music.name = name;
    music.resource_id = resource_id;
    music.location = location;
    music.lyric = lyric;
    music.artist_id = artist_id;
    music.artist_name = artist_name;
    music.album_id = album_id;
    music.album_name = album_name;
    music.cover_url = cover_url;
    music.mark = mark;
    return music;
}

+ (UIImage *) getCoverWithURL:(NSString *) url
{
    NSData * data = [ServerConnection getRequestToURL:url];
    UIImage * cover = [UIImage imageWithData:data];
    return cover;
}

+ (Music *)searchByName:(NSString *)name andArtistName:(NSString *)artist_name
{
    
    NSString * url = [NSString stringWithFormat:@"%@/musics/search.json?musicName=%@&artistName=%@", SERVER_URL, name, artist_name];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", url);
    
    NSData *data = [ServerConnection getRequestToURL:url];
    
    if (!data) {
        NSLog(@"connection error!");
        return nil;
    }
    
    NSError *error = nil;
    NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!resultDictionary) {
        NSLog(@"NSJSONSerialization error:%@ ", error);
        return nil;
    }
    if ([resultDictionary[@"status"]  isEqual: @"ok"]) {
        NSDictionary *musicDictionary = resultDictionary[@"music"];
        NSString *coverDefaultSizeURL = musicDictionary[@"cover_url"];
        int length = [coverDefaultSizeURL length];
        NSString * coverHeader = [coverDefaultSizeURL substringToIndex: length - 4];
        NSString * coverType = [coverDefaultSizeURL substringWithRange:NSMakeRange(length - 4, 4)];
        
        NSString * coverURL = [NSString stringWithFormat:@"%@%@%@", coverHeader, @"_2", coverType];
        
        Music *music = [Music musicWithLocalId:musicDictionary[@"id"]  musicId:musicDictionary[@"music_id"]  name:musicDictionary[@"name"]  resourceId:musicDictionary[@"resource_id"]  location:musicDictionary[@"location"] lyric:musicDictionary[@"lyric"] artistId:musicDictionary[@"artist_id"] artistName:musicDictionary[@"artist_name"] albumId:musicDictionary[@"album_id"] albumName:musicDictionary[@"album_name"] coverUrl: coverURL mark:musicDictionary[@"mark"]];
        
        return music;
    }
    else{
        NSLog(@"Can't find the music %@---%@", name, artist_name);
        return nil;
    }
    
    return nil;
}

@end
