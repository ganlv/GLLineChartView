//
//  GLViewController.m
//  GLLineChartView
//
//  Created by 周 华平 on 14-3-19.
//  Copyright (c) 2014年 ganlvji. All rights reserved.
//

#import "GLViewController.h"
#import "GLChartCell.h"
#import "GLCollectionHeader.h"
#import "GLLandViewController.h"

@interface GLViewController ()
{
    NSMutableArray *_points;
}
@end

@implementation GLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }

    
    [self initData];
    
    self.lineChartView.dataSource = self;
    [self.lineChartView reloadData];
   
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(orientationChanged:)     name:UIDeviceOrientationDidChangeNotification  object:[UIDevice currentDevice] ];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.lineChartView goToday:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

-(void)orientationChanged:(NSNotification*)notification
{
    UIDevice *device =  notification.object;
    UIDeviceOrientation orientation  = device.orientation;
    
    if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ){
        _lineChartView.bounds = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        _lineChartView.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2);
        [_lineChartView rotationSubViews];
        
        [UIView animateWithDuration:0.3 animations:^{
            if(orientation == UIDeviceOrientationLandscapeLeft){
                CATransform3D transformFromChartView = CATransform3DMakeRotation(degreesToRadians(90), 0, 0, 1.0);
                _lineChartView.layer.transform  = transformFromChartView;
                
            }else if(orientation == UIDeviceOrientationLandscapeRight){
                CATransform3D transformFromChartView = CATransform3DMakeRotation(degreesToRadians(-90), 0, 0, 1.0);
                _lineChartView.layer.transform  = transformFromChartView;
            }
        }];
    }else{
         _lineChartView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_lineChartView rotationSubViews];
        [_lineChartView reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            _lineChartView.layer.transform  = CATransform3DIdentity;
        }];
    }
}

-(void)initData
{
    _points = [[NSMutableArray alloc] init];

    for (int j=0; j< 12; j++) {
        NSMutableArray *innerPoints = [NSMutableArray array];

        int randomCount = arc4random() %10 +2;
        for (int i = 0; i <randomCount ; i++) {
            CGFloat red  = arc4random()%30+60;
            CGFloat oldRed =arc4random()%20 +30;
            
            GLChartDomain *chartDomain =[[GLChartDomain alloc] init];
            NSCalendar *calendar =[NSCalendar currentCalendar];
            NSDateComponents *component = [[NSDateComponents alloc] init];
            component.year = 2014;
            component.month = j+1;
            component.day = i + 12;
            NSDate *date = [calendar  dateFromComponents:component];
            component = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitDay  fromDate:date];
            NSString *week =  [self weekStringFromNumber:component.weekday];
            NSString *day =  [NSString stringWithFormat:@"%ld",(long)component.day];

            chartDomain.nowPercent = red;
            chartDomain.oldPercent = oldRed;
            chartDomain.mainText = week;
            chartDomain.detailText = day;
            [innerPoints addObject:chartDomain];
        }
        [_points addObject:innerPoints];
    }
}

-(void)updateData
{
    NSArray *_pointArray = [_points copy];
    [_points removeAllObjects];
    
    for (int j=0; j< [_pointArray count]; j++) {
        
        NSMutableArray *innerPoints = [NSMutableArray array];
        
        for (int i = 0; i < [[_pointArray objectAtIndex:j] count]   ; i++) {
            CGFloat red  = arc4random()%30+60;
            CGFloat oldRed =arc4random()%20 +30;
            NSCalendar *calendar =[NSCalendar currentCalendar];
            NSDateComponents *component = [[NSDateComponents alloc] init];
            component.year = 2014;
            component.month = j+1;
            component.day = i + 12;
            NSDate *date = [calendar  dateFromComponents:component];
            component = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitDay  fromDate:date];

            NSString *week =  [self weekStringFromNumber:component.weekday];
            NSString *day =  [NSString stringWithFormat:@"%ld",(long)component.day];

            GLChartDomain *chartDomain =[[GLChartDomain alloc] init];
            chartDomain.nowPercent = red;
            chartDomain.oldPercent = oldRed;
            chartDomain.mainText = week;
            chartDomain.detailText = day;
            [innerPoints addObject:chartDomain];
        }
        [_points addObject:innerPoints];
    }
    [_lineChartView updateVisible];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)button:(id)sender {
    [self updateData];
}
#pragma mark datasource
-(NSInteger)numbeOfSections:(GLLineChartView*)lineChartView
{
    return [_points count];
}
-(NSInteger)lineChartView:(GLLineChartView*)lineChartView numberOfItemsInSection:(NSInteger)section
{
    return [[_points objectAtIndex:section] count];
}

-(GLChartDomain*)lineChartView:(GLLineChartView*)lineChartView chartDomainOfIndex:(NSIndexPath*)indexPath
{
    NSArray *_subPoints =  [_points objectAtIndex:indexPath.section];
    if(indexPath.item >= [_subPoints count]){
        return nil;
    }
    return [_subPoints objectAtIndex:indexPath.item];
}

-(NSString*)lineChartView:(GLLineChartView *)lineChartView titleOfIndex:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%ld月",indexPath.section+1];
}

-(NSString*)weekStringFromNumber:(NSInteger)number
{
    switch (number) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
        case 3:
            return @"周二";
        case 4:
            return @"周三";
        case 5:
            return @"周四";
        case 6:
            return @"周五";
        case 7:
            return @"周六";
        default:
            break;
    }
    return nil;
}

#pragma mark rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return NO;
}

// New Autorotation support.
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)switchData:(id)sender {
    [self updateData];
}

- (IBAction)today:(id)sender {
    [self.lineChartView goToday:YES];
}
@end
