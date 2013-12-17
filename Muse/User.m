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
static User *current_user;

@implementation User
+ (User *) getUser
{
    if (current_user) {
        return current_user;
    }
    else{
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:@"UserProfile.plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"UserProfile" ofType:@"plist"];
        }
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];

        if (!temp) {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
            return nil;
        }
        else{
            [self userWithEmail:[temp objectForKey:@"Email"] password:nil name:[temp objectForKey:@"Name"] avatar:[temp objectForKey:@"Avatar"] remembrer_token:[temp objectForKey:@"Remember_token"] user_id:[temp objectForKey:@"User_id"]];
            return current_user;
        }
    }
}

+ (User *)userWithEmail:(NSString *)email password:(NSString *)password name:(NSString *)name avatar:(NSString *)avatar remembrer_token:(NSString *)remembrer_token user_id:(NSNumber *)user_id
{
    if (current_user) {
        current_user.email = email;
        current_user.password = password;
        current_user.name = name;
        current_user.avatar = avatar;
        current_user.remembrer_token = remembrer_token;
        current_user.user_id = user_id;
    }
    else{
        current_user= [[User alloc] init];
        current_user.email = email;
        current_user.password = password;
        current_user.name = name;
        current_user.avatar = avatar;
        current_user.remembrer_token = remembrer_token;
        current_user.user_id = user_id;
    }
    return current_user;
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
    NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!userDictionary) {
        NSLog(@"NSJSONSerialization error:%@ ", error);
        return;
    }
    CSRFToken = userDictionary[@"csrf_token"];
}

-(BOOL)signin
{
    NSLog(@"--- signIn %@ %@", current_user.email, current_user.password);
    [self getCSRFToken];
    NSError *error = nil;
    NSData *data = [ServerConnection sendRequestToURL:[NSString stringWithFormat:@"%@/signin", SERVER_URL] method:@"POST" JSONObject:@{@"session": @{@"email" : current_user.email, @"password" : current_user.password}, @"authenticity_token": CSRFToken}];
    // set todo_id
    NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if ([userDictionary[@"status"]  isEqual: @"ok"]) {
        current_user.user_id = userDictionary[@"user"][@"id"];
        current_user.name = userDictionary[@"user"][@"name"];
        current_user.avatar = userDictionary[@"user"][@"avatar"][@"url"];
        current_user.remembrer_token = userDictionary[@"user"][@"remember_token"];
        current_user.password = nil;
        NSString *error;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserProfile.plist"];
        NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                                   [NSArray arrayWithObjects: current_user.user_id, current_user.name, current_user.email,current_user.avatar, current_user.remembrer_token, nil]
                                                              forKeys:[NSArray arrayWithObjects: @"User_id", @"Name", @"Email",@"Avatar", @"Remember_token", nil]];
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                       format:NSPropertyListXMLFormat_v1_0
                                                             errorDescription:&error];
        if(plistData) {
            [plistData writeToFile:plistPath atomically:YES];
        }
        else {
            NSLog(@"%@",error);
        }
        return YES;
    }
    else{
        return NO;
    }
}

-(BOOL)signinWithRememberToken
{
    if (current_user.remembrer_token) {
        NSLog(@"--- signinWithToken %@ %@", current_user.email, current_user.remembrer_token);
        [self getCSRFToken];
        NSError *error = nil;
        NSData *data = [ServerConnection sendRequestToURL:[NSString stringWithFormat:@"%@/signin", SERVER_URL] method:@"POST" JSONObject:@{@"session": @{@"remember_token" : current_user.remembrer_token}, @"authenticity_token": CSRFToken}];
        // set todo_id
        NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([userDictionary[@"status"]  isEqual: @"ok"]) {
            current_user.user_id = userDictionary[@"user"][@"id"];
            current_user.name = userDictionary[@"user"][@"name"];
            current_user.avatar = userDictionary[@"user"][@"avatar"][@"url"];
            current_user.remembrer_token = userDictionary[@"user"][@"remember_token"];
            current_user.password = nil;
            NSString *error;
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserProfile.plist"];
            NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                                       [NSArray arrayWithObjects: current_user.user_id, current_user.name, current_user.email,current_user.avatar, current_user.remembrer_token, nil]
                                                                  forKeys:[NSArray arrayWithObjects: @"User_id", @"Name", @"Email",@"Avatar", @"Remember_token", nil]];
            NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                           format:NSPropertyListXMLFormat_v1_0
                                                                 errorDescription:&error];
            if(plistData) {
                [plistData writeToFile:plistPath atomically:YES];
            }
            else {
                NSLog(@"%@",error);
            }
            return YES;
        }
        else{
            return NO;
        }
    }
    else return NO;
}

- (NSString *)signup
{
    NSLog(@"--- signUp %@ %@", current_user.email, current_user.name);
    [self getCSRFToken];
    NSError *error = nil;
    NSData *data = [ServerConnection sendRequestToURL:[NSString stringWithFormat:@"%@/users.json", SERVER_URL] method:@"POST" JSONObject:@{@"user": @{@"email" : current_user.email, @"password_hash" : current_user.password, @"name": current_user.name}, @"authenticity_token": CSRFToken}];
    NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if ([userDictionary[@"status"]  isEqual: @"ok"]) {
        current_user.user_id = userDictionary[@"user"][@"id"];
        current_user.avatar = userDictionary[@"user"][@"avatar"][@"url"];
        current_user.remembrer_token = userDictionary[@"user"][@"remember_token"];
        current_user.password = nil;
        NSString *error;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserProfile.plist"];
        NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                                   [NSArray arrayWithObjects: current_user.user_id, current_user.name, current_user.email,current_user.avatar, current_user.remembrer_token, nil]
                                                              forKeys:[NSArray arrayWithObjects: @"User_id", @"Name", @"Email",@"Avatar", @"Remember_token", nil]];
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                       format:NSPropertyListXMLFormat_v1_0
                                                             errorDescription:&error];
        if(plistData) {
            [plistData writeToFile:plistPath atomically:YES];
        }
        else {
            NSLog(@"%@",error);
        }
        return @"ok";
    }
    else{
        
        NSLog(userDictionary[@"msg"]);
        return userDictionary[@"msg"];
    }
}

- (BOOL)signout
{
    NSLog(@"--- signOut %@ %@", current_user.email, current_user.name);
    [self getCSRFToken];
    [ServerConnection sendRequestToURL:[NSString stringWithFormat:@"%@/signout.json", SERVER_URL] method:@"DELETE" JSONObject:@{@"authenticity_token": CSRFToken}];
    return YES;
}

@end
