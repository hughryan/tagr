//
//  TGRSettingsViewController.h
//  Tagr
//

#import <UIKit/UIKit.h>

@class TGRSettingsViewController;

@protocol TGRSettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDidLogout:(TGRSettingsViewController *)controller;

@end

@interface TGRSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) id<TGRSettingsViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
