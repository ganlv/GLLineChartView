//
//  GLLandViewController.m
//  GLLineChartView
//
//  Created by 周 华平 on 14-3-21.
//  Copyright (c) 2014年 ganlvji. All rights reserved.
//

#import "GLLandViewController.h"

@interface GLLandViewController ()

@end

@implementation GLLandViewController


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait ||
       self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
