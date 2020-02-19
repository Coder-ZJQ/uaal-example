#import <UIKit/UIKit.h>
#include <UnityFramework/UnityFramework.h>
#import "AppDelegate.h"

int main(int argc, char *argv[]) {
    gArgc = argc;
    gArgv = argv;

    @autoreleasepool {
        if (false) {
            
            // run UnityFramework as main app
            NSString *bundlePath = nil;
            bundlePath = [[NSBundle mainBundle] bundlePath];
            bundlePath = [bundlePath stringByAppendingString:@"/Frameworks/UnityFramework.framework"];

            NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
            if ([bundle isLoaded] == false) {
                [bundle load];
            }

            UnityFramework *ufw = [bundle.principalClass getInstance];
            if (![ufw appController]) {
                // unity is not initialized
                [ufw setExecuteHeader:&_mh_execute_header];
            }

            // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and call to setDataBundleId
            // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
            [ufw setDataBundleId:"com.unity3d.framework"];
            [ufw runUIApplicationMainWithArgc:argc argv:argv];
        } else {
            // run host app first and then unity later
            UIApplicationMain(argc, argv, nil, [NSString stringWithUTF8String:"AppDelegate"]);
        }
    }

    return 0;
}
