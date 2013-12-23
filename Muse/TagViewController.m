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
#import "Tag.h"

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

    
    _currentIndex = 0;
}


- (void)realoadTableData
{
    UITableView * tableView = (UITableView *)[self.view viewWithTag:3001];
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSString * filePath = [[NSBundle mainBundle] pathForResource:@"TagSource" ofType:@"plist"];
    //_tagArray = [NSArray arrayWithContentsOfFile:filePath];
    
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
    _tagArray = (NSArray *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];

    
    return [_tagArray count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString * filePath = [[NSBundle mainBundle] pathForResource:@"TagSource" ofType:@"plist"];
    //_tagArray = [NSArray arrayWithContentsOfFile:filePath];
    
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
    _tagArray = (NSArray *)[NSPropertyListSerialization
                            propertyListFromData:plistXML
                            mutabilityOption:NSPropertyListMutableContainersAndLeaves
                            format:&format
                            errorDescription:&errorDesc];
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"TagTableCell" forIndexPath:indexPath];
    
    
    UILabel * tagNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel * countMusicOfThisTagLabel = (UILabel *)[cell viewWithTag:102];
    UIImageView * currentLabelImageView = (UIImageView *) [cell viewWithTag:211];
    
    
    
    if (indexPath.row == _currentIndex) {
        currentLabelImageView.hidden = NO;
    } else {
        currentLabelImageView.hidden = YES;
    }
    
    if (indexPath.row == 0) {
        tagNameLabel.text = @"Guess";
        countMusicOfThisTagLabel.text = @"";
    } else {
        
        NSDictionary * dic = _tagArray[indexPath.row - 1];
        NSArray * musicIds = dic[@"MusicIds"];
        
        int count = [musicIds count];
        
        
        tagNameLabel.text = dic[@"Name"];
        countMusicOfThisTagLabel.text = [NSString stringWithFormat:@"%d", count];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UILabel * tagNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel * countMusicOfThisTagLabel = (UILabel *)[cell viewWithTag:102];
    
    
    NSLog(@"%@ %@ %d", tagNameLabel.text, countMusicOfThisTagLabel.text, indexPath.row);
    
    if ([countMusicOfThisTagLabel.text isEqualToString:@"0"]) {
        [cell setUserInteractionEnabled:NO];
        tagNameLabel.textColor = [UIColor darkGrayColor];
        countMusicOfThisTagLabel.textColor = [UIColor darkGrayColor];
    } else {
        [cell setUserInteractionEnabled:YES];
        tagNameLabel.textColor = [UIColor whiteColor];
        countMusicOfThisTagLabel.textColor = [UIColor whiteColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [Player setPlayType:0];
    } else {
        [Player setPlayType:1];
        
        //NSString * filePath = [[NSBundle mainBundle] pathForResource:@"TagSource" ofType:@"plist"];
        //_tagArray = [NSArray arrayWithContentsOfFile:filePath];
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
        _tagArray = (NSArray *)[NSPropertyListSerialization
                                propertyListFromData:plistXML
                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                format:&format
                                errorDescription:&errorDesc];
        
        [Player setPlayList:_tagArray[indexPath.row - 1][@"MusicIds"]];
    }
    
    //[self performSegueWithIdentifier:@"gotoPlayViewFromTagView" sender:self];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    
    
    PlayerViewController * palyViewController =  (PlayerViewController *)self.revealViewController.frontViewController;
    
    UITableViewCell * cell_before = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:indexPath.section]];
    UIImageView * beforeLabelImageView = (UIImageView *) [cell_before viewWithTag:211];
    beforeLabelImageView.hidden = YES;
    
    _currentIndex = indexPath.row;
    
    UITableViewCell * cell_after = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:indexPath.section]];
    UIImageView * afterLabelImageView = (UIImageView *) [cell_after viewWithTag:211];
    afterLabelImageView.hidden = NO;
    
    [palyViewController loadMusic];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}





@end
