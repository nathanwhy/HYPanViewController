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
        snapShot = [inputView snapshotViewAfterScreenUpdates:YES];// ios7 Later
    }
    snapShot.layer.masksToBounds = NO;
    snapShot.layer.cornerRadius = 0.0;
    snapShot.layer.shadowOpacity = 0.4;
    
    return snapShot;
}

@end
