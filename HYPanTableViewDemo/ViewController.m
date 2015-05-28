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
@property (nonatomic, strong)NSMutableArray *dataList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataList = [NSMutableArray arrayWithArray:@[@"Beauty! Where is thy faith?",
                      @"Keep up your bright swords, for the dew will rust them. ",
                      @"O, she dothe teach the torches to burn bright! ",
                      @"Nothing will come of nothing. ",
                      @"This above all: to thine self be true.",
                      @"A little more than kin, and less than kind. ",
                      @"no zuo no die",
                      @"Beauty! Where is thy faith?",
                      @"Keep up your bright swords, for the dew will rust them. ",
                      @"O, she dothe teach the torches to burn bright! ",
                      @"Nothing will come of nothing. ",
                      @"This above all: to thine self be true.",
                      @"A little more than kin, and less than kind. "]];
    
    _tableView = ({
        UITableView *tableview  = [[UITableView alloc] initWithFrame:self.view.frame];
        tableview.delegate = self;
        tableview.dataSource = self;
        [self.view addSubview:tableview];
        tableview;
    });
    
    typeof(self) __weak weakSelf = self;
    HYPanGestureRecognizer *pan = [[HYPanGestureRecognizer alloc] initWithTabelView:_tableView Handler:^(HYPanGestureRecognizer *panGesture, NSIndexPath *indexpath, BOOL isLeft) {
        
        if (isLeft) {
            [weakSelf.dataList removeObjectAtIndex:indexpath.row];
            [panGesture.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            DetailViewController *detail = [[DetailViewController alloc] init];
            [weakSelf addChildViewController:detail];
            [weakSelf.view addSubview:detail.view];
            [detail didMoveToParentViewController:weakSelf];
        }
    }];
    [pan addLeftText:@"comment" rightText:@"retweet"];
    [self.view addGestureRecognizer:pan];
}

#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
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
    cell.textLabel.text = self.dataList[indexPath.row];
    cell.backgroundColor = DF_Color_RGB(245, 240, 235);
    
    return cell;
}




@end
