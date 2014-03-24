//
//  GLChartCellLayer.m
//  GLLineChartView
//
//  Created by 周 华平 on 14-3-19.
//  Copyright (c) 2014年 ganlvji. All rights reserved.
//

#import "GLChartCellLayer.h"


@interface GLChartCellLayer()
{
    NSDate *_startDate;
    GLChartLine _targetChartLine;
    GLChartLine _startChartLine;
    
    GLChartLine _oldTargetChartLine;
    GLChartLine _oldStartChartLine;
}
@end

@implementation GLChartCellLayer
@synthesize chartLine;
@synthesize lineColor;
@synthesize showStart;
@synthesize showEnd;
@synthesize oldChartLine;

+(BOOL)needsDisplayForKey:(NSString *)key
{
    if( [key isEqualToString:@"chartLine"]){
        return YES;
    }else{
        return [super needsDisplayForKey:key];
    }
}

-(void)setTargetChartLine:(GLChartLine)achartLine  targetOldChartLine:(GLChartLine)aoldChartLine animate:(BOOL)animate
{
    if(animate && (chartLine.startPoint != 0 || chartLine.endPoint != 0 || chartLine.mainPoint !=0) ){
        _targetChartLine = achartLine;
        _startChartLine = chartLine;
        _startDate = [NSDate date];
        _oldTargetChartLine = aoldChartLine;
        _oldStartChartLine =oldChartLine;
        
        CADisplayLink *_display =[CADisplayLink displayLinkWithTarget:self selector:@selector(animateChartLine:)];
        [_display addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }else{
        chartLine = achartLine;
        oldChartLine = aoldChartLine;
        [self setNeedsDisplay];
    }
}


-(void)animateChartLine:(CADisplayLink *)sender
{
    NSTimeInterval timeDuration = 0.3;//300毫秒
    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:_startDate];
    if(duration >= timeDuration){
        chartLine = _targetChartLine;
        oldChartLine = _oldTargetChartLine;
        [self setNeedsDisplay];
        [sender invalidate];
        return;
    }
    CGFloat nowStart = _startChartLine.startPoint + (duration/timeDuration)*(_targetChartLine.startPoint - _startChartLine.startPoint);
    CGFloat nowMain = _startChartLine.mainPoint + (duration/timeDuration)*(_targetChartLine.mainPoint - _startChartLine.mainPoint);
    CGFloat endMain = _startChartLine.endPoint + (duration/timeDuration)*(_targetChartLine.endPoint - _startChartLine.endPoint);
    chartLine = GLChartLineMake(nowStart, nowMain, endMain);
    
    CGFloat oldNowStart = _oldStartChartLine.startPoint + (duration/timeDuration)*(_oldTargetChartLine.startPoint - _oldStartChartLine.startPoint);
    CGFloat oldNowMain = _oldStartChartLine.mainPoint + (duration/timeDuration)*(_oldTargetChartLine.mainPoint - _oldStartChartLine.mainPoint);
    CGFloat oldEndMain = _oldStartChartLine.endPoint + (duration/timeDuration)*(_oldTargetChartLine.endPoint - _oldStartChartLine.endPoint);
    oldChartLine = GLChartLineMake(oldNowStart, oldNowMain, oldEndMain);
    
    [self setNeedsDisplay];
}

-(void)drawInContext:(CGContextRef)ctx
{
    CGSize size = self.bounds.size;
    
    CGContextSetStrokeColorWithColor(ctx,  lineColor);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 1);
    
    CGFloat mainY =chartLine.mainPoint;
    if(showStart){
        CGFloat startY = chartLine.startPoint;
        startY =  startY - (mainY-startY)/size.width*2;
        CGContextMoveToPoint(ctx, -1,startY);
        CGContextAddLineToPoint(ctx, size.width/2,mainY);
    }else{
        CGContextMoveToPoint(ctx, size.width/2, mainY);
    }
    if(showEnd){
        CGFloat endY  = chartLine.endPoint;
        endY = endY - (mainY - endY)/size.width*2;
        CGContextAddLineToPoint(ctx, size.width+1, endY);
    }
    CGContextStrokePath(ctx);
    CGContextSaveGState(ctx);
    
    CGPoint mainCenter = CGPointMake(size.width/2, mainY);
    CGSize centerSize =  CGSizeMake(8, 8);
    CGRect bigCircle =  CGRectMake(mainCenter.x-centerSize.width/2, mainCenter.y - centerSize.height/2, centerSize.width, centerSize.height);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithWhite:1 alpha:0.5 ] CGColor]);
    CGContextAddEllipseInRect(ctx, bigCircle);
    CGContextFillPath(ctx);
    CGContextSaveGState(ctx);
    
    CGSize smallCenterSize =  CGSizeMake(4, 4);
    CGRect smallCircle =  CGRectMake(mainCenter.x-smallCenterSize.width/2, mainCenter.y - smallCenterSize.height/2, smallCenterSize.width, smallCenterSize.height);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithWhite:1 alpha:0.8 ] CGColor]);
    CGContextAddEllipseInRect(ctx, smallCircle);
    CGContextFillPath(ctx);
    CGContextSaveGState(ctx);
    
    [self drawGradientAreaInContext:ctx];
}

-(void)drawGradientAreaInContext:(CGContextRef)ctx
{
    CGSize size = self.bounds.size;
    CGFloat colors [] = {
        1.0, 1.0, 1.0, 0.5,
        1.0, 1.0, 1.0, 0
    };
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace);
    
    CGContextSetStrokeColorWithColor(ctx,  lineColor);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGFloat mainY =oldChartLine.mainPoint;
    CGFloat startY = 0;
    if(showStart){
        startY = oldChartLine.startPoint;
        startY =  startY - (mainY-startY)/size.width*2;
    }else{
        startY = mainY;
    }
    CGContextMoveToPoint(ctx, -1,startY);
    CGContextAddLineToPoint(ctx,size.width/2,mainY);

    CGFloat endY = 0;
    if(showEnd){
        endY  = oldChartLine.endPoint;
        endY = endY - (mainY - endY)/size.width*2;
    }else{
        endY = mainY;
    }
    CGContextAddLineToPoint(ctx, size.width + 1, endY);
    CGContextAddLineToPoint(ctx, size.width + 1, size.height);
    CGContextAddLineToPoint(ctx, -1, size.height);
    CGContextAddLineToPoint(ctx, -1, startY);
    
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    
    CGContextSaveGState(ctx);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)/2);
    CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    CGContextDrawLinearGradient(ctx, gradient, startPoint,endPoint, 0);
    CGContextDrawPath(ctx, kCGPathFill);
    CGGradientRelease(gradient);
}


@end
