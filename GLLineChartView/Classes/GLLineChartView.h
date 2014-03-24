//
//  GLLineChartView.h
//  GLLineChartView
//
//  Created by 周 华平 on 14-3-19.
//  Copyright (c) 2014年 ganlvji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCollectionViewLayout.h"
#import "GLChartCell.h"
#import "GLCollectionHeader.h"
@class GLLineChartView;

@protocol GLLineChartViewDataSource <NSObject>
//collection view's index path

@required

-(NSInteger)numbeOfSections:(GLLineChartView*)lineChartView;
-(NSInteger)lineChartView:(GLLineChartView*)lineChartView numberOfItemsInSection:(NSInteger)section;

-(GLChartDomain*)lineChartView:(GLLineChartView*)lineChartView chartDomainOfIndex:(NSIndexPath*)indexPath;

@end

@interface GLLineChartView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
}
@property (nonatomic,assign) id<GLLineChartViewDataSource> dataSource;

-(void)reloadData;

-(void)updateVisible;

-(void)rotationSubViews;

-(void)goToday:(BOOL)animate;

@end
