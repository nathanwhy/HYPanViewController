//
//  ViewController.m
//  HYPanTableView
//
//  Created by nathan on 14-12-11.
//  Copyright (c) 2014年 nathanwu. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "UIPanGestureRecognizer+HYAdditon.h"


#define DF_Color_RGB(a,b,c) [UIColor colorWithRed:a/255.0f green:b/255.0f blue:c/255.0f alpha:1]
@interface ViewController ()

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataList;
@property (nonatomic, weak)CATextLayer *leftLayer;
@property (nonatomic, weak)CATextLayer *rightLayer;


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
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    panRecognizer.delaysTouchesBegan = YES;
    [self.view addGestureRecognizer:panRecognizer];
    
    
    _tableView = ({
        UITableView *tableview  = [[UITableView alloc] initWithFrame:self.view.frame];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableview];
        tableview;
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
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
    cell.backgroundView = nil;
    cell.backgroundColor = (indexPath.row%2)? DF_Color_RGB(156, 96, 34):DF_Color_RGB(196, 156, 107);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CATextLayer *)createTextLayerWithRight:(BOOL)isRight
{
    CATextLayer *textlayer = [CATextLayer layer];
    
    textlayer = [CATextLayer layer];
    textlayer.bounds = CGRectMake(0, 0, 30,20);
    textlayer.font = (__bridge CFTypeRef)(@"Helvetica-Bold");
    textlayer.fontSize = 15.0;
    textlayer.foregroundColor = [UIColor redColor].CGColor;
    textlayer.string = isRight?@"评论":@"转发";
    return textlayer;
}

- (CATextLayer *)leftLayer{
    if (_leftLayer == nil) {
        _leftLayer = [self createTextLayerWithRight:NO];
    }
    return _leftLayer;
}

- (CATextLayer *)rightLayer{
    if (_rightLayer == nil) {
        _rightLayer = [self createTextLayerWithRight:YES];
    }
    return _rightLayer;
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture
{
    [gesture hy_PanGestureWithTableView:self.tableView
                            shadowWidth:0.5
                              leftLayer:self.leftLayer
                             rightLayer:self.rightLayer
                             completion:^(BOOL finished, BOOL isLeft) {
        
        DetailViewController *toVC = [[DetailViewController alloc] init];
        [toVC showDetailController];
    }];
}


@end
