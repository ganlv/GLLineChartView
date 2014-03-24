//
//  GLCollectionViewLayout.h
//  GLLineChartView
//
//  Created by 周 华平 on 14-3-20.
//  Copyright (c) 2014年 ganlvji. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GLCollectionViewLayoutTop;

@protocol UICollectionViewDelegateDelegate <UICollectionViewDelegate>
@optional
-(CGSize)cellWith:(UICollectionView*)collectionView;

@end

@interface GLCollectionViewLayout : UICollectionViewFlowLayout

@end
