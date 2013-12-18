//
//  FPResponse.m
//  MuseHearDemo
//
//  Created by yan runchen on 2013/12/04.
//  Copyright (c) 2013年 yan runchen. All rights reserved.
//

#import "FPResponse.h"
#import "Music.h"
#import <GracenoteMusicID/GNSearchResultReady.h>
#import <GracenoteMusicID/GNSearchResponse.h>
#import <GracenoteMusicID/GNSearchResult.h>


@implementation FPResponse

@synthesize nameLabel;
@synthesize artistLabel;
@synthesize cover;


- (id) initWithNameLabel:(UILabel *) nLabel artistLabel:(UILabel *) aLabel cover:(UIImageView *)cv playBtn:(UIButton *)playBtn recogBtn: (UIButton *) recogBtn border:(UIImageView *)border tap:(UITapGestureRecognizer *)tap animating:(BOOL*) isAnimate;
{
    self = [super init];
    if (self){
        self.nameLabel = nLabel;
        self.artistLabel = aLabel;
        self.cover = cv;
        self.playBtn = playBtn;
        self.recogBtn = recogBtn;
        self.border = border;
        self.tap = tap;
        self.animating = isAnimate;
    }
    return self;
}

- (void) GNResultReady:(GNSearchResult *) result
{
    GNSearchResponse *best = [result bestResponse];
    if (![result isFailure] && (best.artist!=nil)){
        NSLog(@"%@, %@, %@", best.trackTitle,best.artist,best.albumTitle);
        Music *music = [Music searchByName:best.trackTitle andArtistName:best.artist];
        if (music == nil) {
            [self.recogBtn setTitle:@"NO MATCH" forState:UIControlStateNormal];
        }
        else{
            [self.nameLabel setText:[NSString stringWithFormat:@"%@",music.name]];
            [self.artistLabel setText:[NSString stringWithFormat:@"%@",music.artist_name]];
            NSLog(@"%@",self.cover.image);
            UIImage* cover_image = [Music getCoverWithURL:music.cover_url];
            self.cover.image = cover_image;
            //best.artist,best.albumTitle]];
            
            self.recogBtn.hidden = true;
            self.border.hidden = true;
            self.nameLabel.hidden = false;
            self.artistLabel.hidden = false;
            self.cover.hidden = false;
            self.playBtn.hidden = false;
        }
    }
    else{
        [self.recogBtn setTitle:@"NO MATCH" forState:UIControlStateNormal];
        //border
    }
    self.tap.enabled = YES;
    _recogBtn.userInteractionEnabled = YES;
    *self.animating = NO;

}
@end
