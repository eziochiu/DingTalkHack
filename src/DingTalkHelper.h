//
//  DingTalkHelper.h
//  test2
//
//  Created by fqb on 2017/12/21.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface UIBarButtonItem (Factory)

+ (id)customBarButtonItemWithBgImage:(id)arg1 title:(id)arg2 target:(id)arg3 action:(SEL)arg4 color:(id)arg5;
+ (id)customBarButtonItemWithImage:(id)arg1 highImage:(id)arg2 target:(id)arg3 action:(SEL)arg4;
+ (id)customBarButtonItemWithImage:(id)arg1 target:(id)arg2 action:(SEL)arg3;
+ (id)customBarButtonItemWithIconFontConf:(id)arg1 target:(id)arg2 action:(SEL)arg3 badgeView:(id)arg4;
+ (id)customBarButtonItemWithIconFontConf:(id)arg1 target:(id)arg2 action:(SEL)arg3;
+ (id)customBarButtonItemWithIconFont:(long long)arg1 target:(id)arg2 action:(SEL)arg3 badgeView:(id)arg4;
+ (id)customBarButtonItemWithIconFont:(long long)arg1 target:(id)arg2 action:(SEL)arg3 color:(id)arg4;
+ (id)customBarButtonItemWithIconFont:(long long)arg1 target:(id)arg2 action:(SEL)arg3;
+ (id)barButtonItemWithTitle:(id)arg1 tappedCallback:(id)arg2;
+ (id)barButtonItemWithTitle:(id)arg1 target:(id)arg2 action:(SEL)arg3 color:(id)arg4 badge:(id)arg5;
+ (id)barButtonItemWithTitle:(id)arg1 target:(id)arg2 action:(SEL)arg3 badge:(id)arg4;
+ (id)barButtonItemWithTitle:(id)arg1 target:(id)arg2 action:(SEL)arg3 color:(id)arg4;
+ (id)barButtonItemWithTitle:(id)arg1 target:(id)arg2 action:(SEL)arg3;
+ (void)dt_updateBackButton:(id)arg1 withTitle:(id)arg2 color:(id)arg3;
+ (id)backBarButtonItemWithTitle:(id)arg1 tintColor:(id)arg2 target:(id)arg3 action:(SEL)arg4;
+ (id)backBarButtonItemWithTitle:(id)arg1 target:(id)arg2 action:(SEL)arg3;

@end

@interface DTCell : UITableViewCell

@end

@interface DTBaseCellItem : NSObject

@property(nonatomic) double cellHeight; // @synthesize cellHeight=_cellHeight;
@property(nonatomic) long long editingStyle; // @synthesize editingStyle=_editingStyle;
@property(nonatomic) _Bool canEdit; // @synthesize canEdit=_canEdit;
@property(copy, nonatomic) void (^commitEditingBlock)(DTBaseCellItem *cellItem,DTCell *cell);


@end

@interface DTCellItem : DTBaseCellItem

@property(nonatomic) _Bool isSwitcherOn; // @synthesize isSwitcherOn=_isSwitcherOn;
@property(copy, nonatomic) NSString *textFieldText; // @synthesize textFieldText=_textFieldText;

+ (id)itemWithStyle:(unsigned long long)arg1 cellDidSelectBlock:(id)arg2;
+ (id)cellItemForSelectedStyleWithIcon:(id)arg1 title:(id)arg2 isSelected:(_Bool)arg3 selectedType:(unsigned long long)arg4 cellDidSelectedBlock:(id)arg5;
+ (id)cellItemForTitleOnlyStyleWithTitle:(id)arg1 cellDidSelectedBlock:(id)arg2;
+ (id)cellItemForEditStyleWithTitle:(id)arg1 textFieldHint:(id)arg2 textFieldLimt:(long long)arg3 textFieldHelpBtnNormalImage:(id)arg4 textFieldHelpBtnHighLightImage:(id)arg5 textFieldDidChangeEditingBlock:(id)arg6;
+ (id)cellItemForSwitcherStyleWithTitle:(id)arg1 isSwitcherOn:(_Bool)arg2 switcherValueDidChangeBlock:(id)arg3;
+ (id)cellItemFOrDefaultStyleWithIcon:(id)arg1 title:(id)arg2 titleFont:(id)arg3 detail:(id)arg4 detailFont:(id)arg5 numberOfDetailLine:(long long)arg6 cellDidSelectedBlock:(id)arg7;
+ (id)cellItemForDefaultStyleWithIcon:(id)arg1 title:(id)arg2 image:(id)arg3 showIndicator:(_Bool)arg4 cellDidSelectedBlock:(id)arg5;
+ (id)cellItemForDefaultStyleWithIcon:(id)arg1 title:(id)arg2 detail:(id)arg3 comment:(id)arg4 showBadge:(_Bool)arg5 showIndicator:(_Bool)arg6 cellDidSelectedBlock:(id)arg7;
+ (id)cellItemForDefaultStyleWithIcon:(id)arg1 title:(id)arg2 detail:(id)arg3 comment:(id)arg4 showIndicator:(_Bool)arg5 cellDidSelectedBlock:(id)arg6;
+ (id)cellItemForDefaultStyleWithIcon:(id)arg1 title:(id)arg2 comment:(id)arg3 image:(id)arg4 showIndicator:(_Bool)arg5 cellDidSelectedBlock:(id)arg6;

@end

@interface DTSectionItem : NSObject

@property(copy, nonatomic) id sectionFooterClickBlock; // @synthesize sectionFooterClickBlock=_sectionFooterClickBlock;
@property(copy, nonatomic) id sectionHeaderClickBlock; // @synthesize sectionHeaderClickBlock=_sectionHeaderClickBlock;
@property(copy, nonatomic) NSArray *dataSource; // @synthesize dataSource=_dataSource;

+ (id)itemWithSectionHeader:(NSString *)arg1 sectionFooter:(NSString *)arg2;

@end

@interface DTTableViewDataSource : NSObject

@property(copy, nonatomic) NSArray *tableViewIndexDataSource; // @synthesize tableViewIndexDataSource=_tableViewIndexDataSource;
@property(copy, nonatomic) NSArray *tableViewDataSource; // @synthesize tableViewDataSource=_tableViewDataSource;
- (id)indexTitleAtIndex:(unsigned long long)arg1;
- (id)mutableTableViewIndexDataSource;
- (id)cellItemForSectionIndex:(unsigned long long)arg1 atItemIndex:(unsigned long long)arg2;
- (id)sectionAtIndex:(unsigned long long)arg1;
- (id)mutableTableViewDataSource;

@end

@interface DTTableViewHandler : NSObject

@property(retain, nonatomic) DTTableViewDataSource *dataSource; // @synthesize dataSource=_dataSource;
@property(nonatomic,weak) id delegate; // @synthesize delegate=_delegate;

@end

@interface DTTableViewController : UIViewController

@property(retain, nonatomic) DTTableViewHandler *tableViewHandler; // @synthesize
@property(retain, nonatomic) UITableView *tableView; // @synthesize tableView=_tableView;
@property(retain, nonatomic) DTTableViewDataSource *dataSource;

@end

@interface DTSettingListViewController : DTTableViewController

@end

@interface LLSettingController : DTTableViewController

- (void)setNavigationBar;
- (void)tidyDataSource;

@end

@class LLPunchConfig,AMapLocationManager;

@interface LLPunchSettingController : DTTableViewController

@property (nonatomic, retain) AMapLocationManager *locationManager;
@property (nonatomic, retain) LLPunchConfig *punchConfig;

- (void)setNavigationBar;
- (void)tidyDataSource;

@end

@interface AMapLocationReGeocode : NSObject

@end

@protocol AMapLocationManagerDelegate <NSObject>

- (void)amapLocationManager:(AMapLocationManager *)arg1 didUpdateLocation:(CLLocation *)arg2 reGeocode:(AMapLocationReGeocode *)arg3;
- (void)amapLocationManager:(AMapLocationManager *)arg1 didUpdateLocation:(CLLocation *)arg2;
- (void)amapLocationManager:(AMapLocationManager *)arg1 didFailWithError:(NSError *)arg2;

@end

@interface AMapLocationManager : NSObject

@property(nonatomic, weak) id <AMapLocationManagerDelegate> delegate; // @synthesize delegate=_delegate;
@property(retain, nonatomic) CLLocationManager *locationManager; // @synthesize locationManager=_locationManager;
@property(nonatomic) double desiredAccuracy;
@property(nonatomic) double distanceFilter;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (void)locationManager:(id)arg1 didUpdateLocations:(id)arg2;
- (void)locationManager:(id)arg1 didFailWithError:(id)arg2;

@end

@interface DTUmidManager : NSObject
+ (NSString *)encrypIsSimulatorString;
@end 

@interface SecurityGuardStaticDataEncrypt : NSObject

- (id)staticSafeEncrypt:(long long)arg1 forKey:(id)arg2 forNeedProcessValue:(id)arg3;

@end

@interface SecurityGuardManager: NSObject
+ (id)getInstance;
- (SecurityGuardStaticDataEncrypt *)getStaticDataEncryptComp;

@end

typedef void(^RefreshSettingBlock)(void);

@interface LLCollectConfigController: DTTableViewController

@property (nonatomic, copy) RefreshSettingBlock refreshSettingBlock;

- (void)setNavigationBar;
- (void)tidyDataSource;
- (void)exchangeMethod;

@end

@interface DTWebViewController : UIViewController

+ (id)createPageViewControllerWithString:(id)arg1 relativeToURL:(id)arg2;

@end

@interface UIImageView (SDWebImage)

- (void)sd_setImageWithURL:(NSURL *)url;

@end

typedef void(^ReplacePhotoCallback)(BOOL isOpenReplacePhoto,UIImage *replacePhoto);

@interface LLReplacePhotoSettingController : DTTableViewController

@property (nonatomic, assign) BOOL isOpenReplacePhoto;
@property (nonatomic, retain) UIImage *replacePhoto;

@property (nonatomic, copy) ReplacePhotoCallback replacePhotoCallback;

- (void)setNavigationBar;
- (void)tidyDataSource;

@end
