//
//  GLChartCellLayer.h
//  GLLineChartView
//
//  Created by 周 华平 on 14-3-19.
//  Copyright (c) 2014年 ganlvji. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

struct GLChartLine {
    CGFloat startPoint;
    CGFloat mainPoint;
    CGFloat endPoint;
};
typedef struct GLChartLine GLChartLine;

CG_INLINE GLChartLine
GLChartLineMake(CGFloat startPoint, CGFloat mainPoint,CGFloat endPoint)
{
    GLChartLine line;
    line.startPoint = startPoint;
    line.mainPoint = mainPoint;
    line.endPoint = endPoint;
    return line;
}


@interface GLChartCellLayer : CALayer


@property (nonatomic,assign) GLChartLine chartLine;
@property (nonatomic,assign) CGColorRef lineColor;
@property (nonatomic,assign) BOOL showStart;
@property (nonatomic,assign) BOOL showEnd;
@property (nonatomic,assign) GLChartLine oldChartLine;

-(void)setTargetChartLine:(GLChartLine)chartLine  targetOldChartLine:(GLChartLine)oldChartLine animate:(BOOL)animate;

@end
