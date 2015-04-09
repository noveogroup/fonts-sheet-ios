#import "fonts_test.h"

CGSize boundSizeOfStringWithFont(NSString *string, UIFont *font)
{
    if ([string respondsToSelector:@selector(sizeWithAttributes:)]) {
        return [string sizeWithAttributes:@{NSFontAttributeName: font}];
    } else {
        return [string sizeWithFont:font];
    }
}

CGFloat boundHeightOfFont(UIFont *font)
{
    NSString *testString = @"";
    return boundSizeOfStringWithFont(testString, font).height;
}

NSArray *heightRatioMinMaxValuesOfFont(NSString *fontName)
{
    CGFloat minValue = CGFLOAT_MAX;
    CGFloat maxValue = 0;
    
    for (NSInteger i = MIN_FONT_TEST_SIZE; i <= MAX_FONT_TEST_SIZE; i++) {
        UIFont *font = [UIFont fontWithName:fontName size:i];
        CGFloat boundHeight = boundHeightOfFont(font);
        CGFloat ratio = boundHeight / i;
        
        if (ratio < minValue) {
            minValue = ratio;
        }
        
        if (ratio > maxValue) {
            maxValue = ratio;
        }
    }
    
    return @[@(minValue), @(maxValue)];
}

NSArray *fontSizeRatioMinMaxValuesOfFont(NSString *fontName, NSString *testString)
{
    CGFloat minValue = CGFLOAT_MAX;
    CGFloat maxValue = 0;
    
    for (NSInteger i = MIN_FONT_TEST_SIZE; i <= MAX_FONT_TEST_SIZE; i++) {
        UIFont *font = [UIFont fontWithName:fontName size:i];
        CGSize testStringSize = boundSizeOfStringWithFont(testString, font);
        NSArray *paddings = verticalPaddingOfStringWithFont(testString, font, testStringSize);
        
        CGFloat testStringHeight = testStringSize.height - [paddings[0] floatValue] - [paddings[1] floatValue];
        CGFloat ratio = (CGFloat)i / testStringHeight;
        
        if (ratio < minValue) {
            minValue = ratio;
        }
        
        if (ratio > maxValue) {
            maxValue = ratio;
        }
    }
    
    return @[@(minValue), @(maxValue)];
}

void enumerateFontFamilies(void (^block)(NSString *fontFamily))
{
    NSArray *familyNames = [[UIFont familyNames] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    
    [familyNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

void enumerateAllFontNames(void (^block)(NSString *fontName))
{
    enumerateFontFamilies(^(NSString *fontFamily) {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamily];
        [fontNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            block(obj);
        }];
    });
    
    CGFloat systemFontSize = [UIFont systemFontSize];
    
    NSArray *systemFonts = @[
                             [UIFont systemFontOfSize:systemFontSize],
                             [UIFont boldSystemFontOfSize:systemFontSize],
                             [UIFont italicSystemFontOfSize:systemFontSize],
                             ];
    
    [systemFonts enumerateObjectsUsingBlock:^(UIFont *obj, NSUInteger idx, BOOL *stop) {
        block(obj.fontName);
    }];
}

NSArray *verticalPaddingOfStringWithFont(NSString *string, UIFont *font, CGSize size)
{
    NSInteger width = ceil(size.width);
    NSInteger height = ceil(size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = string;
    
    NSInteger imgBytesPerRow = 4 * width;
    NSInteger imgDataSize = imgBytesPerRow * height;
    
    UInt8 *imgData = calloc(1, imgDataSize);
    
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    CGContextRef imgCtx =
    CGBitmapContextCreate(imgData,
                          width,
                          height,
                          8,
                          imgBytesPerRow,
                          colorSpaceRGB,
                          kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextTranslateCTM(imgCtx, 0, height);
    CGContextScaleCTM(imgCtx, 1, -1);
    
    [label.layer renderInContext:imgCtx];
    
    CGColorSpaceRelease(colorSpaceRGB);
    CGContextRelease(imgCtx);
    
    NSInteger minY = 0;
    NSInteger maxY = 0;
    for (NSInteger y = 0; y < height; y++) {
        for (NSInteger x = 0; x < width; x++) {
            NSInteger offset = imgBytesPerRow * y + x * 4;
            UInt8 alpha = imgData[offset + 3];
            
            if (alpha > 0) {
                if (minY == 0) {
                    minY = y;
                }
                
                maxY = y;
            }
        }
    }
    
    free(imgData);
    
    return @[@(minY), @(height - maxY)];
}

NSArray *verticalPaddingOfFont(UIFont *font)
{
    CGFloat height = font.pointSize * 3;
    
    CGFloat (^deltaOf)(UIFont *f, NSString *s, CGFloat height) = ^(UIFont *f, NSString *s, CGFloat height) {
        CGSize size = boundSizeOfStringWithFont(s, f);
        size.height = height;
        NSArray *paddings = verticalPaddingOfStringWithFont(s, f, size);
        CGFloat top = [paddings[0] floatValue];
        CGFloat bottom = [paddings[1] floatValue];
        
        CGFloat max = MAX(top, bottom);
        CGFloat min = MIN(top, bottom);
        
        return (CGFloat)((max - min) / min);
    };
    
    CGFloat deltax = deltaOf(font, @"x", height);
    CGFloat deltaX = deltaOf(font, @"X", height);
    
    return @[@(deltax), @(deltaX)];
}

NSInteger symbolHeight(UIFont *font, NSString *symbol)
{
    CGSize size = boundSizeOfStringWithFont(symbol, font);
    NSArray *paddings = verticalPaddingOfStringWithFont(symbol, font, size);
    return ceilf(size.height) - [paddings[0] integerValue] - [paddings[1] integerValue];
}

NSArray *symbolsHeight(UIFont *font)
{
    NSInteger xHeight = symbolHeight(font, @"x");
    NSInteger XHeight = symbolHeight(font, @"X");
    
    return @[@(xHeight), @(XHeight)];
}
