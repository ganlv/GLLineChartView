//
//  GLLineChartView.m
//  GLLineChartView
//
//  Created by 周 华平 on 14-3-19.
//  Copyright (c) 2014年 ganlvji. All rights reserved.
//

#import "GLLineChartView.h"
@interface GLLineChartView()
@end

#define  CELL_INDENTIFIER @"ChartCell"
#define  HEAD_INDENTIFIER @"ChartHeader"

@implementation GLLineChartView
@synthesize dataSource;

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
    if(self){
        [self initial];
    }
    return self;
}

-(void)initial
{
    self.backgroundColor = [UIColor blueColor];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[[GLCollectionViewLayout alloc] init] ];
    _collectionView.backgroundColor = [UIColor blueColor];
    [_collectionView registerClass:[GLChartCell class] forCellWithReuseIdentifier:CELL_INDENTIFIER];
    [_collectionView registerClass:[GLCollectionHeader class] forSupplementaryViewOfKind:GLCollectionViewLayoutTop withReuseIdentifier:HEAD_INDENTIFIER];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
    [self sendSubviewToBack:_collectionView];
}
#pragma mark private method


#pragma mark public method
-(void)reloadData
{
    [_collectionView reloadData];
}
-(void)updateVisible
{
    NSArray *visibleIndexPaths = [_collectionView indexPathsForVisibleItems];
    for(NSIndexPath *indexPath  in visibleIndexPaths){
        GLChartCell *chartCell = (GLChartCell*)[_collectionView cellForItemAtIndexPath:indexPath];
        [self setCell:chartCell indexPath:indexPath];
    }
}
-(void)goToday:(BOOL) animate
{
    NSInteger lastSection  = [self numberOfSections] -1;
    NSInteger lastItemIndex = [self numberOfitemsInSection:lastSection] - 1;
    NSIndexPath *lastIndex = [NSIndexPath indexPathForItem:lastItemIndex inSection:lastSection];
    [_collectionView scrollToItemAtIndexPath:lastIndex atScrollPosition:UICollectionViewScrollPositionLeft animated:animate];
}

#pragma mark collection view delegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    GLCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEAD_INDENTIFIER forIndexPath:indexPath];
    NSString *title = [dataSource lineChartView:self titleOfIndex:indexPath];
    [header setTitle:title];
    return header;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfitemsInSection:section];
}

-(NSInteger)numberOfSections
{
    return [dataSource numbeOfSections:self];
}
-(NSInteger)numberOfitemsInSection:(NSInteger)section
{
    return [dataSource lineChartView:self numberOfItemsInSection:section];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GLChartCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:CELL_INDENTIFIER forIndexPath:indexPath];
    [self setCell:cell  indexPath:indexPath];
    return cell;
}


-(void)setCell:(GLChartCell*)cell indexPath:(NSIndexPath*)indexPath
{
    NSIndexPath *preIndex  = [self preIndex:indexPath];
    NSIndexPath *nextIndex = [self nextIndexPath:indexPath];
    
    GLChartDomain *preDomain = nil;
    if(preIndex != nil){
        preDomain =[self chartDomainOfIndex:preIndex];
    }
   
    GLChartDomain *currentDomain = [self chartDomainOfIndex:indexPath];
    GLChartDomain *nextDomain = nil;
    if(nextIndex != nil){
        nextDomain   = [self chartDomainOfIndex:nextIndex];
    }
    
    CGFloat startPoint = 0;
    CGFloat oldStartPoint = 0;
    if (preDomain!=nil) {
        startPoint = preDomain.nowPercent;
        oldStartPoint = preDomain.oldPercent;
    }else{
        startPoint = currentDomain.nowPercent;
        oldStartPoint = currentDomain.oldPercent;
    }
    startPoint = [self convertPercentToPosition:startPoint]; // 转换成位置
    oldStartPoint = [self convertPercentToPosition:oldStartPoint];
    
    CGFloat mainPoint = [self convertPercentToPosition:currentDomain.nowPercent];
    CGFloat oldMainPoint = [self convertPercentToPosition:currentDomain.oldPercent];
    
    CGFloat endPoint = 0;
    CGFloat oldEndPoint = 0;
    if(nextDomain  != nil){
        endPoint = nextDomain.nowPercent;
        oldEndPoint = nextDomain.oldPercent;
    }else {
        endPoint = currentDomain.nowPercent;
        oldEndPoint = currentDomain.oldPercent;
    }
    endPoint = [self convertPercentToPosition:endPoint];
    oldEndPoint = [self convertPercentToPosition:oldEndPoint];
    
    GLChartLine chartLine = GLChartLineMake((startPoint+mainPoint)/2, mainPoint, (mainPoint +endPoint)/2);
    GLChartLine oldChartLine = GLChartLineMake((oldStartPoint + oldMainPoint)/2,oldMainPoint, (oldMainPoint + oldEndPoint)/2);
    
    
    [cell setChartLine:chartLine  oldChartLine:oldChartLine showStart:[self needShowStart:indexPath]  showEnd:[self needShowEnd:indexPath]];
    
    
    [cell setMain:currentDomain.mainText detail:currentDomain.detailText];
    [cell needEndHeadLine:[self isSectionLastItem:indexPath]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark for data source private
-(GLChartDomain*)chartDomainOfIndex:(NSIndexPath*)indexPath
{
    if(indexPath == nil){
        return nil;
    }
    return [dataSource lineChartView:self chartDomainOfIndex:indexPath];
}

-(NSIndexPath*)preIndex:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0 && indexPath.item == 0) {
        return nil;
    }
    if(indexPath.item == 0){
        NSInteger preSection = indexPath.section -1;
        NSInteger preItems = [self numberOfitemsInSection:preSection] - 1;
        return [NSIndexPath indexPathForItem:preItems inSection:preSection];
    }
    NSInteger preItem = indexPath.item - 1;
    return [NSIndexPath indexPathForItem:preItem inSection:indexPath.section];
}

-(NSIndexPath*)nextIndexPath:(NSIndexPath*)indexPath
{
    NSInteger section = [self numberOfSections];
    NSInteger itemCount = [self numberOfitemsInSection:indexPath.section];
    //is last index
    if(itemCount == indexPath.item+1 && section == indexPath.section+1 ){
        return nil;
    }
    if (indexPath.item+1 == itemCount) {
        NSInteger nextSection = indexPath.section + 1;
        return [NSIndexPath indexPathForItem:0 inSection:nextSection];
    }
    return [NSIndexPath indexPathForItem:(indexPath.item+1) inSection:indexPath.section];
}
-(CGFloat)convertPercentToPosition:(CGFloat)percent
{
    return  _collectionView.bounds.size.height -  percent/100*(_collectionView.bounds.size.height-80) ;
}
-(BOOL)needShowStart:(NSIndexPath*)indexPath
{
    return indexPath.item != 0 || indexPath.section != 0;
}
-(BOOL)needShowEnd:(NSIndexPath*)indexPath
{
    NSInteger lastSection  = [self numberOfSections] -1;
    NSInteger lastItem = [self numberOfitemsInSection:lastSection] -1;
    
    return  indexPath.item !=lastItem  || indexPath.section != lastSection ;
}

-(BOOL)isSectionLastItem:(NSIndexPath*)indexPath
{
    NSInteger lastItem = [self numberOfitemsInSection:indexPath.section] -1;
    return  indexPath.item == lastItem;
}

-(void)rotationSubViews
{
     NSIndexPath *showIndexPath = [[_collectionView indexPathsForVisibleItems] lastObject];
    _collectionView.bounds = self.bounds;
    _collectionView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:showIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

@end
