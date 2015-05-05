//
//  twinkleLabel.h
//  twinkleLabel
//
//  Created by Shu Zhang on 4/27/15.
//  Copyright (c) 2015 Shu Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface twinkleLabel :UILabel
@property (nonatomic, strong) NSString *labelText;

@property (nonatomic, strong) UIFont *labelFont;

@property (nonatomic, assign) CGFloat scaleBeforeTwinkle;//label size will be magnified when twinkling

@property(nonatomic, assign) CGFloat scaleAfterTwinkle;

@property(nonatomic, copy) UIColor *LabelColor;//The color of label;



-(void)startAnimation;
//-(void)labelStartTwinkle;

@end
