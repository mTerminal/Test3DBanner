//
//  ViewController.m
//  Test3DBanner
//
//  Created by 侯猛 on 16/8/26.
//  Copyright © 2016年 侯猛. All rights reserved.
//

#import "ViewController.h"
#import "HMCycleScrollView.h"

@interface ViewController ()<HMCycleScrollViewDelegate,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.view.bounds.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    
    HMCycleScrollView *cycleScrollView = [HMCycleScrollView createScrollViewWithFrame:CGRectMake(0 , 64 , [UIScreen mainScreen].bounds.size.width, 200) delegate:self];
    
    cycleScrollView.imagesURLStrings = @[@"http://photo.enterdesk.com/2011-6-21/enterdesk.com-1FAA1F678A8858936AD7705ABC27A3C9.jpg",@"http://d.hiphotos.baidu.com/zhidao/pic/item/6a63f6246b600c338c1cd6a01b4c510fd9f9a174.jpg",@"http://dl.bizhi.sogou.com/images/2012/09/30/44928.jpg"];
    
    [view addSubview:cycleScrollView];
    
    return view;
}


- (void)cycleScrollView:(HMCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
