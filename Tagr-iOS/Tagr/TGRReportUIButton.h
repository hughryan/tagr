//
//  TGRReportUIButton.h
//  Tagr
//

#ifndef Tagr_TGRReportUIButton_h
#define Tagr_TGRReportUIButton_h

#import "TGRPost.h"

@interface TGRReportUIButton : UIButton

@property (nonatomic, strong) TGRPost *post;

+ (instancetype)buttonWithType:(UIButtonType)buttonType withPost:(TGRPost*)p;

@end

#endif
