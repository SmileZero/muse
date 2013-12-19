//
//  TagViewController.m
//  Muse
//
//  Created by zhu peijun on 2013/12/19.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "TagViewController.h"

@interface TagViewController ()

@end

@implementation TagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadAllTagInfo
{
    NSLog(@"%d", [_tagArray count]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAllTagInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"TagSource" ofType:@"plist"];
    _tagArray = [NSArray arrayWithContentsOfFile:filePath];
    
    return [_tagArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"TagSource" ofType:@"plist"];
    _tagArray = [NSArray arrayWithContentsOfFile:filePath];
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"TagTableCell" forIndexPath:indexPath];
    
    
    UILabel * tagNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel * countMusicOfThisTagLabel = (UILabel *)[cell viewWithTag:102];
    
    NSDictionary * dic = _tagArray[indexPath.row];
    NSArray * musicIds = dic[@"MusicIds"];
    
    tagNameLabel.text = dic[@"Name"];
    countMusicOfThisTagLabel.text = [NSString stringWithFormat:@"%d", [musicIds count]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
