//
//  MyViewController.m
//  NativeiOSApp
//
//  Created by ZJQ on 2020/2/19.
//  Copyright © 2020 unity. All rights reserved.
//

#import "MyViewController.h"

@implementation MyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];

    // INIT UNITY
    self.unityInitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.unityInitBtn setTitle:@"Init" forState:UIControlStateNormal];
    self.unityInitBtn.frame = CGRectMake(0, 0, 100, 44);
    self.unityInitBtn.center = CGPointMake(50, 120);
    self.unityInitBtn.backgroundColor = [UIColor greenColor];
    [self.unityInitBtn addTarget:[UIApplication sharedApplication].delegate action:@selector(initUnity) forControlEvents:UIControlEventPrimaryActionTriggered];
    [self.view addSubview:self.unityInitBtn];

    // SHOW UNITY
    self.unpauseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.unpauseBtn setTitle:@"Show Unity" forState:UIControlStateNormal];
    self.unpauseBtn.frame = CGRectMake(100, 0, 100, 44);
    self.unpauseBtn.center = CGPointMake(150, 120);
    self.unpauseBtn.backgroundColor = [UIColor lightGrayColor];
    [self.unpauseBtn addTarget:[UIApplication sharedApplication].delegate action:@selector(ShowMainView) forControlEvents:UIControlEventPrimaryActionTriggered];
    [self.view addSubview:self.unpauseBtn];

    // UNLOAD UNITY
    self.unloadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.unloadBtn setTitle:@"Unload" forState:UIControlStateNormal];
    self.unloadBtn.frame = CGRectMake(200, 0, 100, 44);
    self.unloadBtn.center = CGPointMake(250, 120);
    self.unloadBtn.backgroundColor = [UIColor redColor];
    [self.unloadBtn addTarget:[UIApplication sharedApplication].delegate action:@selector(unloadButtonTouched:) forControlEvents:UIControlEventPrimaryActionTriggered];
    [self.view addSubview:self.unloadBtn];

    // QUIT UNITY
    self.quitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.quitBtn setTitle:@"Quit" forState:UIControlStateNormal];
    self.quitBtn.frame = CGRectMake(300, 0, 100, 44);
    self.quitBtn.center = CGPointMake(250, 170);
    self.quitBtn.backgroundColor = [UIColor redColor];
    [self.quitBtn addTarget:[UIApplication sharedApplication].delegate action:@selector(quitButtonTouched:) forControlEvents:UIControlEventPrimaryActionTriggered];
    [self.view addSubview:self.quitBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
