#import <UIKit/UIKit.h>

#define MIN_FONT_TEST_SIZE 10
#define MAX_FONT_TEST_SIZE 72

CGSize boundSizeOfStringWithFont(NSString *string, UIFont *font);

CGFloat boundHeightOfFont(UIFont *font);

NSArray *heightRatioMinMaxValuesOfFont(NSString *fontName);

NSArray *fontSizeRatioMinMaxValuesOfFont(NSString *fontName, NSString *testString);

void enumerateFontFamilies(void (^block)(NSString *fontFamily));

void enumerateAllFontNames(void (^block)(NSString *fontName));

NSArray *verticalPaddingOfStringWithFont(NSString *string, UIFont *font, CGSize size);

NSArray *verticalPaddingOfFont(UIFont *font);

NSInteger symbolHeight(UIFont *font, NSString *symbol);

NSArray *symbolsHeight(UIFont *font);
