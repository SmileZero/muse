//
//  XiamiObject.h
//  Muse
//
//  Created by zhu peijun on 2013/12/13.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiamiObject : NSObject
@property (nonatomic,retain) NSString *identifier;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *artist;
@property (nonatomic,retain) NSString *artistID;
@property (nonatomic,retain) NSString *album;
@property (nonatomic,retain) NSString *albumID;
@property (nonatomic,retain) NSString *thumbnailURL;
@property (nonatomic,retain) NSString *musicURL;
@property (nonatomic,retain) UIImage * cover;
@property (nonatomic,retain) NSString * mark;

@end
