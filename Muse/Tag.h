//
//  Tag.h
//  Muse
//
//  Created by yan runchen on 2013/12/20.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "ServerConnection.h"
#import <Foundation/Foundation.h>

@interface Tag : NSObject
@property(strong, nonatomic) NSNumber *tag_id;
@property(strong, nonatomic) NSString *name;

+ (Tag *)tagWithName:(NSString *)name tag_id:(NSNumber *)tag_id;

+ (BOOL)getAll;


@end
