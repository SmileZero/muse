//
//  FPResponse.h
//  MuseHearDemo
//
//  Created by yan runchen on 2013/12/04.
//  Copyright (c) 2013年 yan runchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GracenoteMusicID/GNSearchResultReady.h>

@interface FPResponse : NSObject <GNSearchResultReady>
{
    
}

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *artistLabel;
@property (strong, nonatomic) UIImageView *cover;
@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIImageView *border;
@property (strong, nonatomic) UIButton *recogBtn;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property BOOL *animating;

- (id) initWithNameLabel:(UILabel *) nLabel artistLabel:(UILabel *) aLabel cover:(UIImageView *)cv playBtn:(UIButton *)playBtn recogBtn: (UIButton *) recogBtn border:(UIImageView *)border tap:(UITapGestureRecognizer *) tap animating:(BOOL *) isAnimate;
- (void) GNResultReady:(GNSearchResult*) result;
+ (NSString *) getResultId;

@end