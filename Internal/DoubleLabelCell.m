#import "DoubleLabelCell.h"

@interface DoubleLabelCell ()

@end


@implementation DoubleLabelCell

- (void)switchToSingleLabel
{
    self.secondLabel.text = @"";
    CGRect labelRect = self.firstLabel.frame;
    labelRect.size.width = self.frame.size.width - 2 * labelRect.origin.x;
    self.firstLabel.frame = labelRect;
}

@end
