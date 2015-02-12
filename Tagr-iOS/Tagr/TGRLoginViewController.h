//
//  TGRLoginViewController.h
//  Tagr
//

#import <UIKit/UIKit.h>

@class TGRLoginViewController;

@protocol TGRLoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogin:(TGRLoginViewController *)controller;

@end

@interface TGRLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<TGRLoginViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

@end
