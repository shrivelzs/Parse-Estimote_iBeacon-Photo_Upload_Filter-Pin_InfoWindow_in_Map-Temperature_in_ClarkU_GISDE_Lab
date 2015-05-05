
//
//  twinkleLabel.m
//  twinkleLabel
//
//  Created by Shu Zhang on 4/27/15.
//  Copyright (c) 2015 Shu Zhang. All rights reserved.
//

#import "twinkleLabel.h"

@interface twinkleLabel()
@property (nonatomic, strong) UILabel *backGroundLabel;
@property (nonatomic, strong) UILabel *coloredLabel;



@end

@implementation twinkleLabel


-(instancetype)initWithFrame:(CGRect)frame//override initWithFrame function
{
    self = [super initWithFrame:frame];
    if (self) {
        _backGroundLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _coloredLabel = [[UILabel alloc]initWithFrame:self.bounds];
        
        //these two labels should be transparent at the beginning
        //_backGroundLabel.alpha = 0;
        _coloredLabel.alpha = 1.f;
        
        _backGroundLabel.textAlignment = NSTextAlignmentCenter;
        _coloredLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_backGroundLabel];
        [self addSubview:_coloredLabel];
    }
    return self;
    
}

-(void)startAnimation
{
    if (_scaleAfterTwinkle == 0) {
        _scaleAfterTwinkle = 2.0f;
    }
    
    //begin the first animation
    [UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:7.0f initialSpringVelocity:4.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _coloredLabel.alpha = 0.f;
        _coloredLabel.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    } completion:^(BOOL finished) {
        _coloredLabel.alpha = 1.f;
        _coloredLabel.transform = CGAffineTransformMakeScale(1.f, 1.f);
        
    }];
    
}



#pragma mark - override setter

-(void)setLabelColor:(UIColor *)LabelColor
{
    _backGroundLabel.textColor = LabelColor;
    _coloredLabel.textColor = LabelColor;
}

-(void)setLabelText:(NSString *)labelText
{
    //_labelText = labelText;
    _backGroundLabel.text = labelText;
    _coloredLabel.text = labelText;
}

-(void)setLabelFont:(UIFont *)labelFont
{
    _backGroundLabel.font = labelFont;
    _coloredLabel.font = labelFont;
}

-(void)setRetainLabelColor:(UIColor *)retainLabelColor
{
    _backGroundLabel.textColor = retainLabelColor;
}

-(void)setVanishLabelColor:(UIColor *)vanishLabelColor
{
    _coloredLabel.textColor = vanishLabelColor;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
