//
//  superman.m
//  loadingAN
//
//  Created by Shu Zhang on 4/16/15.
//  Copyright (c) 2015 Shu Zhang. All rights reserved.
//

#import "superman.h"

@implementation superman
{
    double angleSuperman;
    UIImageView *imageView;
    UIImageView *imageViewSuperman;
    NSInteger value;
}



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _supermanSPE=2.0;
        self.backgroundColor = [UIColor clearColor];
        imageViewSuperman = [[UIImageView alloc]initWithFrame:CGRectMake(150, 260, 30, 60)];
        imageViewSuperman.image = [UIImage imageNamed:@"superman1"];
        [self addSubview:imageViewSuperman];
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
    imageViewSuperman.transform = CGAffineTransformMakeRotation(angleSuperman * (M_PI / 180.0f));
    imageViewSuperman.layer.anchorPoint = CGPointMake(5, 0.5);
    //默认是0.5 0.5
    [UIView commitAnimations];
    
    
}

-(void)endAnimationEarth
{
    angleSuperman +=5*_supermanSPE;
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
