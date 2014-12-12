//
//  ViewController.m
//  HYPanTableView
//
//  Created by nathan on 14-12-11.
//  Copyright (c) 2014年 nathanwu. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
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
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                   action:@selector(panGesture:)];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataList[indexPath.row%7];
    cell.textLabel.numberOfLines = 0;
    cell.backgroundView = nil;
    cell.backgroundColor = (indexPath.row%2)? DF_Color_RGB(156, 96, 34):DF_Color_RGB(196, 156, 107);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CATextLayer *)createTextLayerWithRight:(BOOL)isRight superView:(UIView *)superview
{
    CATextLayer *textlayer = [CATextLayer layer];
    
    textlayer = [CATextLayer layer];
    textlayer.bounds = CGRectMake(0, 0, 30,20);
    textlayer.font = (__bridge CFTypeRef)(@"Helvetica-Bold");
    textlayer.fontSize = 15.0;
    textlayer.foregroundColor = [UIColor redColor].CGColor;
    textlayer.string = isRight?@"评论":@"转发";
    
    CGFloat y = (superview.frame.size.height)/2;
    textlayer.position = CGPointMake(isRight?kScreenWidth+30:-30, y);
    return textlayer;
}


- (void)panGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint movePoint = [gesture translationInView:self.tableView];
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    static NSIndexPath  *sourceIndexPath = nil;
    static UIView       *snapshot = nil;
    static CATextLayer  *leftTextLayer = nil;
    static CATextLayer  *rightTextLayer = nil;
    static BOOL isFirstTouch;
    
    if (indexPath == nil) {
        return;
    }
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            snapshot = [self customSnapshoFromView:cell];
            
            isFirstTouch = YES;
            sourceIndexPath = indexPath;
            CGPoint center = cell.center;
            snapshot.center = center;
            snapshot.alpha = 0.0;
            [self.tableView addSubview:snapshot];
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.alpha = 0.98;
                cell.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                cell.hidden = YES;
            }];
            
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if (isFirstTouch) {
                leftTextLayer = [self createTextLayerWithRight:NO superView:snapshot];
                [snapshot.layer addSublayer:leftTextLayer];
                
                rightTextLayer = [self createTextLayerWithRight:YES superView:snapshot];
                [snapshot.layer addSublayer:rightTextLayer];
                
                snapshot.layer.shadowOffset = CGSizeMake(movePoint.x<0?-5.0:5.0, 5.0);
                isFirstTouch = NO;
            }
            
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformRotate(transform,(M_PI/180.0*(movePoint.x/kScreenWidth)*20));
            transform = CGAffineTransformTranslate(transform, movePoint.x, 0);
            snapshot.transform = transform;
            
        }
            break;
        default: { // end
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            
            if (fabsf(movePoint.x) > kScreenWidth*0.3) {
                [UIView animateWithDuration:0.4 animations:^{
                    
                    CGFloat offsetX = movePoint.x>0?kScreenWidth:-kScreenWidth;
                    CGAffineTransform transform = CGAffineTransformIdentity;
                    offsetX *= 1.2f;
                    transform = CGAffineTransformRotate(transform,(M_PI/180.0*(offsetX/kScreenWidth)*20));
                    transform = CGAffineTransformTranslate(transform, offsetX, 0);
                    [snapshot setTransform:transform];
                    [snapshot setAlpha:1];
                } completion:^(BOOL finished) {
                    cell.alpha  = 1.0;
                    cell.hidden = NO;
                    leftTextLayer  = nil;
                    rightTextLayer = nil;
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                    [self pushToDetailViewController];
                }];
                
            }else{
                
                [UIView animateWithDuration:0.5 animations:^{
                    [snapshot setTransform:CGAffineTransformIdentity];
                    [snapshot setAlpha:1];
                } completion:^(BOOL finished) {
                    cell.alpha  = 1.0;
                    cell.hidden = NO;
                    leftTextLayer  = nil;
                    rightTextLayer = nil;
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                }];
            }
        }
            break;
    }
}

- (void)pushToDetailViewController{
    DetailViewController *toVC = [[DetailViewController alloc] init];
    [toVC showDetailController];
}


- (UIView *)customSnapshoFromView:(UIView *)inputView
{
    UIView *snapShot;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<7.0f) {//ios6
        snapShot = [[UIView alloc] initWithFrame:inputView.frame];
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, YES, 1);
        [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView *shot = [[UIImageView alloc]initWithImage:viewImage];
        [snapShot addSubview:shot];
        
    }else {
        snapShot = [inputView snapshotViewAfterScreenUpdates:YES];// ios7
    }
    snapShot.layer.masksToBounds = NO;
    snapShot.layer.cornerRadius = 0.0;
    snapShot.layer.shadowOffset = CGSizeMake(-5.0, 5.0);
    snapShot.layer.shadowRadius = 5.0;
    snapShot.layer.shadowOpacity = 0.4;
    
    return snapShot;
}

@end
