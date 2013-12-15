//
//  User.m
//  Muse
//
//  Created by yan runchen on 2013/12/14.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "User.h"
#import "ServerConnection.h"

static NSString *CSRFToken;

@implementation User
+ (User *)userWithEmail:(NSString *)email password:(NSString *)password name:(NSString *)name avatar:(NSString *)avatar remembrer_token:(NSString *)remembrer_token user_id:(NSNumber *)user_id
{
    User *user = [[User alloc] init];
    user.email = email;
    user.password = password;
    user.name = name;
    user.avatar = avatar;
    user.remembrer_token = remembrer_token;
    user.user_id = user_id;
    return user;
}

+ (User *)userWithEmail:(NSString *)email password:(NSString *)password name:(NSString *)name
{
    return [User userWithEmail:email password:password name:name avatar:nil remembrer_token:nil user_id:nil];
}

+ (User *)userWithEmail:(NSString *)email password:(NSString *)password
{
    return [User userWithEmail:email password:password name:nil avatar:nil remembrer_token:nil user_id:nil];
}

-(void)getCSRFToken
{
    NSData *data = [ServerConnection getRequestToURL:[NSString stringWithFormat:@"%@/getCSRFToken.json", SERVER_URL]];
    if (!data) {
        return;
    }
    
    NSError *error = nil;
    NSDictionary *todosDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!todosDictionary) {
        NSLog(@"NSJSONSerialization error:%@ ", error);
        return;
    }
    CSRFToken = todosDictionary[@"csrf_token"];
}

-(BOOL)signin
{
    NSLog(@"--- save %@ %@", _email, _password);
    [self getCSRFToken];
    NSError *error = nil;
    NSData *data = [ServerConnection sendRequestToURL:[NSString stringWithFormat:@"%@/signin", SERVER_URL] method:@"POST" JSONObject:@{@"session": @{@"email" : _email, @"password" : _password}, @"authenticity_token": CSRFToken}];
    // set todo_id
    NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if ([userDictionary[@"status"]  isEqual: @"ok"]) {
        _user_id = userDictionary[@"user"][@"id"];
        _name = userDictionary[@"user"][@"name"];
        _avatar = userDictionary[@"user"][@"avatar"];
        _remembrer_token = userDictionary[@"user"][@"remember_token"];
        return YES;
    }
    else{
        return NO;
    }
}

@end
