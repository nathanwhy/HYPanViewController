//
//  HYSnapshotView.m
//  HYPanTableView
//
//  Created by why on 15/2/28.
//  Copyright (c) 2015年 nathanwu. All rights reserved.
//

#import "HYSnapshotView.h"

@implementation HYSnapshotView

+ (UIView *)customSnapshoFromView:(UIView *)inputView
{
    UIView *snapShot = [[UIView alloc] initWithFrame:inputView.frame];
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, YES, 1);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *shot = [[UIImageView alloc]initWithImage:viewImage];
    [snapShot addSubview:shot];
    snapShot.layer.masksToBounds = NO;
    snapShot.layer.cornerRadius = 0.0;
    snapShot.layer.shadowOpacity = 0.4;
    
    return snapShot;
}

@end
