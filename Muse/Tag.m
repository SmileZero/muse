//
//  Tag.m
//  Muse
//
//  Created by yan runchen on 2013/12/20.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "Tag.h"

@implementation Tag

+ (Tag *)tagWithName:(NSString *)name tag_id:(NSNumber *)tag_id
{
    Tag *tag = [[Tag alloc] init];
    tag.name = name;
    tag.tag_id = tag_id;
    return tag;
}

+ (BOOL)reloadFav
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
    NSArray* tagArray = (NSArray *)[NSPropertyListSerialization
                            propertyListFromData:plistXML
                            mutabilityOption:NSPropertyListMutableContainersAndLeaves
                            format:&format
                            errorDescription:&errorDesc];
    if (!tagArray) {
        return NO;
    }
    else{
        NSMutableArray* newTagArray = [tagArray mutableCopy];
        NSDictionary* liked = tagArray[0];
        NSMutableDictionary* newLiked = [liked mutableCopy];
        NSData *data = [ServerConnection getRequestToURL:[NSString stringWithFormat:@"%@/fav.json", SERVER_URL]];
        if (!data) {
            return NO;
        }
        NSError* error = nil;
        NSDictionary* resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!resultDictionary) {
            NSLog(@"NSJSONSerialization error:%@ ", error);
            return NO;
        }
        if ([resultDictionary[@"status"]  isEqual: @"ok"]) {
            [newLiked removeObjectForKey:@"MusicIds"];
            [newLiked setObject:resultDictionary[@"tag"][@"music_list"] forKey:@"MusicIds"];
            [newTagArray removeObjectAtIndex:0];
            [newTagArray insertObject:newLiked atIndex:0];
            
            NSString* errorStr = nil;
            NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:newTagArray
                                                                           format:NSPropertyListXMLFormat_v1_0
                                                                 errorDescription:&errorStr];
            
            [plistData writeToFile:plistPath atomically:YES];
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)getAll
{
    NSData *data = [ServerConnection getRequestToURL:[NSString stringWithFormat:@"%@/tags.json", SERVER_URL]];
    if (!data) {
        return NO;
    }
    
    NSError *error = nil;
    NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!resultDictionary) {
        NSLog(@"NSJSONSerialization error:%@ ", error);
        return NO;
    }
    if ([resultDictionary[@"status"]  isEqual: @"ok"]) {
        NSArray *tagDictionary = resultDictionary[@"tags"];
        NSMutableArray *plistArray = [[NSMutableArray alloc] init];
        NSMutableDictionary* liked = [[NSMutableDictionary alloc] init];
        [liked setValue:@"Liked" forKey:@"Name"];
        data = [ServerConnection getRequestToURL:[NSString stringWithFormat:@"%@/fav.json", SERVER_URL]];
        if (!data) {
            return NO;
        }
        error = nil;
        resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!resultDictionary) {
            NSLog(@"NSJSONSerialization error:%@ ", error);
            return NO;
        }
        if ([resultDictionary[@"status"]  isEqual: @"ok"]) {
            [liked setObject:resultDictionary[@"tag"][@"music_list"] forKey:@"MusicIds"];
            [plistArray addObject:liked];
        }
        else{
            return NO;
        }
        
        for(int i=0;i<[tagDictionary count] ;i++ ){
            NSDictionary* tag = tagDictionary[i];
            
            //[tag setObject:[tag objectForKey: @"name"] forKey:@"Name"];
            //[tag removeObjectForKey:@"name"];
            
            NSData *data2 = [ServerConnection getRequestToURL:[NSString stringWithFormat:@"%@/tags/%@.json", SERVER_URL,tag[@"id"]]];
            if (!data2) {
                return NO;
            }
            NSError *error2 = nil;
            NSDictionary *resultDictionary2 = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:&error];
            if (!resultDictionary2) {
                NSLog(@"NSJSONSerialization error:%@ ", error2);
                return NO;
            }
            if ([resultDictionary2[@"status"]  isEqual: @"ok"]) {
                NSDictionary *tagInfo = resultDictionary2[@"tag"];
                NSMutableDictionary *tagPlist = [tagInfo mutableCopy];
                [tagPlist setObject:[tag objectForKey: @"name"] forKey:@"Name"];
                [tagPlist removeObjectForKey:@"name"];
                [tagPlist setObject:tagInfo[@"music_list"] forKey:@"MusicIds"];
                [tagPlist removeObjectForKey:@"music_list"];
                [plistArray addObject:tagPlist];
                
                //NSLog(@"%@",tag);
            }
            else return NO;
        }
        
        NSString* errorStr = nil;
        
        NSString *error;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [rootPath stringByAppendingPathComponent:@"TagSource.plist"];

        
        //NSString * filePath = [[NSBundle mainBundle] pathForResource:@"TagSource" ofType:@"plist"];
        
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistArray
                                                                       format:NSPropertyListXMLFormat_v1_0
                                                             errorDescription:&errorStr];
        if(plistData) {
            [plistData writeToFile:filePath atomically:YES];
            return YES;
        }
        else {
            NSLog(@"%@",error);
            return NO;
        }

    }
    else{
        return NO;
    }
}



@end
