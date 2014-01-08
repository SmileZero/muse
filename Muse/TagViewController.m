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
#import "TagSoucePlist.h"


#define LIKE_TAG_INDEX 2
#define GUESS_TAG_INDEX 1

@interface TagViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TagViewController


+ (int) getLikeTagIndex
{
    return LIKE_TAG_INDEX;
}

+ (int) getGuessTagIndex
{
    return GUESS_TAG_INDEX;
}

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

    
    _currentIndex = 1;
}


- (void)realoadTableData
{
    UITableView * tableView = (UITableView *)[self.view viewWithTag:3001];
    
    
    if (_currentIndex == LIKE_TAG_INDEX) {
        [Player setPlayList:[TagSoucePlist readTagSourcePlistData][0][@"MusicIds"]:1];
    }
    
    [tableView reloadData];
}
- (void)selectTagAtIndex: (int) index
{
}

- (void) setCurrentTagIndex:(int)currentIndex
{
    UITableView * tableView = (UITableView *)[self.view viewWithTag:3001];
    UITableViewCell * cell_before = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    UIImageView * beforeLabelImageView = (UIImageView *) [cell_before viewWithTag:211];
    beforeLabelImageView.hidden = YES;
    
    NSLog(@"111: %d", _currentIndex);
    _currentIndex = currentIndex;
    NSLog(@"222: %d", _currentIndex);
    
    UITableViewCell * cell_after = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    UIImageView * afterLabelImageView = (UIImageView *) [cell_after viewWithTag:211];
    afterLabelImageView.hidden = NO;
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

    
    return [_tagArray count] + 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString * filePath = [[NSBundle mainBundle] pathForResource:@"TagSource" ofType:@"plist"];
    //_tagArray = [NSArray arrayWithContentsOfFile:filePath];
    
    //NSLog(@"%d", indexPath.section);
    
    UITableViewCell * cell = NULL;
    
    if (indexPath.row == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier: @"TagGroupTitleTableCell" forIndexPath:indexPath];
        
        UILabel * label = (UILabel *)[cell viewWithTag:202];
        label.text = @"Private";
        
        [cell setUserInteractionEnabled:NO];
        
    } else if(indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier: @"TagGroupTitleTableCell" forIndexPath:indexPath];
        
        UILabel * label = (UILabel *)[cell viewWithTag:202];
        label.text = @"Public";
        
        [cell setUserInteractionEnabled:NO];
    } else {
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


        cell = [tableView dequeueReusableCellWithIdentifier: @"TagTableCell" forIndexPath:indexPath];


        UILabel * tagNameLabel = (UILabel *)[cell viewWithTag:101];
        UILabel * countMusicOfThisTagLabel = (UILabel *)[cell viewWithTag:102];
        UIImageView * currentLabelImageView = (UIImageView *) [cell viewWithTag:211];



        if (indexPath.row == _currentIndex) {
            currentLabelImageView.hidden = NO;
        } else {
            currentLabelImageView.hidden = YES;
        }

        if (indexPath.row == 1) {
            tagNameLabel.text = @"Just listen";
            countMusicOfThisTagLabel.text = @"";
        } else {
            
            int index = 0;
            
            if (indexPath.row <= 3) {
                index = indexPath.row - 2;
            } else {
                index = indexPath.row - 3;
            }
            
            NSDictionary * dic = _tagArray[index];
            NSArray * musicIds = dic[@"MusicIds"];
            
            int count = [musicIds count];
            
            
            tagNameLabel.text = dic[@"Name"];
            countMusicOfThisTagLabel.text = [NSString stringWithFormat:@"%d", count];
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UILabel * tagNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel * countMusicOfThisTagLabel = (UILabel *)[cell viewWithTag:102];
    
    
    //NSLog(@"%@ %@ %d", tagNameLabel.text, countMusicOfThisTagLabel.text, indexPath.row);
    
    if ([countMusicOfThisTagLabel.text isEqualToString:@"0"]) {
        [cell setUserInteractionEnabled:NO];
        tagNameLabel.textColor = [UIColor darkGrayColor];
        countMusicOfThisTagLabel.textColor = [UIColor darkGrayColor];
    } else {
        [cell setUserInteractionEnabled:YES];
        tagNameLabel.textColor = [UIColor whiteColor];
        countMusicOfThisTagLabel.textColor = [UIColor whiteColor];
    }
    
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 || indexPath.row == 3) {
        return ;
    }
    
    if (indexPath.row == GUESS_TAG_INDEX) {
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
        
        int index = 0;
        
        if (indexPath.row <= 3) {
            index = indexPath.row - 2;
        } else {
            index = indexPath.row - 3;
        }
        
        [Player setPlayList:_tagArray[index][@"MusicIds"]: index];
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
