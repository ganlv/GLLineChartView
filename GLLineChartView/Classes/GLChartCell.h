//
//  GLCollectionView.h
//  GLLineChartView
//
//  Created by 周 华平 on 14-3-19.
//  Copyright (c) 2014年 ganlvji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLChartCellLayer.h"
#import "GLChartDomain.h"
#define degreesToRadians(x) (M_PI*(x)/180.0)
#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width

@interface GLChartCell : UICollectionViewCell

-(void)setChartLine:(GLChartLine)chartLine oldChartLine:(GLChartLine)oldChartLine showStart:(BOOL)showStart showEnd:(BOOL)showEnd;
-(void)setWeek:(NSString*)week day:(NSString*)day;
-(void)needEndHeadLine:(BOOL)needHeadLine;
@end
