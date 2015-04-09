#import "FontRatioListVC.h"
#import "DoubleLabelCell.h"
#import "fonts_test.h"

@interface FontRatioListVC () <UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *fontsRatios;

@end


@implementation FontRatioListVC

static NSString *cellID = @"cellID";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *mutableRatios = [NSMutableArray array];
        enumerateAllFontNames(^(NSString *fontName) {
            NSArray *ratios = heightRatioMinMaxValuesOfFont(fontName);
            [mutableRatios addObject:@[fontName, ratios]];
        });
        
        self.fontsRatios = mutableRatios.copy;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Коэффициенты";
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([DoubleLabelCell class]) bundle:nil];
    UITableViewCell *cell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    self.tableView.rowHeight = cell.frame.size.height;
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellID];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fontsRatios.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoubleLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSArray *fontRatio = self.fontsRatios[indexPath.row];
    
    cell.firstLabel.text = fontRatio[0];
    cell.secondLabel.text = [NSString stringWithFormat:@"%4.2f - %4.2f", [fontRatio[1][0] floatValue], [fontRatio[1][1] floatValue]];
    
    return cell;
}

@end
