//
//  TGRPostTableViewCell.h
//  Tagr
//

#import <UIKit/UIKit.h>

extern CGFloat const TGRPostTableViewCellLabelsFontSize;

typedef NS_ENUM(uint8_t, TGRPostTableViewCellStyle)
{
    TGRPostTableViewCellStyleLeft = 1,
    TGRPostTableViewCellStyleRight
};

@class TGRPost;

@interface TGRPostTableViewCell : UITableViewCell

@property (nonatomic, assign, readonly) TGRPostTableViewCellStyle postTableViewCellStyle;

+ (CGSize)sizeThatFits:(CGSize)boundingSize forPost:(TGRPost *)post;

- (instancetype)initWithPostTableViewCellStyle:(TGRPostTableViewCellStyle)style
                               reuseIdentifier:(NSString *)reuseIdentifier;

- (void)updateFromPost:(TGRPost *)post;

@end
