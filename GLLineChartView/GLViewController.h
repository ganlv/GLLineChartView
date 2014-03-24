//
//  GLViewController.h
//  GLLineChartView
//
//  Created by 周 华平 on 14-3-19.
//  Copyright (c) 2014年 ganlvji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLLineChartView.h"
#import "GLCollectionViewLayout.h"

@interface GLViewController : UIViewController<GLLineChartViewDataSource>

@property (strong, nonatomic) IBOutlet GLLineChartView *lineChartView;

- (IBAction)switchData:(id)sender;
- (IBAction)today:(id)sender;

@end
