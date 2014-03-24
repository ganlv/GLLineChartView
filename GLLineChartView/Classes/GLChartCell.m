//
//  GLCollectionView.m
//  GLLineChartView
//
//  Created by 周 华平 on 14-3-19.
//  Copyright (c) 2014年 ganlvji. All rights reserved.
//

#import "GLChartCell.h"
#import "GLChartCellLayer.h"

#define  CHART_CELL_TOP_OFFSET 32
#define  CHART_DAY_TOP_OFFSET 48
#define  CHART_HEAD_HEIGHT 32

@interface GLChartCell ()
{
    UILabel *_dayLabel;
    UILabel *_weekDayLabel;
    UIView *_lineView;
    BOOL *_isShowingHead;
}
@end

@implementation GLChartCell

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
    CGSize size = self.frame.size;
    self.backgroundColor = [UIColor clearColor];
    NSInteger randomHeight = size.height/6;
    randomHeight =  arc4random()%randomHeight;
    
    _isShowingHead = NO;
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(size.width -1, CHART_CELL_TOP_OFFSET, 1, size.height/3+randomHeight)];
    _lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [self addSubview:_lineView];
    
    _weekDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CHART_CELL_TOP_OFFSET, size.width, 16)];
    _weekDayLabel.backgroundColor = [UIColor  clearColor];
    _weekDayLabel.textAlignment = NSTextAlignmentCenter;
    _weekDayLabel.font = [UIFont systemFontOfSize:14.0];
    _weekDayLabel.textColor = [UIColor whiteColor];
    _weekDayLabel.alpha = 0.5;
    [self addSubview:_weekDayLabel];
    
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CHART_DAY_TOP_OFFSET, size.width, 32)];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.backgroundColor = [UIColor  clearColor];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.font = [UIFont systemFontOfSize:24.0];
    _dayLabel.textColor = [UIColor whiteColor];
    _dayLabel.alpha = 0.5;
    [self addSubview:_dayLabel];
}
-(void)didMoveToWindow
{
    CGFloat windowContentsScale = self.window.screen.scale;
    self.layer.contentsScale = windowContentsScale;
    [self.layer setNeedsDisplay];
}

+(Class)layerClass
{
    return [GLChartCellLayer class];
}
-(GLChartCellLayer*)selfLayer
{
    return (GLChartCellLayer*)self.layer;
}
-(void)layoutSubviews
{
    CGSize size = self.bounds.size;
    NSInteger randomHeight = size.height/6;
    randomHeight =  arc4random()%randomHeight;
    _lineView.frame = CGRectMake(size.width -1, CHART_CELL_TOP_OFFSET, 1, size.height/3+randomHeight);
}

-(void)needEndHeadLine:(BOOL)needHeadLine
{
    CGRect rawFrame =  _lineView.frame;

    if(needHeadLine){
        _lineView.frame=CGRectMake(rawFrame.origin.x, CHART_CELL_TOP_OFFSET-CHART_HEAD_HEIGHT, 1, rawFrame.size.height );
    }else{
        _lineView.frame=CGRectMake(rawFrame.origin.x, CHART_CELL_TOP_OFFSET, 1, rawFrame.size.height);
    }
}
-(void)setChartLine:(GLChartLine)chartLine oldChartLine:(GLChartLine)oldChartLine showStart:(BOOL)showStart showEnd:(BOOL)showEnd
{
    GLChartCellLayer *layer  = [self selfLayer];
    [layer setLineColor:[[UIColor whiteColor] CGColor]];
    [layer setTargetChartLine:chartLine targetOldChartLine:oldChartLine  animate:YES];
    [layer setShowStart:showStart];
    [layer setShowEnd:showEnd];
    [layer setNeedsDisplay];
}
-(void)setWeek:(NSString *)week day:(NSString *)day
{
    [_weekDayLabel setText:week];
    [_dayLabel setText:day];
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    [[self selfLayer] setTargetChartLine:GLChartLineMake(0, 0, 0)  targetOldChartLine:GLChartLineMake(0, 0, 0)  animate:NO];
}


@end
