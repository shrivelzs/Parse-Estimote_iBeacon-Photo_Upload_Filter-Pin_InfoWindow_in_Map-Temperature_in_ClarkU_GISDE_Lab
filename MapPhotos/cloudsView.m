//
//  cloudsView.m
//  loadingAN
//
//  Created by Shu Zhang on 4/16/15.
//  Copyright (c) 2015 Shu Zhang. All rights reserved.
//

#import "cloudsView.h"

@implementation cloudsView
{
    CGFloat itemCloud1 ;
    CGFloat itemCloud2 ;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self animaInit];
    }
    return self;
}

-(void)animaInit
{
    itemCloud1 = 1;
    itemCloud2 = 2;
    self.backgroundColor = [UIColor clearColor];
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    //调用setNeedsDisplay会自动调用drawRect 重绘机制
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}

-(void)drawRect:(CGRect)rect
{
    self.cloud1P -= itemCloud1;
    if (self.cloud1P <= -150) {
        self.cloud1P = 350;
    }
    UIImage *imageC1 = [UIImage imageNamed:@"cloud1"];
    [imageC1 drawInRect:CGRectMake(self.cloud1P, 55,85, 50)];
    
    self.cloud2P -= itemCloud2;
    if (self.cloud2P <= -50) {
        self.cloud2P = 320;
    }
    UIImage *imageC2 = [UIImage imageNamed:@"cloud2"];
    [imageC2 drawInRect:CGRectMake(self.cloud2P, 130, 85, 50)];
}

@end
