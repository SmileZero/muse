//
//  TagViewController.h
//  Muse
//
//  Created by zhu peijun on 2013/12/19.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) NSArray * tagArray;

@end
