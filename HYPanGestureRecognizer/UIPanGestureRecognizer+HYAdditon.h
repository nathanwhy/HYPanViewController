//
//  UIPanGestureRecognizer+HYAdditon.h
//  HYPanTableView
//
//  Created by nathan on 14/12/13.
//  Copyright (c) 2014年 nathanwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYPanGestureRecognizerDelegate <NSObject>

@required
- (CALayer *)panGestureRecognizerWithLeftLayer;
- (CALayer *)panGestureRecognizerWithRightLayer;
@end

@interface UIPanGestureRecognizer (HYAdditon)

-(void)hy_PanGestureWithTableView:(UITableView *)tableView
                      shadowWidth:(CGFloat)shadowWith
                        leftLayer:(CALayer *)leftlayer
                       rightLayer:(CALayer *)rightLayer
                       completion:(void (^)(BOOL finished,BOOL isLeft))completion;

@end
