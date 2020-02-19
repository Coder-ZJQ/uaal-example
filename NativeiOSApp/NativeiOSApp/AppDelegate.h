//
//  AppDelegate.h
//  NativeiOSApp
//
//  Created by ZJQ on 2020/2/19.
//  Copyright © 2020 unity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewController.h"

// keep arg for unity init from non main
extern int gArgc;
extern char** gArgv;

@class UnityFramework;
@interface AppDelegate : UIResponder<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIButton *showUnityOffButton;
@property (nonatomic, strong) UIButton *btnSendMsg;
@property (nonatomic, strong) UINavigationController *navVC;
@property (nonatomic, strong) UIButton *unloadBtn;
@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) MyViewController *viewController;
@property (nonatomic, copy) NSDictionary *appLaunchOpts;

@property UnityFramework* ufw;
@property bool didQuit;

- (void)initUnity;
- (void)ShowMainView;

- (void)didFinishLaunching:(NSNotification*)notification;
- (void)didBecomeActive:(NSNotification*)notification;
- (void)willResignActive:(NSNotification*)notification;
- (void)didEnterBackground:(NSNotification*)notification;
- (void)willEnterForeground:(NSNotification*)notification;
- (void)willTerminate:(NSNotification*)notification;
- (void)unityDidUnloaded:(NSNotification*)notification;

@end
