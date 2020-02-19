//
//  AppDelegate.m
//  NativeiOSApp
//
//  Created by ZJQ on 2020/2/19.
//  Copyright © 2020 unity. All rights reserved.
//

#import "AppDelegate.h"
#import <UnityFramework/UnityFramework.h>
#import <UnityFramework/NativeCallProxy.h>

int gArgc = 0;
char **gArgv = NULL;
UnityFramework *UnityFrameworkLoad() {
    NSString *bundlePath = nil;
    bundlePath = [[NSBundle mainBundle] bundlePath];
    bundlePath = [bundlePath stringByAppendingString:@"/Frameworks/UnityFramework.framework"];

    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if ([bundle isLoaded] == false)
        [bundle load];

    UnityFramework *ufw = [bundle.principalClass getInstance];
    if (![ufw appController]) {
        // unity is not initialized
        [ufw setExecuteHeader:&_mh_execute_header];
    }
    return ufw;
}

void showAlert(NSString *title, NSString *msg) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action){
                                                          }];
    [alert addAction:defaultAction];
    [[[UIApplication sharedApplication] delegate].window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@interface AppDelegate () <UnityFrameworkListener, NativeCallsProtocol>

@end

@implementation AppDelegate

- (bool)unityIsInitialized {
    return [self ufw] && [[self ufw] appController];
}

- (void)showHostMainWindow {
    [self showHostMainWindow:@""];
}

- (void)showHostMainWindow:(NSString *)color {
    if ([color isEqualToString:@"blue"])
        self.viewController.unpauseBtn.backgroundColor = UIColor.blueColor;
    else if ([color isEqualToString:@"red"])
        self.viewController.unpauseBtn.backgroundColor = UIColor.redColor;
    else if ([color isEqualToString:@"yellow"])
        self.viewController.unpauseBtn.backgroundColor = UIColor.yellowColor;
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.appLaunchOpts = launchOptions;

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor redColor];
    //ViewController *viewcontroller = [[ViewController alloc] initWithNibName:nil Bundle:nil];
    self.viewController = [[MyViewController alloc] init];
    self.navVC = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navVC;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[[self ufw] appController] applicationWillResignActive:application];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[[self ufw] appController] applicationDidEnterBackground:application];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[[self ufw] appController] applicationWillEnterForeground:application];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[[self ufw] appController] applicationDidBecomeActive:application];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    [[[self ufw] appController] applicationWillTerminate:application];
}

#pragma mark - action

- (void)initUnity {
    if ([self unityIsInitialized]) {
        showAlert(@"Unity already initialized", @"Unload Unity first");
        return;
    }
    if ([self didQuit]) {
        showAlert(@"Unity cannot be initialized after quit", @"Use unload instead");
        return;
    }

    [self setUfw:UnityFrameworkLoad()];
    // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and uncomment call to setDataBundleId
    // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
    [[self ufw] setDataBundleId:"com.unity3d.framework"];
    [[self ufw] registerFrameworkListener:self];
    [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];

    [[self ufw] runEmbeddedWithArgc:gArgc argv:gArgv appLaunchOpts:self.appLaunchOpts];

    // set quit handler to change default behavior of exit app
    [[self ufw] appController].quitHandler = ^() {
        NSLog(@"AppController.quitHandler called");
    };

    UIView *view = [[[self ufw] appController] rootView];

    if (self.showUnityOffButton == nil) {
        self.showUnityOffButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.showUnityOffButton setTitle:@"Show Main" forState:UIControlStateNormal];
        self.showUnityOffButton.frame = CGRectMake(0, 0, 100, 44);
        self.showUnityOffButton.center = CGPointMake(50, 300);
        self.showUnityOffButton.backgroundColor = [UIColor greenColor];
        [view addSubview:self.showUnityOffButton];
        [self.showUnityOffButton addTarget:self action:@selector(showHostMainWindow) forControlEvents:UIControlEventPrimaryActionTriggered];

        self.btnSendMsg = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.btnSendMsg setTitle:@"Send Msg" forState:UIControlStateNormal];
        self.btnSendMsg.frame = CGRectMake(0, 0, 100, 44);
        self.btnSendMsg.center = CGPointMake(150, 300);
        self.btnSendMsg.backgroundColor = [UIColor yellowColor];
        [view addSubview:self.btnSendMsg];
        [self.btnSendMsg addTarget:self action:@selector(sendMsgToUnity) forControlEvents:UIControlEventPrimaryActionTriggered];

        // Unload
        self.unloadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.unloadBtn setTitle:@"Unload" forState:UIControlStateNormal];
        self.unloadBtn.frame = CGRectMake(250, 0, 100, 44);
        self.unloadBtn.center = CGPointMake(250, 300);
        self.unloadBtn.backgroundColor = [UIColor redColor];
        [self.unloadBtn addTarget:self action:@selector(unloadButtonTouched:) forControlEvents:UIControlEventPrimaryActionTriggered];
        [view addSubview:self.unloadBtn];

        // Quit
        self.quitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.quitBtn setTitle:@"Quit" forState:UIControlStateNormal];
        self.quitBtn.frame = CGRectMake(250, 0, 100, 44);
        self.quitBtn.center = CGPointMake(250, 350);
        self.quitBtn.backgroundColor = [UIColor redColor];
        [self.quitBtn addTarget:self action:@selector(quitButtonTouched:) forControlEvents:UIControlEventPrimaryActionTriggered];
        [view addSubview:self.quitBtn];
    }
}

- (void)ShowMainView {
    if (![self unityIsInitialized]) {
        showAlert(@"Unity is not initialized", @"Initialize Unity first");
    } else {
        [[self ufw] showUnityWindow];
    }
}

- (void)unloadButtonTouched:(UIButton *)sender {
    if (![self unityIsInitialized]) {
        showAlert(@"Unity is not initialized", @"Initialize Unity first");
    } else {
        [UnityFrameworkLoad() unloadApplication];
    }
}

- (void)quitButtonTouched:(UIButton *)sender {
    if (![self unityIsInitialized]) {
        showAlert(@"Unity is not initialized", @"Initialize Unity first");
    } else {
        [UnityFrameworkLoad() quitApplication:0];
    }
}

- (void)sendMsgToUnity {
    [[self ufw] sendMessageToGOWithName:"Cube" functionName:"ChangeColor" message:"yellow"];
}


#pragma mark - UnityFrameworkListener

- (void)unityDidUnload:(NSNotification *)notification {
    NSLog(@"unityDidUnload called");

    [[self ufw] unregisterFrameworkListener:self];
    [self setUfw:nil];
    [self showHostMainWindow:@""];
}

- (void)unityDidQuit:(NSNotification *)notification {
    NSLog(@"unityDidQuit called");

    [[self ufw] unregisterFrameworkListener:self];
    [self setUfw:nil];
    [self setDidQuit:true];
    [self showHostMainWindow:@""];
}

@end

