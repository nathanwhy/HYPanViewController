//
//  UIPanGestureRecognizer+HYAdditon.m
//  HYPanTableView
//
//  Created by nathan on 14/12/13.
//  Copyright (c) 2014年 nathanwu. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "UIPanGestureRecognizer+HYAdditon.h"

@implementation UIPanGestureRecognizer (HYAdditon)

-(void)hy_PanGestureWithTableView:(UITableView *)tableView
                      shadowWidth:(CGFloat)shadowWith
                        leftLayer:(CALayer *)leftlayer
                       rightLayer:(CALayer *)rightLayer
                       completion:(void (^)(BOOL finished,BOOL isLeft))completion{
    
    CGPoint movePoint = [self translationInView:tableView];
    CGPoint location  = [self locationInView:tableView];
    
    static NSIndexPath  *sourceIndexPath = nil;
    static UIView       *snapshot        = nil;
    static BOOL isFirstTouch;
    
    switch (self.state) {
        case UIGestureRecognizerStateBegan:{
            NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:location];
            if (indexPath == nil) return;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            snapshot = [self customSnapshoFromView:cell];
            
            CGFloat cellH = cell.frame.size.height;
            leftlayer.anchorPoint = CGPointMake(1, 0.5);
            leftlayer.position = CGPointMake(-10, cellH/2);
            [snapshot.layer addSublayer:leftlayer];
            
            rightLayer.anchorPoint = CGPointMake(0, 0.5);
            rightLayer.position = CGPointMake(kScreenWidth+10, cellH/2);
            [snapshot.layer addSublayer:rightLayer];
            
            isFirstTouch = YES;
            sourceIndexPath = indexPath;
            snapshot.center = cell.center;
            snapshot.alpha  = 0.0;
            snapshot.layer.shadowRadius = shadowWith;
            [tableView addSubview:snapshot];
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.alpha = 0.98;
                cell.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                cell.hidden = YES;
            }];
            
        }
            break;
        case UIGestureRecognizerStateChanged:{
            
            snapshot.layer.shadowOffset = CGSizeMake(movePoint.x<0?-shadowWith:shadowWith, shadowWith);
            
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformRotate(transform,(M_PI/180.0*(movePoint.x/kScreenWidth)*20));
            transform = CGAffineTransformTranslate(transform, movePoint.x, 0);
            snapshot.transform = transform;
            
        }
            break;
        default: { // end
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:sourceIndexPath];
            
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
                    if (completion) {
                        completion(YES,movePoint.x<0);
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
    snapShot.layer.shadowOpacity = 0.4;
    
    return snapShot;
}



@end
