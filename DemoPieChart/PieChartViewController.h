//
//  PieChartViewController.h
//  DemoPieChart
//
//  Created by Ivan on 14-9-18.
//  Copyright (c) 2014年 ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface PieChartViewController : UIViewController<CPTPlotDataSource>

{
    CPTXYGraph *graph;
}

-(void)setupPieChart;
-(void)dataForPlot;
@end
