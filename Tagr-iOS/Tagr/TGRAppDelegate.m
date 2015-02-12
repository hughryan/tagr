//
//  TGRAppDelegate.m
//  Tagr
//

#import "TGRAppDelegate.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "TGRConstants.h"
#import "TGRConfigManager.h"
#import "TGRLoginViewController.h"
#import "TGRSettingsViewController.h"
#import "TGRWallViewController.h"

@interface TGRAppDelegate ()
<TGRLoginViewControllerDelegate,
TGRWallViewControllerDelegate,
TGRSettingsViewControllerDelegate>

@end

@implementation TGRAppDelegate

#pragma mark -
#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // ****************************************************************************
    // Parse initialization
    [Parse setApplicationId:@"aHIjMRTdVyFUZEDD0ztoBubC5rYy1yjBd1u3hTPR" clientKey:@"8ptDU37CGWKKwvwLrxELHR8t701pzn29y7OxdrZe"];
    // ****************************************************************************

    // Set the global tint on the navigation bar
    //[[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:43.0f/255.0f green:181.0f/255.0f blue:46.0f/255.0f alpha:1.0f]];
	
	// Get permission to obtain the user's location
	//if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
	//{
	//	[self.locationManager requestWhenInUseAuthorization];
	//}

    // Setup default NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:TGRUserDefaultsFilterDistanceKey] == nil) {
        // If we have no accuracy in defaults, set it to 1000 feet.
        [userDefaults setDouble:TGRFeetToMeters(TGRDefaultFilterDistance) forKey:TGRUserDefaultsFilterDistanceKey];
    }

    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];

    if ([PFUser currentUser]) {
        // Present wall straight-away
        [self presentWallViewControllerAnimated:NO];
    } else {
        // Go to the welcome screen and have them log in or create an account.
        [self presentLoginViewController];
    }

    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

	[[TGRConfigManager sharedManager] fetchConfigIfNeeded];

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark LoginViewController

- (void)presentLoginViewController {
    // Go to the welcome screen and have them log in or create an account.
    TGRLoginViewController *viewController = [[TGRLoginViewController alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
    [self.navigationController setViewControllers:@[ viewController ] animated:NO];
}

#pragma mark Delegate

- (void)loginViewControllerDidLogin:(TGRLoginViewController *)controller {
    [self presentWallViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark WallViewController

- (void)presentWallViewControllerAnimated:(BOOL)animated {
    TGRWallViewController *wallViewController = [[TGRWallViewController alloc] initWithNibName:nil bundle:nil];
    wallViewController.delegate = self;
    [self.navigationController setViewControllers:@[ wallViewController ] animated:animated];
}

#pragma mark Delegate

- (void)wallViewControllerWantsToPresentSettings:(TGRWallViewController *)controller {
    [self presentSettingsViewController];
}

#pragma mark -
#pragma mark SettingsViewController

- (void)presentSettingsViewController {
    TGRSettingsViewController *settingsViewController = [[TGRSettingsViewController alloc] initWithNibName:nil bundle:nil];
    settingsViewController.delegate = self;
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentViewController:settingsViewController animated:YES completion:nil];
}

#pragma mark Delegate

- (void)settingsViewControllerDidLogout:(TGRSettingsViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self presentLoginViewController];
}

@end
