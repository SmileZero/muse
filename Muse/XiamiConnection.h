//
//  XiamiConnection.h
//  Muse
//
//  Created by zhu peijun on 2013/12/13.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XiamiObject.h"
#import "ServerConnection.h"


@interface XiamiConnection : NSObject
- (XiamiObject *) getMusicWithIdentifier: (NSString *) identifier;
- (BOOL) loveSongWithIdentifier: (NSString *)identifier;
- (BOOL) disLoveSongWithIdentifier: (NSString *)identifier;
@end
