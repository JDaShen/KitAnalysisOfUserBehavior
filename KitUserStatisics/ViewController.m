//
//  ViewController.m
//  KitUserStatisics
//
//  Created by lijinhai on 8/31/16.
//  Copyright © 2016 gzkit. All rights reserved.
//

#import "ViewController.h"
#import <Security/Security.h>
#import "KitDeviceInfo.h"
#import "KitUserStatisicsUtil.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%@", [KitDeviceInfo sharedInstance].deviceName);
//    2.）设备类型
    NSLog(@"%@", [KitDeviceInfo sharedInstance].deviceModel);
//    3.）LocalizedModel
    NSLog(@"%@", [UIDevice currentDevice].localizedModel);
//    4.）设备系统名称
    NSLog(@"%@", [KitDeviceInfo sharedInstance].systemName);
//    5.）设备系统版本
    NSLog(@"%@", [KitDeviceInfo sharedInstance].systemVersion);
    
//    6.）设备UUID
    // 2E0AC650-4B36-4072-842A-4DCDAD9AD610
    // 0ABACD42-F7CC-489E-8CBA-24F526F12D8A
    // 54BE87A2-B4F5-44DB-AC15-E426D94E5046
    // CD392B37-7B30-471B-8D40-5D4E7D243369
    NSLog(@"%@", [KitDeviceInfo sharedInstance].uuid);
//    7.）bundle ID
    NSLog(@"%@", [NSBundle mainBundle].bundleIdentifier);
    NSLog(@"%@", [KitUserStatisicsUtil sharedInstance].currentTimeInterval);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    button.backgroundColor = [UIColor greenColor];
//    [button setTitle:@"abc" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UISwitch *switch1 = [[UISwitch alloc] initWithFrame:CGRectMake(0, 220, 100, 100)];
    [switch1 addTarget:self action:@selector(swiAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switch1];
    
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 320, 100, 100)];
    [sc insertSegmentWithTitle:@"haha" atIndex:0 animated:YES];
    [sc insertSegmentWithTitle:@"wowo" atIndex:1 animated:YES];
    [sc addTarget:self action:@selector(scAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sc];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(120, 100, 100, 100)];
    tf.backgroundColor = [UIColor grayColor];
    tf.delegate = self;
//    [self.view addSubview:tf];
    
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectMake(120, 220, 100, 100)];
    [stepper addTarget:self action:@selector(swiAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:stepper];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(120, 320, 100, 100)];
    [slider addTarget:self action:@selector(swiAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
//    UILabel NO
//    UIButton
//    UISegmentedControl
//    UITextField
//    UISlider
//    UISwitch
//    UIActivityIndicatorView NO
//    UIProgressView NO
//    UIPageControl
//    UIStepper
//    UITableView NO
//    UITableViewCell NO
//    UIImageView NO
//    UICollectionView NO
//    UICollectionViewCell NO
//    UICollectionReusableView NO
//    UITextView NO
//    UIScrollView NO
//    UIDatePicker
//    UIPickerView NO
//    UIWebView NO
//    UISearchBar NO
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) buttonAction: (id)sender {
    [[KitUserStatisicsUtil sharedInstance] sendUserStatisicsFiles];
//    SecondViewController *svc = [[SecondViewController alloc] init];
//    [self presentViewController:svc animated:YES completion:^{
//        ;
//    }];
}

- (void) swiAction: (id)sender {
    NSLog(@"sw");
}

- (void) scAction: (id)sender {
    NSLog(@"sc");
}

@end
