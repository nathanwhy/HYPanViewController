//
//  ViewController.m
//  HYPanTableView
//
//  Created by nathan on 14-12-11.
//  Copyright (c) 2014年 nathanwu. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "HYPanGestureRecognizer.h"

#define DF_Color_RGB(a,b,c) [UIColor colorWithRed:a/255.0f green:b/255.0f blue:c/255.0f alpha:1]
@interface ViewController ()

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataList = @[@"Beauty! Where is thy faith?",
                      @"Keep up your bright swords, for the dew will rust them. ",
                      @"O, she dothe teach the torches to burn bright! ",
                      @"Nothing will come of nothing. ",
                      @"This above all: to thine self be true.",
                      @"A little more than kin, and less than kind. ",
                      @"no zuo no die"];
    
    _tableView = ({
        UITableView *tableview  = [[UITableView alloc] initWithFrame:self.view.frame];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableview];
        tableview;
    });
    
    __weak ViewController *weakSelf = self;
    HYPanGestureRecognizer *pan = [[HYPanGestureRecognizer alloc] initWithTabelView:_tableView Handler:^(BOOL isFinished, BOOL isLeft) {
        
        DetailViewController *detail = [[DetailViewController alloc] init];
        [weakSelf addChildViewController:detail];
        [weakSelf.view addSubview:detail.view];
        [detail didMoveToParentViewController:weakSelf];
    }];
    [self.view addGestureRecognizer:pan];
}

#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
    }
    cell.textLabel.text = self.dataList[indexPath.row%7];
    cell.backgroundColor = (indexPath.row%2)? DF_Color_RGB(156, 96, 34):DF_Color_RGB(196, 156, 107);
    
    return cell;
}




@end
