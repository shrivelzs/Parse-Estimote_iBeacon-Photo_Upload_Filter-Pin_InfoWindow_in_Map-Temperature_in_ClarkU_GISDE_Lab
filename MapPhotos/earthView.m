//
//  earthView.m
//  loadingAN
//
//  Created by Shu Zhang on 4/16/15.
//  Copyright (c) 2015 Shu Zhang. All rights reserved.
//

#import "earthView.h"

@implementation earthView
{
    double angleEarth;
    UIImageView *imageView;
    UIImageView *imageViewEarth;
    NSInteger value;
}



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _earthSPE=1.0;
        self.backgroundColor = [UIColor clearColor];
        imageViewEarth = [[UIImageView alloc]initWithFrame:CGRectMake(31, 160, 260, 260)];
        imageViewEarth.image = [UIImage imageNamed:@"earthimage"];
        [self addSubview:imageViewEarth];
        [self startAnimationEarth];
        }
    return  self;
}




-(void)startAnimationEarth
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimationEarth)];
    imageViewEarth.transform = CGAffineTransformMakeRotation(angleEarth * (M_PI / -180.0f));
    [UIView commitAnimations];
    
    
}

-(void)endAnimationEarth
{
    angleEarth +=5*_earthSPE;
    [self startAnimationEarth];
}
















/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
