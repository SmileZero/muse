//
//  TagSoucePlist.m
//  Muse
//
//  Created by zhu peijun on 2013/12/25.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "TagSoucePlist.h"

@implementation TagSoucePlist


+ (NSArray *) readTagSourcePlistData
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"TagSource.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"TagSource" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSArray * result = (NSArray *)[NSPropertyListSerialization
                            propertyListFromData:plistXML
                            mutabilityOption:NSPropertyListMutableContainersAndLeaves
                            format:&format
                            errorDescription:&errorDesc];
    
    return result;
}

@end

