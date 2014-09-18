//
//  PieChartViewController.m
//  DemoPieChart
//
//  Created by Ivan on 14-9-18.
//  Copyright (c) 2014年 ivan. All rights reserved.
//

#import "PieChartViewController.h"

@interface PieChartViewController ()
{
    NSMutableArray *dataForPie;
}

@end

@implementation PieChartViewController

//产生10-50的随机数
-(void)dataForPlot{
    dataForPie=[NSMutableArray arrayWithCapacity:5];
    for (NSInteger i=0; i<5; i++) {
        float num=(float)10+random()%50;
        [dataForPie addObject:[NSNumber numberWithFloat:num]];
        //        NSLog(@"dataForPie:%@",dataForPie);
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    [self dataForPlot];
    [self setupPieChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupPieChart
{
    
//创建画布，设置主题
    graph=[[CPTXYGraph alloc]initWithFrame:self.view.frame];
    
    CPTTheme *theme=[CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    
// 创建画板
    CPTGraphHostingView *hostingView=(CPTGraphHostingView *)self.view;
    hostingView.hostedGraph=graph;
    hostingView.collapsesLayers=NO;
    
    graph.paddingLeft= 20.0;
    graph.paddingRight= 20.0;
    graph.paddingTop= 20.0;
    graph.paddingBottom= 20.0;
    
//自定义画布的标题风格
    CPTMutableTextStyle *textStyle=[CPTMutableTextStyle textStyle];
    textStyle.fontName=@"Helvetica-Bold";
    textStyle.fontSize=18;
    graph.titleTextStyle=textStyle;
    graph.title=@"数据表";
    graph.titleDisplacement=CGPointMake(0, -10);
    
    
    graph.axisSet=nil;
    
//创建饼图对象
    CPTPieChart *piePlot=[[CPTPieChart alloc]init];
    
    piePlot.dataSource=self;                                     // 设置数据源
    piePlot.delegate=self;                                       // 设置委托
    piePlot.identifier=@"pieChart1";                             // 饼图标识
    piePlot.pieRadius=90;                                      // 半径
    piePlot.centerAnchor =CGPointMake(0.5,0.4);                  // 重心
    piePlot.startAngle=M_PI_4;                                   // 开始绘制的位置
    piePlot.sliceDirection=CPTPieDirectionCounterClockwise;      // 绘制方向（顺时针/逆时针）
    piePlot.borderLineStyle=[CPTLineStyle lineStyle];            // 外框线条
//    piePlot.pieInnerRadius=100;                                // 内半径
    
    [graph addPlot:piePlot];                                    // 把饼图对象加入到画布
    
//创建图例
    CPTLegend *lengend=[CPTLegend legendWithGraph:graph];
    lengend.numberOfColumns=2;                                          // 列数
    lengend.numberOfRows=3;                                             // 行数
    lengend.borderLineStyle=[CPTLineStyle lineStyle];                   // 外框的线条样式
    lengend.cornerRadius=5.0;                                           // 外框的圆角半径
    lengend.delegate=self;
    
    lengend.fill=[CPTFill fillWithColor:[CPTColor whiteColor]];         // 图例的填充属性，（CPTFill类型）
    
    graph.legend=lengend;
    graph.legendAnchor=CPTRectAnchorRight;                              // 图例对齐于图框的位置
    graph.legendDisplacement=CGPointMake(-60, 60);                      // 图例对齐时的偏移距离
}



#pragma Mark - **************************CPTPlot Delegate**************************

// 返回扇形数目
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{

    return [dataForPie count];
    NSLog(@"count: %i",[dataForPie count]);
}


//返回每个扇形的比例
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    if (CPTPieChartFieldSliceWidth==fieldEnum) {
        return [dataForPie objectAtIndex:idx];
//        NSLog(@"idx: %@",[dataForPie objectAtIndex:idx]);
    }
    return [NSDecimalNumber zero];
}

//返回每个扇形的标题
- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    CPTTextLayer *label = [[CPTTextLayer alloc]initWithText:[NSString stringWithFormat:@"%@%%",[dataForPie objectAtIndex:idx]]];
    CPTMutableTextStyle *text = [ label.textStyle mutableCopy];
    text.color = [CPTColor whiteColor];
    return label;
}


#pragma Mark - **************************CPTPieChart Delegate**************************

//返回图例
- (NSAttributedString *)attributedLegendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    NSAttributedString *title = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%%" ,[dataForPie objectAtIndex:idx]]];
    
    return title;
}

//把某块扇形“切除”下来，以此突出该扇形区域。
-(CGFloat)radialOffsetForPieChart:(CPTPieChart*)piePlot recordIndex:(NSUInteger)index{
    
    return (index==1?10:0); //将饼图中第2块扇形“剥离”10个像素点：
}


//选中某个扇形时的操作
- (void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)idx
{
    graph.title = [NSString stringWithFormat:@"比例:%@",[dataForPie objectAtIndex:idx]];
    
}


@end
