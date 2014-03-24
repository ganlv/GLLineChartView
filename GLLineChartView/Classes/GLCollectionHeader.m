//
//  GLCollectionHeader.m
//  GLLineChartView
//
//  Created by 周 华平 on 14-3-20.
//  Copyright (c) 2014年 ganlvji. All rights reserved.
//

#import "GLCollectionHeader.h"

@interface GLCollectionHeader()
{
    UILabel *_label;
}
@end

@implementation GLCollectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initial];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initial];
    }
    return self;
}
-(void)initial
{    
    _label = [[UILabel alloc] initWithFrame:self.bounds];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:18];
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_label];
}

-(void)setTitle:(NSString *)title
{
    _label.text = title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
