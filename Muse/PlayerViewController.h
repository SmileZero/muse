//
//  ViewController.h
//  Muse
//
//  Created by zhu peijun on 2013/12/05.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) MPMoviePlayerController * moviePlayer;
@end
