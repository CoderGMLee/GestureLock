//
//  ViewController.m
//  GestureLock
//
//  Created by GM on 2017/6/12.
//  Copyright © 2017年 swift.GM. All rights reserved.
//

#import "ViewController.h"
#import "GestureLockView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GestureLockView * lockView = [[GestureLockView alloc] initWithFrame:CGRectMake(30, 100, 300, 300) targetStr:@"123456" complete:^(BOOL success) {
        if (success) {
            NSLog(@"验证成功");
        } else {
            NSLog(@"验证失败");
        }
    }];
    [self.view addSubview:lockView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
