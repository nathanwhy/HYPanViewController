HYPanViewController
===================
The ViewController that recreates the vvebo app UI.
The Awesome way to delete tableView cell or present new viewController.

![image](https://github.com/nathanwhy/HYPanViewController/raw/master/example.gif)



###Usage

You can use `handler` to present new view controller:

```objc
typeof(self) __weak weakSelf = self;
HYPanGestureRecognizer *pan = [[HYPanGestureRecognizer alloc] initWithTabelView:_tableView Handler:^(HYPanGestureRecognizer *panGesture, NSIndexPath *indexpath, BOOL isLeft) {
        
        if (isLeft) {
            DetailViewController *detail = [[DetailViewController alloc] init];
            [weakSelf addChildViewController:detail];
            [weakSelf.view addSubview:detail.view];
            [detail didMoveToParentViewController:weakSelf];
        }
    }];
[pan addLeftText:@"comment" rightText:@"retweet"];
[self.view addGestureRecognizer:pan];
```

It also can be used to delete Cell:

```objc
typeof(self) __weak weakSelf = self;
HYPanGestureRecognizer *pan = [[HYPanGestureRecognizer alloc] initWithTabelView:_tableView Handler:^(HYPanGestureRecognizer *panGesture, NSIndexPath *indexpath, BOOL isLeft) {
        
        if (!isLeft) {
            [weakSelf.dataList removeObjectAtIndex:indexpath.row];
            [panGesture.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
[pan addLeftText:@"comment" rightText:@"delete"];
[self.view addGestureRecognizer:pan];
```


This project is inspired by [Udo](https://github.com/moayes/UDo/tree/master) .
