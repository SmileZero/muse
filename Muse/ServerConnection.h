//
//  ServerConnection.h
//  Muse
//
//  Created by zhu peijun on 2013/12/13.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define SERVER_URL @"http://172.30.4.19"
#define SERVER_URL @"http://localhost:3000"
//#define SERVER_URL @"http://192.168.200.233:3000"
#define CSRF_TOKEN @"ErP/0VA0bLqQBvKhuTaw4CxYrlxaNya65enbK2hbCqg="

@interface ServerConnection : NSObject
+ (NSData *)sendRequestToURL:(NSString *)url method:(NSString *)method JSONObject:(id)jsonObject;
+ (NSData *)getRequestToURL:(NSString *)url;
@end
