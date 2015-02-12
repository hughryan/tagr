//
//  TGRWallPostCreateViewController.h
//  Tagr
//

#import <UIKit/UIKit.h>

@class TGRWallPostCreateViewController;

@protocol TGRWallPostCreateViewControllerDataSource <NSObject>

- (CLLocation *)currentLocationForWallPostCrateViewController:(TGRWallPostCreateViewController *)controller;

@end

@interface TGRWallPostCreateViewController : UIViewController

@property (nonatomic, weak) id<TGRWallPostCreateViewControllerDataSource> dataSource;

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UILabel *characterCountLabel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *postButton;

- (IBAction)cancelPost:(id)sender;
- (IBAction)postPost:(id)sender;

@end
