//
//  TGRWallPostsTableViewController.h
//  Tagr
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

#import "TGRWallViewController.h"

@class TGRWallPostsTableViewController;

@protocol TGRWallPostsTableViewControllerDataSource <NSObject>

- (CLLocation *)currentLocationForWallPostsTableViewController:(TGRWallPostsTableViewController *)controller;

@end

@interface TGRWallPostsTableViewController : PFQueryTableViewController <TGRWallViewControllerHighlight>

@property (nonatomic, weak) id<TGRWallPostsTableViewControllerDataSource> dataSource;

@end
