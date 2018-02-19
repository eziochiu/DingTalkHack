#import "DingTalkHelper.h"
#import "LLPunchConfig.h"
#import "LLPunchManager.h"
#import "LLImagePicker.h"

%hook VSWatermarkCameraViewController

//拍照打卡
- (void)takePictureWithImage:(id)image animated:(BOOL)animated{
    %orig([LLPunchManager shared].punchConfig.isOpenAutoReplacePhoto?[LLPunchManager shared].punchConfig.replacePhoto:image,animated);
}

//笑脸打卡
- (void)takePictureWithImage:(id)image orientation:(id)orientation animated:(BOOL)animated{
    %orig([LLPunchManager shared].punchConfig.isOpenAutoReplacePhoto?[LLPunchManager shared].punchConfig.replacePhoto:image,orientation,animated);
}

%end

%subclass LLReplacePhotoSettingController : DTTableViewController

%property (nonatomic, assign) BOOL isOpenReplacePhoto;
%property (nonatomic, retain) UIImage *replacePhoto;

%property (nonatomic, copy) ReplacePhotoCallback replacePhotoCallback;

- (void)viewDidLoad{
    %orig;

    [self setNavigationBar];
    [self tidyDataSource];
}

%new
- (void)setNavigationBar{
    self.title = @"替换照片设置";
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *confirmBarItem = [UIBarButtonItem barButtonItemWithTitle:@"确定" tappedCallback:^{
        //点击确定
        if(self.replacePhotoCallback){
            self.replacePhotoCallback(self.isOpenReplacePhoto,self.replacePhoto);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.rightBarButtonItem = confirmBarItem;
}

%new
- (void)tidyDataSource{
    DTCellItem *openReplacePhotoItem = [NSClassFromString(@"DTCellItem") cellItemForSwitcherStyleWithTitle:@"是否开启照片替换" isSwitcherOn:self.isOpenReplacePhoto switcherValueDidChangeBlock:^(DTCellItem *item,DTCell *cell,UISwitch *aSwitch){
        self.isOpenReplacePhoto = aSwitch.on;
    }];
    DTSectionItem *switchSectionItem = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:[NSString stringWithFormat:@"%@\n%@",@"配置好照片并且打卡开关即可替换打卡拍照",self.replacePhoto?@"点击图片可修改替换图片":@""]];
    switchSectionItem.dataSource = @[openReplacePhotoItem];

    DTTableViewDataSource *dataSource = [[NSClassFromString(@"DTTableViewDataSource") alloc] init];
    dataSource.tableViewDataSource = @[switchSectionItem];
    self.dataSource = dataSource;

    UIView *footerView = [UIView new];
    UIButton *addReplaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:addReplaceBtn];
    UIImage *addImg = self.replacePhoto?:[UIImage imageNamed:@"emotion_store_add"];
    if(addImg){
    	[addReplaceBtn setImage:addImg forState:UIControlStateNormal];
    } else {
    	[addReplaceBtn setTitle:@"点击设置替换照片" forState:UIControlStateNormal];
    }
    CGFloat screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat replaceBtnW = screenW*0.7f;
    CGFloat replaceBtnH = self.replacePhoto?replaceBtnW*addImg.size.height/addImg.size.width:80;
    addReplaceBtn.bounds = CGRectMake(0, 0, replaceBtnW,replaceBtnH);
    addReplaceBtn.center = CGPointMake(screenW/2.0f,replaceBtnH/2.0f);
    footerView.frame = addReplaceBtn.bounds;
    [addReplaceBtn addTarget:self action:@selector(addReplacePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView setTableFooterView:footerView];
    [self.tableView reloadData];
}

%new
- (void)addReplacePhoto{
	[[LLImagePicker shared] showWithCompletion:^(BOOL isSuccess,UIImage *originImg,UIImage *editedImg,LLReplacePhotoSettingController *controller){
        controller.replacePhoto = originImg;
        [controller tidyDataSource];
    } object:self allowsEditing:NO];
}

%end