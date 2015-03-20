//
//  TGRConstants.h
//  Tagr
//

#ifndef Tagr_TGRConstants_h
#define Tagr_TGRConstants_h

static double TGRFeetToMeters(double feet) {
    return feet * 0.3048;
}

static double TGRMetersToFeet(double meters) {
    return meters * 3.281;
}

static double TGRMetersToKilometers(double meters) {
    return meters / 1000.0;
}

static double const TGRDefaultFilterDistance = 1000.0;
static double const TGRWallPostMaximumSearchDistance = 100.0; // Value in kilometers

static NSUInteger const TGRWallPostsSearchDefaultLimit = 20; // Query limit for pins and tableviewcells

// Parse API key constants:
static NSString * const TGRParsePostsClassName = @"Posts";
static NSString * const TGRParsePostUserKey = @"user";
static NSString * const TGRParsePostUsernameKey = @"username";
static NSString * const TGRParsePostTextKey = @"text";
static NSString * const TGRParsePostLocationKey = @"location";
static NSString * const TGRParsePostNameKey = @"name";
static NSString * const TGRParseReportsClassName = @"Reports";
static NSString * const TGRParseReportPostKey = @"post";
static NSString * const TGRParseReportUserKey = @"user";

// NSNotification userInfo keys:
static NSString * const kTGRFilterDistanceKey = @"filterDistance";
static NSString * const kTGRLocationKey = @"location";

// Notification names:
static NSString * const TGRFilterDistanceDidChangeNotification = @"TGRFilterDistanceDidChangeNotification";
static NSString * const TGRCurrentLocationDidChangeNotification = @"TGRCurrentLocationDidChangeNotification";
static NSString * const TGRPostCreatedNotification = @"TGRPostCreatedNotification";

// UI strings:
static NSString * const kTGRWallCantViewPost = @"Can’t view post! Get closer.";

// NSUserDefaults
static NSString * const TGRUserDefaultsFilterDistanceKey = @"filterDistance";

typedef double TGRLocationAccuracy;

#endif // Tagr_TGRConstants_h
