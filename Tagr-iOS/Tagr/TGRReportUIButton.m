//
//  TGRReportUIButton.m
//  Tagr
//

#import <Foundation/Foundation.h>

#import "TGRReportUIButton.h"

@implementation TGRReportUIButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType withPost:(TGRPost*)p {
	TGRReportUIButton *button = [super buttonWithType:buttonType];
	[button postButtonWithTypeInit:p];
	return button;
}

/// Because we can't override init on a uibutton, do init steps here.
- (void)postButtonWithTypeInit:(TGRPost*)p {
	self.post = p;
}

/// Make your button have a custom appearance when highlighted here.
- (void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
}

@end