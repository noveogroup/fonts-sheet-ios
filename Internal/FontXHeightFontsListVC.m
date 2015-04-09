#import "FontXHeightFontsListVC.h"
#import "DoubleLabelCell.h"
#import "FontXHeightListVC.h"
#import "fonts_test.h"

@interface FontXHeightFontsListVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *fontNames;

@end


@implementation FontXHeightFontsListVC

static NSString *cellID = @"cellID";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *mutableFontNames = [NSMutableArray array];
        enumerateAllFontNames(^(NSString *fontName) {
            [mutableFontNames addObject:fontName];
        });
        
        self.fontNames = mutableFontNames.copy;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Шрифты";
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([DoubleLabelCell class]) bundle:nil];
    UITableViewCell *cell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    self.tableView.rowHeight = cell.frame.size.height;
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellID];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fontNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoubleLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
 
    [cell switchToSingleLabel];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.firstLabel.text = self.fontNames[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FontXHeightListVC *listVC = [[FontXHeightListVC alloc] init];
    [listVC prepareWithFontName:self.fontNames[indexPath.row]];
    [self.navigationController pushViewController:listVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
