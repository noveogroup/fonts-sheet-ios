#import "FontXHeightListVC.h"
#import "DoubleLabelCell.h"
#import "fonts_test.h"

@interface FontXHeightListVC () <UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSArray *xHeights;

- (IBAction)onSegmentedControlTap;

@end


@implementation FontXHeightListVC

static NSString *cellID = @"cellID";

#pragma mark - Logic

- (void)prepareWithFontName:(NSString *)fontName
{
    self.navigationItem.title = fontName;
    
    NSMutableArray *mutableXHeights = [NSMutableArray array];
    for (NSInteger i = MIN_FONT_TEST_SIZE; i <= MAX_FONT_TEST_SIZE; i++) {
        NSArray *heights = symbolsHeight([UIFont fontWithName:fontName size:i]);
        [mutableXHeights addObject:@[@(i), heights]];
    }
    self.xHeights = mutableXHeights.copy;
}

- (void)onSegmentedControlTap
{
    [self.tableView reloadData];
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
    return self.xHeights.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoubleLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSArray *heights = self.xHeights[indexPath.row];
    
    [cell switchToSingleLabel];
    cell.firstLabel.textAlignment = NSTextAlignmentCenter;
    cell.firstLabel.text = [NSString stringWithFormat:@"%ld   %ld", (long)[heights[0] integerValue], (long)[heights[1][self.segmentedControl.selectedSegmentIndex] integerValue]];
    
    return cell;
}

@end
