#import <UIKit/UIKit.h>

@interface DoubleLabelCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *firstLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondLabel;

- (void)switchToSingleLabel;

@end
