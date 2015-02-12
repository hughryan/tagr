//
//  TGRPost.m
//  Tagr
//

#import "TGRPost.h"

#import "TGRConstants.h"

@interface TGRPost ()

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, assign) MKPinAnnotationColor pinColor;

@end

@implementation TGRPost

#pragma mark -
#pragma mark Init

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                          andTitle:(NSString *)title
                       andSubtitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}

- (instancetype)initWithPFObject:(PFObject *)object {
    PFGeoPoint *geoPoint = object[TGRParsePostLocationKey];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    NSString *title = object[TGRParsePostTextKey];
    NSString *subtitle = object[TGRParsePostUserKey][TGRParsePostNameKey] ?: object[TGRParsePostUserKey][TGRParsePostUsernameKey];

    self = [self initWithCoordinate:coordinate andTitle:title andSubtitle:subtitle];
    if (self) {
        self.object = object;
        self.user = object[TGRParsePostUserKey];
    }
    return self;
}

#pragma mark -
#pragma mark Equal

- (BOOL)isEqual:(id)other {
    if (![other isKindOfClass:[TGRPost class]]) {
        return NO;
    }

    TGRPost *post = (TGRPost *)other;

    if (post.object && self.object) {
        // We have a PFObject inside the TGRPost, use that instead.
        return [post.object.objectId isEqualToString:self.object.objectId];
    }

    // Fallback to properties
    return ([post.title isEqualToString:self.title] &&
            [post.subtitle isEqualToString:self.subtitle] &&
            post.coordinate.latitude == self.coordinate.latitude &&
            post.coordinate.longitude == self.coordinate.longitude);
}

#pragma mark -
#pragma mark Accessors

- (void)setTitleAndSubtitleOutsideDistance:(BOOL)outside {
    if (outside) {
        self.title = kTGRWallCantViewPost;
        self.subtitle = nil;
        self.pinColor = MKPinAnnotationColorRed;
    } else {
        self.title = self.object[TGRParsePostTextKey];
        self.subtitle = self.object[TGRParsePostUserKey][TGRParsePostNameKey] ?:
        self.object[TGRParsePostUserKey][TGRParsePostUsernameKey];
        self.pinColor = MKPinAnnotationColorGreen;
    }
}

@end
