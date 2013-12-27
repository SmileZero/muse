//
//  FacebookLoginButton.m
//  Muse
//
//  Created by yan runchen on 2013/12/27.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "FacebookLoginButton.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FacebookLoginButton



static FBLoginView *fbloginBtn = NULL;


+ (id) getFacebookButton
{
    if (fbloginBtn == NULL) {
        fbloginBtn = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email"]];
    }
    
    return fbloginBtn;
}

@end
