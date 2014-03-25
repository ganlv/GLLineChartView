GLLineChartView
===============
<div>
line chart view for good animation,need ios 6 and later
</div>
<div>
<img src="http://img.ganlvji.com/2014/03/linchart1.png!320.jpg"/>
</div>
<div>

<pre>
@protocol GLLineChartViewDataSource <NSObject>
//collection view's index path
@required
-(NSInteger)numbeOfSections:(GLLineChartView*)lineChartView;
-(NSInteger)lineChartView:(GLLineChartView*)lineChartView numberOfItemsInSection:(NSInteger)section;
-(GLChartDomain*)lineChartView:(GLLineChartView*)lineChartView chartDomainOfIndex:(NSIndexPath*)indexPath;
-(NSString*)lineChartView:(GLLineChartView*)lineChartView titleOfIndex:(NSIndexPath*)indexPath;
@end
</pre>

</div>
