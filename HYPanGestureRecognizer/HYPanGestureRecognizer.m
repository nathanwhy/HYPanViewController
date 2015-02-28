//
//  HYPanGestureRecognizer.m
//  HYPanTableView
//
//  Created by why on 15/2/28.
//  Copyright (c) 2015年 nathanwu. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "HYPanGestureRecognizer.h"
#import "HYSnapshotView.h"

@implementation HYPanGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action{
    self = [super initWithTarget:target action:action];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithTabelView:(UITableView *)tableView Handler:(HYPanBlock) block
{
    self = [self initWithTarget:self action:@selector(hy_handleAction:)];
    if (!self) return nil;
    
    self.tableView = tableView;
    self.panBlock  = block;
    self.delaysTouchesBegan = YES;
    
    return self;
}

- (CATextLayer*)createLayer:(BOOL)isLeft{
    CATextLayer *layer = [CATextLayer layer];
    layer.bounds = CGRectMake(0, 0, 30,20);
    layer.font = (__bridge CFTypeRef)(@"Helvetica-Bold");
    layer.fontSize = 15.0;
    layer.foregroundColor = [UIColor redColor].CGColor;
    layer.string = isLeft? @"评论": @"转发";
    return layer;
}

- (CATextLayer *)leftLayer{
    if (_leftLayer == nil) {
        _leftLayer = [self createLayer:YES];
    }
    return _leftLayer;
}

- (CATextLayer *)rightLayer{
    if (_rightLayer == nil) {
        _rightLayer = [self createLayer:NO];
    }
    return _rightLayer;
}


- (void)hy_handleAction:(UIPanGestureRecognizer *)gesture
{
    CGPoint movePoint = [self translationInView:self.tableView];
    CGPoint location  = [self locationInView:self.tableView];
    
    static NSIndexPath  *sourceIndexPath = nil;
    static UIView       *snapshot        = nil;
    static BOOL isFirstTouch;
    
    switch (self.state) {
        case UIGestureRecognizerStateBegan:{
            NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
            if (indexPath == nil) return;
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            snapshot = [HYSnapshotView customSnapshoFromView:cell];
            
            CGFloat cellH = cell.frame.size.height;
            
            self.leftLayer.anchorPoint = CGPointMake(1, 0.5);
            self.leftLayer.position = CGPointMake(-10, cellH/2);
            [snapshot.layer addSublayer:self.leftLayer];
            
            
            self.rightLayer.anchorPoint = CGPointMake(0, 0.5);
            self.rightLayer.position = CGPointMake(kScreenWidth+10, cellH/2);
            [snapshot.layer addSublayer:self.rightLayer];
            
            isFirstTouch = YES;
            sourceIndexPath = indexPath;
            snapshot.center = cell.center;
            snapshot.alpha  = 0.0;
//            snapshot.layer.shadowRadius = shadowWith;
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
            
//            snapshot.layer.shadowOffset = CGSizeMake(movePoint.x<0?-shadowWith:shadowWith, shadowWith);
            
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
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                    if (self.panBlock) {
                        self.panBlock(YES,movePoint.x<0);
                    }
                    
                }];
                
            }else{
                
                [UIView animateWithDuration:0.5 animations:^{
                    [snapshot setTransform:CGAffineTransformIdentity];
                    [snapshot setAlpha:1];
                } completion:^(BOOL finished) {
                    cell.alpha  = 1.0;
                    cell.hidden = NO;
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                }];
            }
        }
            break;
    }
}

@end
