//
//  XiamiConnection.m
//  Muse
//
//  Created by zhu peijun on 2013/12/13.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//


#import "XiamiConnection.h"


#define SERVER_URL @"http://localhost:3000/musics/"

@implementation XiamiConnection


- (XiamiObject *)getMusicWithIdentifier:(NSString *)identifier
{
    
    NSString * url = [NSString stringWithFormat: @"%@%@.json", SERVER_URL, identifier];
    
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
    
    NSLog(@"%@", coverURL);
    
    musicInfo.identifier = [dic objectForKey:@"id"];
    musicInfo.title = [dic objectForKey:@"name"];
    musicInfo.musicURL = [dic objectForKey:@"location"];
    musicInfo.cover = [self getCoverWithURL:coverURL];
    musicInfo.artist = [dic objectForKey:@"artist_name"];
      musicInfo.mark = [dic objectForKey:@"mark"];
    
    
    return musicInfo;
}


- (UIImage *) getCoverWithURL:(NSString *) url
{
    NSData * data = [ServerConnection getRequestToURL:url];
    UIImage * cover = [UIImage imageWithData:data];
    return cover;
}







@end