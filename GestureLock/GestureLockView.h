//
//  GestureLockView.h
//  GestureLock
//
//  Created by GM on 2017/6/12.
//  Copyright © 2017年 swift.GM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureComplete)(BOOL success);

@interface GestureLockView : UIView

- (instancetype)initWithFrame:(CGRect)frame targetStr:(NSString *)targetStr complete:(GestureComplete)complete;

@end
