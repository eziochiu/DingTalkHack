#import "DingTalkHelper.h"
#import "LLPunchConfig.h"
#import "LLPunchManager.h"
#import <objc/runtime.h>

%subclass LLCollectConfigController : DTTableViewController

%property (nonatomic, copy) RefreshSettingBlock refreshSettingBlock;

- (void)viewDidLoad{
    %orig;

    [self setNavigationBar];
    [self tidyDataSource];
}

%new
- (void)setNavigationBar{
    self.title = @"收藏配置";
    self.view.backgroundColor = [UIColor whiteColor];
}

%new
- (void)tidyDataSource{

	NSMutableArray <DTCellItem *> *cellItems = [NSMutableArray array];

	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:kArchiverFileDoc];
    for (NSString *fileName in dirEnum) {
        NSArray *names = [fileName componentsSeparatedByString:@"config_item_"];
        if (names.count) {
            NSString *alias = [names lastObject];
            DTCellItem *cellItem = [NSClassFromString(@"DTCellItem") cellItemForDefaultStyleWithIcon:nil title:alias detail:nil comment:nil showIndicator:YES cellDidSelectedBlock:^{
                [LLPunchManager shared].defaultConfigFileName = fileName;
                if(self.refreshSettingBlock){
                    self.refreshSettingBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            cellItem.canEdit = YES;
            cellItem.editingStyle = UITableViewCellEditingStyleDelete;
            cellItem.commitEditingBlock = ^(DTBaseCellItem *cellItem,DTCell *cell){
                //删除配置
                NSString *filePath = [kArchiverFileDoc stringByAppendingPathComponent:fileName];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if ([fileManager fileExistsAtPath:filePath]) {
                    NSError *error = nil;
                    [fileManager removeItemAtPath:filePath error:&error];
                    if (error) {
                        return;
                    }
                    [self tidyDataSource];
                }
            };
            [cellItems addObject:cellItem];
        }
    }

    DTSectionItem *sectionItem = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:cellItems.count?@"点选切换配置，左滑可删除配置":@"暂无收藏配置,请先返回上一页添加配置到收藏"];
    sectionItem.dataSource = cellItems;
    
    DTTableViewDataSource *dataSource = [[NSClassFromString(@"DTTableViewDataSource") alloc] init];
    dataSource.tableViewDataSource = @[sectionItem];
    self.dataSource = dataSource;

    [self.tableView reloadData];
}

%end
