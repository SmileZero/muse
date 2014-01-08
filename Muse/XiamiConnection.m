//
//  XiamiConnection.m
//  Muse
//
//  Created by zhu peijun on 2013/12/13.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//


#import "XiamiConnection.h"

#define SERVER_URL_MUSIC (SERVER_URL @"/musics/")

@implementation XiamiConnection


- (XiamiObject *)getMusicWithIdentifier:(NSString *)identifier
{
    
    
    NSString * url = [NSString stringWithFormat: @"%@%@.json", SERVER_URL_MUSIC, identifier];
    
    NSData * data = [ServerConnection getRequestToURL:url];
    
    XiamiObject * musicInfo = NULL;
    
    if (data) {
        NSError * error = NULL;
        NSDictionary * feedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSDictionary * dic = [feedData objectForKey:@"music"];
        
        
        musicInfo = [[XiamiObject alloc] init];
        
        
        
        NSString * coverDefaultSizeURL = [dic objectForKey:@"cover_url"];
        int length = [coverDefaultSizeURL length];
        
        int k;
        
        for (k = length - 1; k >= 0; k--) {
            if ([coverDefaultSizeURL characterAtIndex:k] == '.') {
                break;
            }
        }
        
        int n = length - k;
        
        NSString * coverHeader = [coverDefaultSizeURL substringToIndex: length - n];
        NSString * coverType = [coverDefaultSizeURL substringWithRange:NSMakeRange(length - n, n)];
        
        NSString * coverURL = [NSString stringWithFormat:@"%@%@%@", coverHeader, @"_2", coverType];
        
        NSLog(@"%@", coverURL);
        NSLog(@"%d", k);
        
        if (k < 0 || n > 10) {
            musicInfo.cover = [UIImage imageNamed:@"DefaultMusicPicture.png"];
        } else {
            musicInfo.cover = [self getCoverWithURL:coverURL];
        }
        
        musicInfo.identifier = [dic objectForKey:@"id"];
        musicInfo.title = [dic objectForKey:@"name"];
        musicInfo.musicURL = [dic objectForKey:@"location"];
        musicInfo.artist = [dic objectForKey:@"artist_name"];
        musicInfo.mark = [NSString stringWithFormat: @"%@", [dic objectForKey:@"mark"]];
    }
    
    //NSLog(@"%@", musicInfo.musicURL);
    
    return musicInfo;
}


- (XiamiObject *)getRecemmondMusic
{
    NSString * url = [NSString stringWithFormat: @"%@/song_graphs.json", SERVER_URL];
    NSLog(@"%@", url);
    NSData * rcdData = [ServerConnection getRequestToURL:url];
    
    
    
    if (rcdData) {
        NSError * error = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:rcdData options:0 error: &error];
        
        NSLog(@"return status: %@", dic[@"status"]);
        
        if ([dic[@"status"] isEqualToString:@"ok"]) {
            NSLog(@"music_id: ##########%@##########", dic[@"music_id"]);
            return [self getMusicWithIdentifier:dic[@"music_id"]];
            //@"85433"];208203//
            //return [self getMusicWithIdentifier:@"208203"];
        } else {
            srand((int)rcdData);
            NSString * randomId = [NSString stringWithFormat:@"%d", rand() % 5000];
            return [self getMusicWithIdentifier:randomId];
        }
    }
    
    return nil;
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