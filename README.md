HYPanViewController
===================
The ViewController that recreates the vvebo app UI.

![image](https://github.com/nathanwhy/HYPanViewController/raw/master/example.gif)

Some ideas come from [Udo](https://github.com/moayes/UDo/tree/master) .

###use

```
 __weak ViewController *weakSelf = self;
    HYPanGestureRecognizer *pan = [[HYPanGestureRecognizer alloc] initWithTabelView:_tableView Handler:^(BOOL isFinished, BOOL isLeft) {
        
        DetailViewController *detail = [[DetailViewController alloc] init];
        [weakSelf addChildViewController:detail];
        [weakSelf.view addSubview:detail.view];
        [detail didMoveToParentViewController:weakSelf];
    }];
    [pan addLeftText:@"comment" rightText:@"retweet"];
    [self.view addGestureRecognizer:pan];
```