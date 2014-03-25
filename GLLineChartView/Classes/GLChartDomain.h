//
//  GLChartDomain.h
//  GLLineChartView
//
//  Created by 周 华平 on 14-3-23.
//  Copyright (c) 2014年 ganlvji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLChartDomain : NSObject

@property (nonatomic,retain) NSString *mainText;
@property (nonatomic,retain) NSString *detailText;

@property (nonatomic,assign) CGFloat oldPercent;
@property (nonatomic,assign) CGFloat nowPercent;

@end
