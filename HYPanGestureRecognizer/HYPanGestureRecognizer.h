//
//  HYPanGestureRecognizer.h
//  HYPanTableView
//
//  Created by why on 15/2/28.
//  Copyright (c) 2015年 nathanwu. All rights reserved.
//


#import <UIKit/UIKit.h>

@class HYPanGestureRecognizer;

typedef void(^HYHandler)(HYPanGestureRecognizer *panGesture, NSIndexPath *indexpath, BOOL isLeft);

@interface HYPanGestureRecognizer : UIPanGestureRecognizer
- (instancetype)initWithTabelView:(UITableView *)tableView Handler:(HYHandler) handler;

@property (nonatomic, copy) HYHandler panHandler;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) CATextLayer *leftLayer;
@property (nonatomic, strong) CATextLayer *rightLayer;

- (void)addLeftText:(NSString *)leftText rightText:(NSString *)rightText;

@end
