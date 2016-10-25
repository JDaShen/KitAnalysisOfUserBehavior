//
//  SecondViewController.m
//  KitUserStatisics
//
//  Created by lijinhai on 9/5/16.
//  Copyright © 2016 gzkit. All rights reserved.
//

#import "SecondViewController.h"
#import "KitUserStatisicsUtil.h"

@implementation SecondViewController
- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"qqq" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void) buttonAction: (id)sender {
    [[KitUserStatisicsUtil sharedInstance] zipUserStatiscsFile];
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
@end
