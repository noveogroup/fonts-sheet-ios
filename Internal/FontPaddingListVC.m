#import "FontPaddingListVC.h"
#import "DoubleLabelCell.h"
#import "fonts_test.h"

@interface FontPaddingListVC () <UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *paddings;

@end


@implementation FontPaddingListVC

static NSString *cellID = @"cellID";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Опорный символ";
        
        NSMutableArray *mutablePaddings = [NSMutableArray array];
        enumerateAllFontNames(^(NSString *fontName) {
            UIFont *font = [UIFont fontWithName:fontName size:14];
            NSArray *padding = verticalPaddingOfFont(font);
            [mutablePaddings addObject:@[fontName, padding]];
        });
        
        self.paddings = mutablePaddings.copy;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([DoubleLabelCell class]) bundle:nil];
    UITableViewCell *cell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    self.tableView.rowHeight = cell.frame.size.height;
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellID];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.paddings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoubleLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSArray *fontPaddings = self.paddings[indexPath.row];
    
    cell.firstLabel.text = fontPaddings[0];
    cell.secondLabel.text = [NSString stringWithFormat:@"%4.2f  %4.2f", [fontPaddings[1][0] floatValue], [fontPaddings[1][1] floatValue]];
    
    return cell;
}

@end
