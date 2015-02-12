//
//  TGRNewUserViewController.h
//  Tagr
//

#import <UIKit/UIKit.h>

@class TGRNewUserViewController;

@protocol TGRNewUserViewControllerDelegate <NSObject>

- (void)newUserViewControllerDidSignup:(TGRNewUserViewController *)controller;

@end

@interface TGRNewUserViewController : UIViewController

@property (nonatomic, weak) id<TGRNewUserViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UITextField *passwordAgainField;

@end
