//
//  HYPanGestureRecognizer.h
//  HYPanTableView
//
//  Created by why on 15/2/28.
//  Copyright (c) 2015年 nathanwu. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^HYPanBlock)(BOOL isFinished, BOOL isLeft);


@interface HYPanGestureRecognizer : UIPanGestureRecognizer
- (instancetype)initWithTabelView:(UITableView *)tableView Handler:(HYPanBlock) block;

@property (nonatomic, copy) HYPanBlock panBlock;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) CATextLayer *leftLayer;
@property (nonatomic, strong) CATextLayer *rightLayer;



@end
