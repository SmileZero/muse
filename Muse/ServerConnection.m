//
//  ServerConnection.m
//  Muse
//
//  Created by zhu peijun on 2013/12/13.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "ServerConnection.h"

@implementation ServerConnection

+ (NSData *)sendRequestToURL:(NSString *)url method:(NSString *)method JSONObject:(id)jsonObject
{
    NSLog(@"--- sendRequestToURL: %@ %@", url, method);
    
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:&error];
    if (!requestData) {
        NSLog(@"NSJSONSerialization error:%@ ", error);
        return nil;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:url]];
    [request setHTTPMethod:method];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];
    
    NSLog(@"%@", jsonObject);
    
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (!responseData || (response.statusCode != 201 && response.statusCode != 204 && response.statusCode != 200)) {
        NSLog(@"NSURLConnection error:%@ status:%d", error, response.statusCode);
    }
    return responseData;
}

+ (NSData *)getRequestToURL:(NSString *)url {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:url]];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!data || response.statusCode != 200) {
        NSLog(@"NSURLConnection error:%@ status:%d", error, response.statusCode);
    }
    return data;
}
@end
