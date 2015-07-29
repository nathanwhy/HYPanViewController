// The MIT License (MIT)
//
// Copyright (c) 2015-1016 nathanwhy ( https://github.com/nathanwhy )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kPanFontSize 15.0f


#import "HYPanGestureRecognizer.h"
#import "HYSnapshotView.h"

@implementation HYPanGestureRecognizer

- (instancetype)initWithTabelView:(UITableView *)tableView Handler:(HYHandler) handler
{
    self = [self initWithTarget:self action:@selector(hy_handleAction:)];
    if (!self) return nil;
    
    self.tableView = tableView;
    self.panHandler  = handler;
    self.delaysTouchesBegan = YES;
    
    return self;
}

- (CATextLayer*)createLayerWithText:(NSString *)text{
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:kPanFontSize] constrainedToSize:CGSizeMake(100, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    CATextLayer *layer = [CATextLayer layer];
    layer.bounds = CGRectMake(0, 0, size.width, size.height);
    layer.font = (__bridge CFTypeRef)[UIFont systemFontOfSize:kPanFontSize].fontName;
    layer.fontSize = kPanFontSize;
    layer.foregroundColor = [UIColor redColor].CGColor;
    layer.string = text;
    return layer;
}

- (CATextLayer *)leftLayer{
    if (_leftLayer == nil) {
        _leftLayer = [self createLayerWithText:@"leftText"];
    }
    return _leftLayer;
}

- (CATextLayer *)rightLayer{
    if (_rightLayer == nil) {
        _rightLayer = [self createLayerWithText:@"rightText"];
    }
    return _rightLayer;
}

- (void)addLeftText:(NSString *)leftText rightText:(NSString *)rightText {
    _leftLayer = [self createLayerWithText:leftText];
    _rightLayer = [self createLayerWithText:rightText];
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
            self.leftLayer.position = CGPointMake(-10, cellH / 2);
            [snapshot.layer addSublayer:self.leftLayer];
            
            
            self.rightLayer.anchorPoint = CGPointMake(0, 0.5);
            self.rightLayer.position = CGPointMake(kScreenWidth + 10, cellH / 2);
            [snapshot.layer addSublayer:self.rightLayer];
            
            isFirstTouch = YES;
            sourceIndexPath = indexPath;
            snapshot.center = cell.center;
            snapshot.alpha  = 0.0;
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
            
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformRotate(transform,(M_PI/180.0*(movePoint.x/kScreenWidth)*20));
            transform = CGAffineTransformTranslate(transform, movePoint.x, 0);
            snapshot.transform = transform;
            
        }
            break;
        default: { // end
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            
            if (fabs(movePoint.x) > kScreenWidth*0.3) {
                typeof(self) __weak weakSelf = self;
                [UIView animateWithDuration:0.4 animations:^{
                    
                    CGFloat offsetX = movePoint.x > 0? kScreenWidth: -kScreenWidth;
                    CGAffineTransform transform = CGAffineTransformIdentity;
                    offsetX *= 1.2f;
                    transform = CGAffineTransformRotate(transform,(M_PI / 180.0 * (offsetX / kScreenWidth) * 20));
                    transform = CGAffineTransformTranslate(transform, offsetX, 0);
                    [snapshot setTransform:transform];
                    [snapshot setAlpha:1];
                } completion:^(BOOL finished) {
                    cell.alpha  = 1.0;
                    cell.hidden = NO;
                    [snapshot removeFromSuperview];
                    
                    if (weakSelf.panHandler) {
                        weakSelf.panHandler(weakSelf, sourceIndexPath, movePoint.x < 0);
                    }
                    
                    snapshot = nil;
                    isFirstTouch = NO;
                    sourceIndexPath = nil;
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
                    isFirstTouch = NO;
                    sourceIndexPath = nil;
                }];
            }
        }
            break;
    }
}


@end
