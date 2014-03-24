//
//  GLCollectionViewLayout.m
//  GLLineChartView
//
//  Created by 周 华平 on 14-3-20.
//  Copyright (c) 2014年 ganlvji. All rights reserved.
//

#import "GLCollectionViewLayout.h"
#define STATUS_BAR_OFFSET 0

NSString *const GLCollectionViewLayoutTop = @"GLCollectionViewLayoutTop";
@interface GLCollectionViewLayout ()
{
    NSMutableDictionary *_indexDictionary;
}

@end
@implementation GLCollectionViewLayout

-(CGSize)cellSize
{
    return CGSizeMake(50, self.collectionView.bounds.size.height);
}
-(CGFloat)cellWidth
{
    return 50;
}
-(CGFloat)headerHeight
{
    return 32;
}

-(void)prepareLayout
{
    [super prepareLayout];
    _indexDictionary = [NSMutableDictionary dictionary];
    NSInteger index  =  0;
    for (NSInteger section = 0;section < [self.collectionView numberOfSections] ; section ++) {
        for (NSInteger item = 0 ; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            [_indexDictionary setObject:indexPath forKey:[NSNumber numberWithInteger:index]];
            index++;
        }
    }
}
-(CGSize)collectionViewContentSize
{
    NSInteger sectionNumber = [self.collectionView numberOfSections];
    CGFloat width = 0 ;
    for(NSInteger section =0;section < sectionNumber;section++){
        NSInteger items = [self.collectionView numberOfItemsInSection:section];
        width = width + items*[self cellWidth];
    }
    return  CGSizeMake(width, self.collectionView.bounds.size.height);
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath
{
    return [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:elementIndexPath];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [self preLayoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    attribute = [self postLayoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    return attribute;
}

-(UICollectionViewLayoutAttributes *)preLayoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attribute  =  [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    CGFloat offsetX = 0;
    
    for (NSInteger section = 0; section < indexPath.section ; section ++) {
        NSInteger itemsNumber =[ self.collectionView numberOfItemsInSection:section];
        CGFloat sectionWith = [self cellWidth] * itemsNumber;
        offsetX = offsetX + sectionWith;
    }
    
    NSInteger thisIndexPathItems =[ self.collectionView numberOfItemsInSection:indexPath.section];
    CGFloat sectionWith = [self cellWidth] * thisIndexPathItems;
    attribute.frame = CGRectMake(offsetX, STATUS_BAR_OFFSET,sectionWith , [self headerHeight]);
    return attribute;
}

-(UICollectionViewLayoutAttributes *)postLayoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [self preLayoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    CGRect preFrame = attribute.frame;
    
    CGFloat offsetX = preFrame.origin.x;
    CGFloat width = preFrame.size.width;
    if(width > self.collectionView.bounds.size.width){
        width = self.collectionView.bounds.size.width;
    }
    
    CGFloat startXOffset = self.collectionView.contentOffset.x;
    NSInteger startIndex = startXOffset/[self cellWidth];
    //end offset
    CGFloat endXOffset = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width;
    NSInteger endIndex = endXOffset/[self cellWidth];
    
    NSIndexPath *minIndexPath = [_indexDictionary objectForKey:[NSNumber numberWithInteger:startIndex]];
    NSInteger minSection = [minIndexPath section];

    NSIndexPath *maxIndexPath = [_indexDictionary objectForKey:[NSNumber numberWithInteger:endIndex]];
    NSInteger maxSection = [maxIndexPath section];
    

    if(indexPath.section == minSection && indexPath.section  == maxSection){
        offsetX =  self.collectionView.contentOffset.x;
    }else if(indexPath.section == minSection && indexPath.section != maxSection){
        NSIndexPath *nextSection = [NSIndexPath indexPathForItem:0 inSection:(minSection+1)];
        UICollectionViewLayoutAttributes  *nextAttribute  = [self layoutAttributesForItemAtIndexPath:nextSection];
        width =nextAttribute.frame.origin.x - self.collectionView.contentOffset.x;
        if(width < [self cellWidth]){
            width = [self cellWidth];
        }
        offsetX = nextAttribute.frame.origin.x - width;
        
    }else if(indexPath.section != minSection &&  indexPath.section == maxSection){
        NSIndexPath *nextSection = [NSIndexPath indexPathForItem:0 inSection:maxSection];
        UICollectionViewLayoutAttributes  *nextAttribute  = [self layoutAttributesForItemAtIndexPath:nextSection];
        width = self.collectionView.contentOffset.x+self.collectionView.bounds.size.width - nextAttribute.frame.origin.x;
        if(width < [self cellWidth]){
            width = [self cellWidth];
        }
    }
    attribute.frame = CGRectMake(offsetX, STATUS_BAR_OFFSET,width , [self headerHeight]);
    return attribute;
}



- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}



-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attrs = [NSMutableArray array];
    //start offset
    CGFloat startXOffset = rect.origin.x;
    NSInteger startIndex = startXOffset/[self cellWidth] -1;
    if(startIndex < 0){
        startIndex = 0;
    }
    //end offset
    CGFloat endXOffset = rect.origin.x + rect.size.width;
    NSInteger endIndex= endXOffset/[self cellWidth];
    if(endXOffset < [self.collectionView contentSize].width){
         endIndex = endIndex + 1;
    }
    
    //for update index
    for (NSInteger index  = startIndex; index <= endIndex  ;  ++index) {
        NSIndexPath *indexPath = [_indexDictionary objectForKey:[NSNumber numberWithInteger:index]];
        if(indexPath == nil){
            continue;
        }
        if(indexPath.item == 0 || index == startIndex){
            UICollectionViewLayoutAttributes *sectionAttr = [self layoutAttributesForSupplementaryViewOfKind:GLCollectionViewLayoutTop atIndexPath:indexPath];
            [attrs addObject:sectionAttr];
        }
        UICollectionViewLayoutAttributes *itemAttr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attrs addObject:itemAttr];
    }
    return attrs;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute =  [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat offsetX = 0;
    for (NSInteger section = 0; section < indexPath.section ; section ++) {
        NSInteger itemNumber =[ self.collectionView numberOfItemsInSection:section];
        offsetX = offsetX + 50*itemNumber;
    }
    offsetX = offsetX + indexPath.item * 50;
    
    attribute.frame = CGRectMake(offsetX, 0, 50, self.collectionView.bounds.size.height);
    
    return attribute;
}

@end
