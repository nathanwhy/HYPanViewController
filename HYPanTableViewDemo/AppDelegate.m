//
//  AppDelegate.m
//  HYPanTableView
//
//  Created by nathan on 14-12-11.
//  Copyright (c) 2014年 nathanwu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor blackColor]];
    
    ViewController *main = [[ViewController alloc] init];
    [self.window setRootViewController:main];
    
    [self.window makeKeyAndVisible];
    return YES;
}
@end
