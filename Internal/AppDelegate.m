#import "AppDelegate.h"
#import "MainVC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MainVC *mainVC = [[MainVC alloc] init];
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:mainVC];
    navigationController.navigationBar.translucent = NO;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
