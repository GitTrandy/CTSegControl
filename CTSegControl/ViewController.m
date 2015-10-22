//
//  ViewController.m
//  CTSegControl
//
//  Created by trandy on 15/10/22.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import "ViewController.h"
#import "CTSegControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CTSegControl* control = [[CTSegControl alloc] initWithTitle:@"1111",@"222",@"333",nil];
    control.frame = CGRectMake(50, 100, 200, 30);
    control.backgroundColor = [UIColor yellowColor];
    control.textFont = [UIFont systemFontOfSize:15];
    [control setSegControlWillSelected:^(NSInteger index) {
        NSLog(@"title setSegControlWillSelected index = %ld",index);
    }];
    [control setSegControlDidSelected:^(NSInteger index) {
        NSLog(@"title setSegControlDidSelected index = %ld",index);
    }];
    [self.view addSubview:control];
    
    CTSegControl* control1 = [[CTSegControl alloc] initWithView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]],[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.png"]],nil];
    CGRect rect = {50, 150, 250, 60};
    control1.frame = rect;
    [control1 setSegControlWillSelected:^(NSInteger index) {
        NSLog(@"view setSegControlWillSelected index = %ld",index);
    }];
    [control1 setSegControlDidSelected:^(NSInteger index) {
        NSLog(@"view setSegControlWillSelected index = %ld",index);
    }];
    control1.isAnimate = NO;
    [self.view addSubview:control1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
