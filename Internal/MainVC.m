#import "MainVC.h"
#import "FontRatioListVC.h"
#import "FontPaddingListVC.h"
#import "FontXHeightFontsListVC.h"

@interface MainVC ()

- (IBAction)onRatiosButtonTap;
- (IBAction)onXRatiosButtonTap;
- (IBAction)onPaddingsButtonTap;

@end


@implementation MainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Таблица шрифтов";
    }
    
    return self;
}

#pragma mark - Logic

- (void)onRatiosButtonTap
{
    FontRatioListVC *listVC = [[FontRatioListVC alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)onXRatiosButtonTap
{
    FontXHeightFontsListVC *listVC = [[FontXHeightFontsListVC alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)onPaddingsButtonTap
{
    FontPaddingListVC *listVC = [[FontPaddingListVC alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}

@end
