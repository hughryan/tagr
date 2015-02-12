//
//  TGRWallViewController.h
//  Tagr
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class TGRWallViewController;

@protocol TGRWallViewControllerDelegate <NSObject>

- (void)wallViewControllerWantsToPresentSettings:(TGRWallViewController *)controller;

@end

@class TGRPost;

@interface TGRWallViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) id<TGRWallViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

- (IBAction)postButtonSelected:(id)sender;

@end

@protocol TGRWallViewControllerHighlight <NSObject>

- (void)highlightCellForPost:(TGRPost *)post;
- (void)unhighlightCellForPost:(TGRPost *)post;

@end
