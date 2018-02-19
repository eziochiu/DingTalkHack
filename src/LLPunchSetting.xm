#import "DingTalkHelper.h"
#import "LLPunchConfig.h"
#import "LLPunchManager.h"

%subclass LLPunchSettingController : DTTableViewController <AMapLocationManagerDelegate>

%property (nonatomic, retain) AMapLocationManager *locationManager;
%property (nonatomic, retain) LLPunchConfig *punchConfig;

- (id)init{
    self = %orig;
    if(self){
        self.locationManager = [[%c(AMapLocationManager) alloc] init];
        self.locationManager.delegate = (id<AMapLocationManagerDelegate>)self;
        self.punchConfig = [[LLPunchManager shared].punchConfig copy];
    }
    return self;
}

- (void)viewDidLoad {
    %orig;

    [self setNavigationBar];
    [self tidyDataSource];
}

%new
- (void)setNavigationBar{
    self.title = @"打卡设置";
    self.view.backgroundColor = [UIColor whiteColor];
}

%new
- (void)tidyDataSource{
    NSMutableArray <DTSectionItem *> *sectionItems = [NSMutableArray array];
    
    DTCellItem *configSelItem = [NSClassFromString(@"DTCellItem") cellItemForDefaultStyleWithIcon:nil title:@"使用收藏配置" image:nil showIndicator:YES cellDidSelectedBlock:^{
        LLCollectConfigController *collectConfigVC = [[NSClassFromString(@"LLCollectConfigController") alloc] init];
        collectConfigVC.refreshSettingBlock = ^{
            self.punchConfig = [[LLPunchManager shared].punchConfig copy];
            [self tidyDataSource];
        };
        [self.navigationController pushViewController:collectConfigVC animated:YES];
    }];

    DTCellItem *aliasItem = [NSClassFromString(@"DTCellItem") cellItemForEditStyleWithTitle:@"配置别名：" textFieldHint:@"请输入配置别名" textFieldLimt:NSIntegerMax textFieldHelpBtnNormalImage:nil textFieldHelpBtnHighLightImage:nil textFieldDidChangeEditingBlock:^(DTCellItem *item,DTCell *cell,UITextField *textField){
        self.punchConfig.configAlias = textField.text;
    }];
    aliasItem.textFieldText = self.punchConfig.configAlias;
    DTSectionItem *aliasSectionItem = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:nil];
    aliasSectionItem.dataSource = @[configSelItem,aliasItem];
    [sectionItems addObject:aliasSectionItem];

    DTCellItem *openPunchCellItem = [NSClassFromString(@"DTCellItem") cellItemForSwitcherStyleWithTitle:@"是否开启打卡助手" isSwitcherOn:self.punchConfig.isOpenPunchHelper switcherValueDidChangeBlock:^(DTCellItem *item,DTCell *cell,UISwitch *aSwitch){
        self.punchConfig.isOpenPunchHelper = aSwitch.on;
    }];
    DTCellItem *punchModeCellItem = [NSClassFromString(@"DTCellItem") cellItemForSwitcherStyleWithTitle:@"打卡模式定位/WIFI" isSwitcherOn:self.punchConfig.isLocationPunchMode switcherValueDidChangeBlock:^(DTCellItem *item,DTCell *cell,UISwitch *aSwitch){
        self.punchConfig.isLocationPunchMode = aSwitch.on;
    }];
    DTSectionItem *switchSectionItem = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:@"打开打卡模式开关使用定位打卡，关闭开关使用Wi-Fi打卡"];
    switchSectionItem.dataSource = @[openPunchCellItem,punchModeCellItem];
    [sectionItems addObject:switchSectionItem];
    
    NSArray <NSString *> *titles = @[@"Wi-Fi 名称",@"Wi-Fi MAC地址",@"精度",@"经度",@"纬度"];
    NSArray <NSString *> *hints  = @[@"请输入Wi-Fi名称",@"请输入Wi-Fi MAC地址",@"请输入定位精度",@"请输入定位经度",@"请输入定位纬度"];
    NSArray <NSString *> *texts    = @[self.punchConfig.wifiName?:@"",self.punchConfig.wifiMacIp?:@"",self.punchConfig.accuracy?:@"",self.punchConfig.latitude?:@"",self.punchConfig.longitude?:@""];
    
    NSMutableArray <DTCellItem *> *cellItems = [NSMutableArray array];

    for (int i = 0; i < 5; i++) {
        DTCellItem *cellItem = [NSClassFromString(@"DTCellItem") cellItemForEditStyleWithTitle:titles[i] textFieldHint:hints[i] textFieldLimt:NSIntegerMax textFieldHelpBtnNormalImage:nil textFieldHelpBtnHighLightImage:nil textFieldDidChangeEditingBlock:^(DTCellItem *item,DTCell *cell,UITextField *textField){
            switch(i){
                case 0:
                    self.punchConfig.wifiName = textField.text;
                    break;
                case 1:
                    self.punchConfig.wifiMacIp = textField.text;
                    break;
                case 2:
                    self.punchConfig.accuracy = textField.text;
                    break;
                case 3:
                    self.punchConfig.latitude = textField.text;
                    break;
                case 4:
                    self.punchConfig.longitude = textField.text;
                    break;
            }
        }];
        cellItem.textFieldText = texts[i];
        [cellItems addObject:cellItem];
        if (i == 1 || i== 4) {
            DTSectionItem *sectionItem = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:nil];
            sectionItem.dataSource = cellItems;
            [sectionItems addObject:sectionItem];
            if (i == 1) {
                cellItems = [NSMutableArray array];
            }
        }
    }
    
    DTCellItem *replacePhotoItem = [NSClassFromString(@"DTCellItem") cellItemForDefaultStyleWithIcon:nil title:@"替换打卡拍照图片" detail:nil comment:self.punchConfig.replacePhoto?@"已设置":@"未设置" showIndicator:YES cellDidSelectedBlock:^{
        LLReplacePhotoSettingController *replacePhotoVC = [[%c(LLReplacePhotoSettingController) alloc] init];
        replacePhotoVC.isOpenReplacePhoto = self.punchConfig.isOpenAutoReplacePhoto;
        replacePhotoVC.replacePhoto = self.punchConfig.replacePhoto;
        replacePhotoVC.replacePhotoCallback = ^(BOOL isOpenReplacePhoto,UIImage *replaceImage){
            self.punchConfig.isOpenAutoReplacePhoto = isOpenReplacePhoto;
            self.punchConfig.replacePhoto = replaceImage;
            //刷新页面
            [self tidyDataSource];
        };
        [self.navigationController pushViewController:replacePhotoVC animated:YES];
    }];
    DTSectionItem *replacePhotoSection = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:nil];
    replacePhotoSection.dataSource = @[replacePhotoItem];
    [sectionItems addObject:replacePhotoSection];

    DTCellItem *locationCellItem = [NSClassFromString(@"DTCellItem") cellItemForTitleOnlyStyleWithTitle:@"开始定位" cellDidSelectedBlock:^{
        if(![[LLPunchManager shared] isLocationAuth]){
            [[LLPunchManager shared] showMessage:@"请先打开钉钉定位权限" completion:^(BOOL isClickConfirm){
                if(isClickConfirm){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            return;
        }
        [self.locationManager startUpdatingLocation];
    }];
    DTCellItem *wifiCellItem = [NSClassFromString(@"DTCellItem") cellItemForTitleOnlyStyleWithTitle:@"开始识别Wi-Fi" cellDidSelectedBlock:^{
        NSDictionary *ssidInfoDic = [[LLPunchManager shared] SSIDInfo];
        NSString *wifiName = ssidInfoDic[@"SSID"];
        NSString *wifiMac = ssidInfoDic[@"BSSID"];
        if (!wifiName.length || !wifiMac){
            [[LLPunchManager shared] showMessage:@"请先连接打卡WI-FI" completion:^(BOOL isClickConfirm){
                if(isClickConfirm){
                    //跳转到系统wifi列表
                    [[LLPunchManager shared] jumpToWifiList];
                }
            }];
            return;
        }
        self.punchConfig.wifiName = wifiName;
        self.punchConfig.wifiMacIp = wifiMac;
        //刷新页面
        [self tidyDataSource];
    }];
    DTSectionItem *recognizeSectionItem = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:nil];
    recognizeSectionItem.dataSource = @[locationCellItem,wifiCellItem];
    [sectionItems addObject:recognizeSectionItem];

    DTCellItem *addToCollectItem = [NSClassFromString(@"DTCellItem") cellItemForTitleOnlyStyleWithTitle:@"收藏配置" cellDidSelectedBlock:^{
        if(isEmptyStr(self.punchConfig.configAlias)){
            self.punchConfig.configAlias = [[NSDate date] description];
        }
        [[LLPunchManager shared] saveUserSetting:self.punchConfig];
    }];
    DTCellItem *saveCellItem = [NSClassFromString(@"DTCellItem")cellItemForTitleOnlyStyleWithTitle:@"保存" cellDidSelectedBlock:^{
        [LLPunchManager shared].punchConfig = self.punchConfig;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    DTSectionItem *saveSectionItem = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:nil];
    saveSectionItem.dataSource = @[addToCollectItem,saveCellItem];
    [sectionItems addObject:saveSectionItem];
    
    DTTableViewDataSource *dataSource = [[NSClassFromString(@"DTTableViewDataSource") alloc] init];
    dataSource.tableViewDataSource = sectionItems;
    self.dataSource = dataSource;

    [self.tableView reloadData];
}

%new
- (void)amapLocationManager:(AMapLocationManager *)arg1 didUpdateLocation:(id)arg2 reGeocode:(id)arg3{
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = (CLLocation *)arg2;
    self.punchConfig.latitude  = [NSString stringWithFormat:@"%@",@(location.coordinate.latitude)];
    self.punchConfig.longitude = [NSString stringWithFormat:@"%@",@(location.coordinate.longitude)];
    self.punchConfig.accuracy  = [NSString stringWithFormat:@"%@",@(fmax(location.horizontalAccuracy,location.verticalAccuracy))];
    //刷新页面
    [self tidyDataSource];
}

%end