//
//  TagViewController.m
//  Muse
//
//  Created by zhu peijun on 2013/12/19.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "TagViewController.h"
#import "Player.h"
#import "SWRevealViewController.h"
#import "PlayerViewController.h"

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
    
    return [_tagArray count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"TagSource" ofType:@"plist"];
    _tagArray = [NSArray arrayWithContentsOfFile:filePath];
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"TagTableCell" forIndexPath:indexPath];
    
    
    UILabel * tagNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel * countMusicOfThisTagLabel = (UILabel *)[cell viewWithTag:102];
    
    
    
    
    if (indexPath.row == 0) {
        tagNameLabel.text = @"Guess";
        countMusicOfThisTagLabel.text = @"";
    } else {
        
        NSDictionary * dic = _tagArray[indexPath.row - 1];
        NSArray * musicIds = dic[@"MusicIds"];
        
        tagNameLabel.text = dic[@"Name"];
        countMusicOfThisTagLabel.text = [NSString stringWithFormat:@"%d", [musicIds count]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [Player setPlayType:0];
    } else {
        [Player setPlayType:1];
        
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"TagSource" ofType:@"plist"];
        _tagArray = [NSArray arrayWithContentsOfFile:filePath];
        [Player setPlayList:_tagArray[indexPath.row - 1][@"MusicIds"]];
    }
    
    //[self performSegueWithIdentifier:@"gotoPlayViewFromTagView" sender:self];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    
    
    PlayerViewController * palyViewController =  (PlayerViewController *)self.revealViewController.frontViewController;
    
    [palyViewController loadMusic];
}





@end
