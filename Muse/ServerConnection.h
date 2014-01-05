//
//  ServerConnection.h
//  Muse
//
//  Created by zhu peijun on 2013/12/13.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define SERVER_IP @"localhost"
//#define SERVER_IP @"172.30.4.19"
//#define SERVER_IP @"192.168.1.10"
//#define SERVER_IP @"192.168.201.28"
#define SERVER_IP @"muse-01.rackbox.net"
//#define SERVER_PORT @":3000"
#define SERVER_PORT @""
#define SERVER_URL @"http://" SERVER_IP SERVER_PORT
#define CSRF_TOKEN @"ErP/0VA0bLqQBvKhuTaw4CxYrlxaNya65enbK2hbCqg="

@interface ServerConnection : NSObject
+ (NSData *)sendRequestToURL:(NSString *)url method:(NSString *)method JSONObject:(id)jsonObject;
+ (NSData *)getRequestToURL:(NSString *)url;
+ (NSString *) getCSRFToken;

@end
