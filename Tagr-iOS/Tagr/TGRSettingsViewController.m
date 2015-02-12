//
//  TGRSettingsViewController.m
//  Tagr
//

#import "TGRSettingsViewController.h"

#import <Parse/Parse.h>

#import "TGRConstants.h"
#import "TGRConfigManager.h"

typedef NS_ENUM(uint8_t, TGRSettingsTableViewSection)
{
    TGRSettingsTableViewSectionDistance = 0,
    TGRSettingsTableViewSectionLogout,

    TGRSettingsTableViewNumberOfSections
};

static uint16_t const TGRSettingsTableViewLogoutNumberOfRows = 1;

@interface TGRSettingsViewController ()

@property (nonatomic, strong) NSArray *distanceOptions;
@property (nonatomic, assign) CLLocationAccuracy filterDistance;

@end

@implementation TGRSettingsViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _filterDistance = [[NSUserDefaults standardUserDefaults] doubleForKey:TGRUserDefaultsFilterDistanceKey];
        [self loadAvailableDistanceOptions];
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark -
#pragma mark Accessors

- (void)setFilterDistance:(CLLocationAccuracy)filterDistance {
    if (self.filterDistance != filterDistance) {
        _filterDistance = filterDistance;

        [[NSUserDefaults standardUserDefaults] setDouble:filterDistance forKey:TGRUserDefaultsFilterDistanceKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:TGRFilterDistanceDidChangeNotification
                                                                object:nil
                                                              userInfo:@{ kTGRFilterDistanceKey : @(filterDistance) }];
        });
    }
}

#pragma mark -
#pragma mark UINavigationBar-based actions

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Data

- (void)loadAvailableDistanceOptions {
	NSMutableArray *distanceOptions = [[[TGRConfigManager sharedManager] filterDistanceOptions] mutableCopy];

    NSNumber *defaultFilterDistance = @(TGRDefaultFilterDistance);
    if (![distanceOptions containsObject:defaultFilterDistance]) {
        [distanceOptions addObject:defaultFilterDistance];
    }

    [distanceOptions sortUsingSelector:@selector(compare:)];

    self.distanceOptions = [distanceOptions copy];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TGRSettingsTableViewNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case TGRSettingsTableViewSectionDistance:
            return [self.distanceOptions count];
            break;
        case TGRSettingsTableViewSectionLogout:
            return TGRSettingsTableViewLogoutNumberOfRows;
            break;
        case TGRSettingsTableViewNumberOfSections:
            return 0;
            break;
    };

	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SettingsTableView";
    if (indexPath.section == TGRSettingsTableViewSectionDistance) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

		TGRLocationAccuracy distance = [self.distanceOptions[indexPath.row] doubleValue];

        // Configure the cell.
        cell.textLabel.text = [NSString stringWithFormat:@"%d feet", (int)distance];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;

        if (self.filterDistance == 0.0) {
            NSLog(@"We have a zero filter distance!");
        }

        if (abs(TGRFeetToMeters(distance) - self.filterDistance) < 0.001 ) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        return cell;
    } else if (indexPath.section == TGRSettingsTableViewSectionLogout) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

        // Configure the cell.
        cell.textLabel.text = @"Log out of Tagr";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;

        return cell;
    }

    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case TGRSettingsTableViewSectionDistance:
            return @"Search Distance";
            break;
        case TGRSettingsTableViewSectionLogout:
        case TGRSettingsTableViewNumberOfSections:
            return nil;
            break;
    }

    return nil;
}

#pragma mark -
#pragma mark UITableViewDelegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TGRSettingsTableViewSectionDistance) {
        [aTableView deselectRowAtIndexPath:indexPath animated:YES];

        // if we were already selected, bail and save some work.
        UITableViewCell *selectedCell = [aTableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            return;
        }

        // uncheck all visible cells.
        for (UITableViewCell *cell in [aTableView visibleCells]) {
            if (cell.accessoryType != UITableViewCellAccessoryNone) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;

        TGRLocationAccuracy distanceForCellInFeet = [self.distanceOptions[indexPath.row] doubleValue];
        self.filterDistance = TGRFeetToMeters(distanceForCellInFeet);
    } else if (indexPath.section == TGRSettingsTableViewSectionLogout) {
        [aTableView deselectRowAtIndexPath:indexPath animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log out of Tagr?"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Log out"
                                                  otherButtonTitles:@"Cancel", nil];
        [alertView show];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == alertView.cancelButtonIndex) {
        // Log out.
        [PFUser logOut];

        [self.delegate settingsViewControllerDidLogout:self];
	}
}

// Nil implementation to avoid the default UIAlertViewDelegate method, which says:
// "Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button"
// Since we have "Log out" at the cancel index (to get it out from the normal "Ok whatever get this dialog outta my face"
// position, we need to deal with the consequences of that.
- (void)alertViewCancel:(UIAlertView *)alertView {
    return;
}

@end
