//
//  User.h
//  Muse
//
//  Created by yan runchen on 2013/12/14.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property(strong, nonatomic) NSNumber *user_id;
@property(strong, nonatomic) NSString *email;
@property(strong, nonatomic) NSString *password;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *avatar;
@property(strong, nonatomic) NSString *remembrer_token;


+ (User *)userWithEmail:(NSString *)email password:(NSString *)password name:(NSString *)name avatar:(NSString *)avatar remembrer_token:(NSString *)remembrer_token user_id:(NSNumber *)user_id;
+ (User *)userWithEmail:(NSString *)email password:(NSString *)password name:(NSString *)name;
+ (User *)userWithEmail:(NSString *)email password:(NSString *)password;

- (void)signup;
- (BOOL)signin;
- (void)signout;

@end
