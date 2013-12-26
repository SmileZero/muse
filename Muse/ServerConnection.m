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
                                    [NSURL URLWithString:url] cachePolicy: NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
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
                                    [NSURL URLWithString:url] cachePolicy: NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!data || response.statusCode != 200) {
        NSLog(@"NSURLConnection error:%@ status:%d", error, response.statusCode);
    }
    return data;
}

+ (NSString *) getCSRFToken
{
    NSData *data = [ServerConnection getRequestToURL:[NSString stringWithFormat:@"%@/getCSRFToken.json", SERVER_URL]];
    if (!data) {
        return nil;
    }
    
    NSError *error = nil;
    NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!userDictionary) {
        NSLog(@"NSJSONSerialization error:%@ ", error);
        return nil;
    }
    return userDictionary[@"csrf_token"];
}

@end
