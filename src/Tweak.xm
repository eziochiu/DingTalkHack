#import "DingTalkHelper.h"
#import "LLPunchConfig.h"
#import "LLPunchManager.h" 

%hook DTWebViewController

- (BOOL)pluginInstance:(id)arg1 jsapiShouldCall:(id)arg2{
    return YES;
}

%end

%hook LAPluginInstanceCollector

- (void)handleJavaScriptRequest:(id)arg2 callback:(void(^)(id dic))arg3{
    if(![LLPunchManager shared].punchConfig.isOpenPunchHelper){
        %orig;
    } else if([arg2[@"action"] isEqualToString:@"getInterface"]){
        id callback = ^(id dic){
            NSDictionary *retDic = @{
                @"errorCode" : @"0",
                @"errorMessage": @"",
                @"keep": @"0",
                @"result": @{
                    @"macIp": [LLPunchManager shared].punchConfig.wifiMacIp?:@"",
                    @"ssid": [LLPunchManager shared].punchConfig.wifiName?:@""
                }
            };
            arg3(![LLPunchManager shared].punchConfig.isLocationPunchMode ? retDic : dic);
        };
        %orig(arg2,callback);
    } else if([arg2[@"action"] isEqualToString:@"start"]){
        id callback = ^(id dic){
            NSDictionary *retDic = @{
                @"errorCode" : @"0",
                @"errorMessage": @"",
                @"keep": @"1",
                @"result": @{
                    @"aMapCode": @"0",
                    @"accuracy": [LLPunchManager shared].punchConfig.accuracy?:@"",
                    @"latitude": [LLPunchManager shared].punchConfig.latitude?:@"",
                    @"longitude": [LLPunchManager shared].punchConfig.longitude?:@"",
                    @"netType": @"",
                    @"operatorType": @"unknown",
                    @"resultCode": @"0",
                    @"resultMessage": @""
                }
            }; 
            arg3([LLPunchManager shared].punchConfig.isLocationPunchMode ? retDic : dic);
        };
        %orig(arg2,callback);
    } else {
        %orig;
    }
}

%end

%hook DTSettingListViewController

- (void)tidyDatasource{
    %orig;
    DTCellItem *cellItem = [%c(DTCellItem) cellItemForDefaultStyleWithIcon:nil title:@"钉钉小助手" image:nil showIndicator:YES cellDidSelectedBlock:^{
        LLSettingController *settingVC = [[%c(LLSettingController) alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }];
    DTSectionItem *sectionItem = [%c(DTSectionItem) itemWithSectionHeader:nil sectionFooter:nil];
    NSMutableArray *sectionDataSource = [NSMutableArray array];
    [sectionDataSource addObject:cellItem];
    sectionItem.dataSource = sectionDataSource;
    NSMutableArray *dataSourceArr = [self.dataSource.tableViewDataSource mutableCopy];
    [dataSourceArr insertObject:sectionItem atIndex:0];
    self.dataSource.tableViewDataSource = dataSourceArr;
}

%end

%subclass LLSettingController : DTTableViewController

- (void)viewDidLoad {
    %orig;

    [self setNavigationBar];
    [self tidyDataSource];
}

%new
- (void)setNavigationBar{
    self.title = @"钉钉小助手";
    self.view.backgroundColor = [UIColor whiteColor];
}

%new
- (void)tidyDataSource{
    DTCellItem *punchSettingItem = [NSClassFromString(@"DTCellItem") cellItemForDefaultStyleWithIcon:nil title:@"打卡设置" image:nil showIndicator:YES cellDidSelectedBlock:^{
        LLPunchSettingController *punchSettingVC = [[%c(LLPunchSettingController) alloc] init];
        [self.navigationController pushViewController:punchSettingVC animated:YES];
    }];

    DTCellItem *githubItem = [NSClassFromString(@"DTCellItem") cellItemForDefaultStyleWithIcon:nil title:@"我的Github" detail:nil comment:@"欢迎⭐️" showIndicator:YES cellDidSelectedBlock:^{
        DTWebViewController *githubWebVC = [%c(DTWebViewController) createPageViewControllerWithString:@"https://github.com/kevll/DingTalkHelper" relativeToURL:nil];
        [self.navigationController pushViewController:githubWebVC animated:YES];
    }];

    DTCellItem *blogItem = [NSClassFromString(@"DTCellItem") cellItemForDefaultStyleWithIcon:nil title:@"我的博客" detail:nil comment:nil showIndicator:YES cellDidSelectedBlock:^{
        DTWebViewController *blogWebVC = [%c(DTWebViewController) createPageViewControllerWithString:@"https://kevll.github.io/" relativeToURL:nil];
        [self.navigationController pushViewController:blogWebVC animated:YES];
    }];

    DTCellItem *rewardItem = [NSClassFromString(@"DTCellItem") cellItemForDefaultStyleWithIcon:nil title:@"打赏作者" detail:nil comment:@"请我喝杯☕️" showIndicator:YES cellDidSelectedBlock:^{
        DTWebViewController *rewardWebVC = [%c(DTWebViewController) createPageViewControllerWithString:@"https://kevll.github.io/reward.html" relativeToURL:nil];
        [self.navigationController pushViewController:rewardWebVC animated:YES];
        //LLRewardController *rewardVC = [[%c(LLRewardController) alloc] init];
        //[self.navigationController pushViewController:rewardVC animated:YES];
    }];

    DTSectionItem *punchSectionItem = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:nil];
    punchSectionItem.dataSource = @[punchSettingItem];

    DTSectionItem *aboutSectionItem = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:nil];
    aboutSectionItem.dataSource = @[blogItem,githubItem,rewardItem];

    DTTableViewDataSource *dataSource = [[NSClassFromString(@"DTTableViewDataSource") alloc] init];
    dataSource.tableViewDataSource = @[punchSectionItem,aboutSectionItem];
    self.dataSource = dataSource;

    [self.tableView reloadData];
}

%end

%hook DTInfoPlist

+ (NSString *)getAppBundleId{
	return @"com.laiwang.DingTalk";
}

%end

