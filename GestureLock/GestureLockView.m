//
//  GestureLockView.m
//  GestureLock
//
//  Created by GM on 2017/6/12.
//  Copyright © 2017年 swift.GM. All rights reserved.
//

#import "GestureLockView.h"

@interface GestureLockView ()

@property (nonatomic, copy) NSString * targetStr;
@property (nonatomic, copy) GestureComplete complete;
@property (nonatomic, strong) NSMutableArray * selectButtons;
@property (nonatomic, strong) NSArray * numberArray;
@property (nonatomic, strong) NSMutableArray * selectNumbers;
@property (nonatomic, assign) CGPoint endPoint;

@end

@implementation GestureLockView

- (instancetype)initWithFrame:(CGRect)frame targetStr:(NSString *)targetStr complete:(GestureComplete)complete {
    if (self = [super initWithFrame:frame]) {
        self.targetStr = targetStr;
        self.complete = complete;
        [self configSubviews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self configSubviews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

    UIBezierPath * path = [UIBezierPath bezierPath];
    [path setLineWidth:5];
    for(NSInteger i = 0; i < self.selectButtons.count; i ++) {
        UIButton * button = [self.selectButtons objectAtIndex:i];
        if (i == 0) {
            [path moveToPoint:button.center];
        } else {
            [path addLineToPoint:button.center];
        }
    }
    if (self.selectButtons.count > 0 && !CGPointEqualToPoint(self.endPoint, CGPointZero)) {
        [path addLineToPoint:self.endPoint];
    }
    [UIColor.redColor set];
    [path stroke];
}

- (void)configSubviews {

    CGFloat marginW = 20;
    CGFloat marginH = marginW;
    NSInteger column = 3;

    CGFloat btnH = (self.frame.size.height - ((column + 1) * marginH)) / column;
    CGFloat btnW = btnH;

    for(NSInteger i = 0; i < 9; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(marginW + ((btnW + marginW)* (i%column)), marginH + ((btnH + marginH) * (i/column)), btnW, btnH);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button setTitle:[NSString stringWithFormat:@"%ld 未选中",i] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%ld 选中",i] forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor grayColor]];
        button.layer.masksToBounds = true;
        button.layer.cornerRadius = btnH / 2;
        button.userInteractionEnabled = false;
        [self addSubview:button];
    }
}

#pragma mark - Override

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = touches.anyObject;
    [self checkPoint:[touch locationInView:self]];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    [self checkPoint:point];
    self.endPoint = point;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self checkResultStr];
    [self clearContext];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self checkResultStr];
    [self clearContext];
}

- (void)checkPoint:(CGPoint)point {
    for (NSInteger i = 0; i < 9; i++) {
        UIView * subview = [self.subviews objectAtIndex:i];
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)subview;
            if (CGRectContainsPoint(btn.frame, point) && !btn.selected) {
                btn.selected = true;
                [self.selectButtons addObject:btn];
                [self.selectNumbers addObject:[self.numberArray objectAtIndex:i]];
            }
        }
    }
}

- (void)checkResultStr {
    NSMutableString * resultStr = [NSMutableString string];
    for (NSNumber * num in self.selectNumbers) {
        [resultStr appendString:[NSString stringWithFormat:@"%@",num]];
    }
    NSLog(@"resultStr : %@",resultStr);
    BOOL success = [resultStr isEqualToString:self.targetStr];
    self.complete(success);
}

- (void)clearContext {
    self.endPoint = CGPointZero;
    for (UIButton * btn in self.selectButtons) {
        btn.selected = false;
    }
    [self.selectButtons removeAllObjects];
    [self.selectNumbers removeAllObjects];
    [self setNeedsDisplay];
}


#pragma mark - Lazy load
- (NSMutableArray *)selectButtons {
    if (!_selectButtons) {
        _selectButtons = [NSMutableArray array];
    }
    return _selectButtons;
}

- (NSArray *)numberArray {
    if (!_numberArray) {
        _numberArray = @[@(0),@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9)];
    }
    return _numberArray;
}

- (NSMutableArray *)selectNumbers {
    if (!_selectNumbers) {
        _selectNumbers = [NSMutableArray array];
    }
    return _selectNumbers;
}

@end
