//
//  XiamiConnection.m
//  Muse
//
//  Created by zhu peijun on 2013/12/13.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//


#import "XiamiConnection.h"


//#define SERVER_URL @"http://172.30.4.19/musics/"
//#define SERVER_URL_MUSIC @"http://localhost:3000/musics/"
#define SERVER_URL_MUSIC @"http://192.168.1.10:3000/musics/"

@implementation XiamiConnection


- (XiamiObject *)getMusicWithIdentifier:(NSString *)identifier
{
    
    
    NSString * url = [NSString stringWithFormat: @"%@%@.json", SERVER_URL_MUSIC, identifier];
    
    NSData * data = [ServerConnection getRequestToURL:url];
    
    NSError * error = NULL;
    NSDictionary * feedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSDictionary * dic = [feedData objectForKey:@"music"];
    
    
    XiamiObject * musicInfo = [[XiamiObject alloc] init];
    
    
    
    NSString * coverDefaultSizeURL = [dic objectForKey:@"cover_url"];
    int length = [coverDefaultSizeURL length];
    NSString * coverHeader = [coverDefaultSizeURL substringToIndex: length - 4];
    NSString * coverType = [coverDefaultSizeURL substringWithRange:NSMakeRange(length - 4, 4)];
    
    NSString * coverURL = [NSString stringWithFormat:@"%@%@%@", coverHeader, @"_2", coverType];
    
    //NSLog(@"%@", coverURL);
    
    musicInfo.identifier = [dic objectForKey:@"id"];
    musicInfo.title = [dic objectForKey:@"name"];
    musicInfo.musicURL = [dic objectForKey:@"location"];
    musicInfo.cover = [self getCoverWithURL:coverURL];
    musicInfo.artist = [dic objectForKey:@"artist_name"];
    musicInfo.mark = [NSString stringWithFormat: @"%@", [dic objectForKey:@"mark"]];
    
    //NSLog(@"%@", musicInfo.musicURL);
    
    return musicInfo;
}


- (XiamiObject *)getRecemmondMusic
{
    NSString * url = [NSString stringWithFormat: @"%@/song_graphs.json", SERVER_URL_MUSIC];
    NSData * rcdData = [ServerConnection getRequestToURL:url];
    NSError * error = nil;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:rcdData options:0 error: &error];
    
    if ([dic[@"status"] isEqualToString:@"ok"]) {
        return [self getMusicWithIdentifier:dic[@"music_id"]];
    } else {
        srand((int)rcdData);
        NSString * randomId = [NSString stringWithFormat:@"%d", rand() % 5000];
        return [self getMusicWithIdentifier:randomId];
    }
}

- (UIImage *) getCoverWithURL:(NSString *) url
{
    NSData * data = [ServerConnection getRequestToURL:url];
    UIImage * cover = [UIImage imageWithData:data];
    return cover;
}


- (BOOL) loveSongWithIdentifier: (NSString *)identifier
{
    NSString * url = [NSString stringWithFormat: @"%@/%@/like", SERVER_URL_MUSIC, identifier];
    NSData * data = [ServerConnection getRequestToURL:url];
    
    NSError * error = NULL;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if ([dic[@"status"] isEqualToString:@"ok"] == YES) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) disLoveSongWithIdentifier: (NSString *)identifier
{
    NSString * url = [NSString stringWithFormat: @"%@/%@/unmark", SERVER_URL_MUSIC, identifier];
    NSData * data = [ServerConnection getRequestToURL:url];
    
    NSError * error = NULL;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if ([dic[@"status"] isEqualToString:@"ok"] == YES) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) hateSongWithIdentifier: (NSString *)identifier
{
    NSString * url = [NSString stringWithFormat: @"%@/%@/dislike", SERVER_URL_MUSIC, identifier];
    NSData * data = [ServerConnection getRequestToURL:url];
    
    NSError * error = NULL;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if ([dic[@"status"] isEqualToString:@"ok"] == YES) {
        return YES;
    } else {
        return NO;
    }
}









@end