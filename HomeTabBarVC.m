//
//  HomeTabBarVC.m
//  CreditRisk
//
//  Created by 刘锐 on 2018/2/2.
//  Copyright © 2018年 刘锐. All rights reserved.
//

#import "HomeTabBarVC.h"
#import "MainWebVC.h"
#import "ACMacros.h"
#import "UIColor+HexString.h"
#import "AppDelegate.h"
#import "CommonCore.h"
#import <SDWebImage/SDWebImageManager.h>
#import <YYModel/YYModel.h>
#import "PageVC.h"
#import "NACViewController.h"
#import "CommonCore.h"
#import "UIImageView+WebCache.h"
#import <Masonry/Masonry.h>
#import "BarBtn.h"
@interface HomeTabBarVC ()

@end

@implementation HomeTabBarVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (UIView *view in self.tabBar.subviews) {
        [view removeFromSuperview];
    }
     [self.tabBar addSubview:_tabbarView];
}


- (void)pushProductVC
{
    self.selectedIndex = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    [self.navigationItem setHidesBackButton:YES];
    
    [self.adImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(APPDELEGATE.window.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(APPDELEGATE.window);
        }
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.adImageV.mas_right).offset(-SizeFrom750(80));
        make.top.equalTo(@0);
        make.width.equalTo(@35);
        make.height.equalTo(@10);
    }];
    [self setupAllViewControllerNormal];
   
    
    self.tabBar.translucent = NO;
    _tabbarView = [[UIView alloc]initWithFrame:RECT(0, 0, Main_Screen_Width, 49)];


    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
    lineView.backgroundColor = [UIColor blackColor];
    [_tabbarView addSubview:lineView];
    for (NSInteger i = 0; i < APPDELEGATE.webInfo.data.count; i++) {
        WebInfoBarModel * model = APPDELEGATE.webInfo.data[i];
        BarBtn * btn  = [[BarBtn alloc]initWithFrame:CGRectMake(i* Main_Screen_Width /APPDELEGATE.webInfo.data.count, 0, Main_Screen_Width/APPDELEGATE.webInfo.data.count, 49)];
        [btn setImage:[self imageFromSdcache:[model.barIconUrlUnselect stringByReplacingOccurrencesOfString:@".png" withString:@"@3x.png"]] forState:UIControlStateNormal];
        [btn setImage:[self imageFromSdcache:[model.barIconUrlSelected stringByReplacingOccurrencesOfString:@".png" withString:@"@3x.png"]] forState:UIControlStateSelected];
        [btn setTitle:model.barName forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor HexStringColor:model.barFontColorUnselect] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor HexStringColor:model.barFontColorSelected] forState:UIControlStateSelected];
        [_tabbarView addSubview:btn];
        [btn addTarget:self action:@selector(barSelect:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0)
        {
            btn.selected = YES;
        }
        btn.tag = i;
    };

}

- (void)barSelect:(UIButton*)sender
{
    sender.selected = YES;
    for (NSInteger i = 0; i < _tabbarView.subviews.count; i++) {

        if (_tabbarView.subviews[i] != sender) {
            if ([_tabbarView.subviews[i] isKindOfClass:[BarBtn class]])
            {
                BarBtn * btn = _tabbarView.subviews[i];
                 btn.selected = NO;
            }
        }
    }
    self.selectedIndex = sender.tag;
}

- (void)setType:(WebVCType)type
{
    if (type == WebVCAD)
    {
        UINavigationController * pvc = [self.viewControllers objectAtIndex:0];
        MainWebVC *bvc = InitObject(MainWebVC);
        ADModel * adm = APPDELEGATE.appInfo.startAd.firstObject;
        bvc.url = adm.pageUrl;
        if (adm.pageUrl != nil) {
            bvc.hidesBottomBarWhenPushed = YES;
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem = item;
            [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
            [pvc pushViewController:bvc animated:YES];
        }
    }
}

- (void)setupAllViewControllerNormal
{
    if (!APPDELEGATE.webInfo)
    {
        APPDELEGATE.webInfo = [WebInfoModel yy_modelWithJSON:[CommonCore objForKey:@"webInfo"]];
    }
    
    
    for (WebInfoBarModel * model in APPDELEGATE.webInfo.data) {
        
        if(model.barTagList.count > 0)
        {
            WebInfoBarSubModel * subM = model.barTagList[0];
            PageVC * nvc = InitObject(PageVC);
            nvc.model = model;
            nvc.selectIndex = 0;
            nvc.menuViewStyle = WMMenuViewStyleLine;
            nvc.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
            nvc.menuItemWidth = (Main_Screen_Width - 50)/model.barTagList.count;
            nvc.progressWidth = SizeFrom750(60);
            nvc.titleSizeSelected = SizeFrom750(30);
            nvc.titleColorNormal = [UIColor HexStringColor:subM.tagFontColorUnselect];
            nvc.menuViewContentMargin = 0;
            nvc.titleColorSelected = [UIColor HexStringColor:subM.tagFontColorSelected];
            nvc.itemMargin = 0;
            
            UIImage * unselect = [self imageFromSdcache:[model.barIconUrlUnselect stringByReplacingOccurrencesOfString:@".png" withString:@"@3x.png"]];
            UIImage * select = [[self imageFromSdcache:[model.barIconUrlSelected stringByReplacingOccurrencesOfString:@".png" withString:@"@3x.png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            nvc.title = model.barPageTitle;
//            UIImage * unselect = [self imageFromSdcache:model.barIconUrlUnselect];
//            UIImage * select = [[self imageFromSdcache:model.barIconUrlSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [self setUpOneChildViewController:nvc image:unselect selectedImage:select title:model.barPageTitle];
            if ([model.iconMarkStatus boolValue])
            {
                if([model.iconMarkType integerValue] == 2)
                {
                    nvc.tabBarItem.badgeValue = model.iconMarkValue;
                }
                else
                {
                    nvc.tabBarItem.badgeValue = @"";
                }
            }
        }
        else
        {
            MainWebVC * nvc = InitObject(MainWebVC);
            nvc.url = model.barPageUrl;
            nvc.title = model.barPageTitle;
            nvc.needLoad = YES;
            UIImage * unselect = [self imageFromSdcache:[model.barIconUrlUnselect stringByReplacingOccurrencesOfString:@".png" withString:@"@3x.png"]];
            UIImage * select = [[self imageFromSdcache:[model.barIconUrlSelected stringByReplacingOccurrencesOfString:@".png" withString:@"@3x.png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            nvc.title = model.barPageTitle;
//            UIImage * unselect = [self imageFromSdcache:model.barIconUrlUnselect];
//            UIImage * select = [[self imageFromSdcache:model.barIconUrlSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [self setUpOneChildViewController:nvc image:unselect selectedImage:select title:model.barName];
            if ([model.iconMarkStatus boolValue])
            {
                if([model.iconMarkType integerValue] == 2)
                {
                    nvc.tabBarItem.badgeValue = model.iconMarkValue;
                }
                else
                {
                    nvc.tabBarItem.badgeValue = @"";
                }
            }
        }
    }
}


#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
//    WebInfoBarModel * one = [APPDELEGATE.webInfo.data objectAtIndex:0];
//    vc.title = one.barPageTitle;
    
//    vc.tabBarItem.image = image;
//    vc.tabBarItem.title = @"";
//    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor HexStringColor:one.barFontColorUnselect],NSFontAttributeName:[UIFont systemFontOfSize:SizeFrom750(22)]} forState:UIControlStateNormal];
//    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor HexStringColor:one.barFontColorSelected],NSFontAttributeName:[UIFont systemFontOfSize:SizeFrom750(22)]} forState:UIControlStateSelected];
//
//    vc.tabBarItem.selectedImage = selectedImage;
//
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //    [nav.navigationBar setBarTintColor:RGBCOLOR(226, 57, 35)];
    [self addChildViewController:nav];
}






-(UIImage*)imageFromSdcache:(NSString*)url{
    
    __block NSData * imageData =nil;
    
    NSString*cacheImageKey = [[SDWebImageManager sharedManager]cacheKeyForURL:[NSURL URLWithString:url]];
    
    if(cacheImageKey.length) {

        NSString*cacheImagePath = [[SDImageCache sharedImageCache]defaultCachePathForKey:cacheImageKey];

        if(cacheImagePath.length) {
            imageData = [NSData dataWithContentsOfFile:cacheImagePath];
        }

    }
    if(!imageData) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    }
    
    UIImage*image = [UIImage imageWithData:imageData];
    return image;
}





- (UIImageView*)adImageV{
    if (_adImageV) {
        UIImageView * v = InitObject(UIImageView);
        v.backgroundColor = [UIColor whiteColor];
        [v sd_setImageWithURL:[NSURL URLWithString:[CommonCore objForKey:@"adUrl"]] placeholderImage:IMAGEBYENAME(@"def.jpeg")];
        [APPDELEGATE.window addSubview:v];
        self.adImageV = v;
    }
    return _adImageV;
}

- (UIButton*)closeBtn
{
    if (_closeBtn) {
        UIButton * v = InitObject(UIButton);
        [v setTitle:@"X" forState:UIControlStateNormal];
        ViewBorderRadius(v, self.closeBtn.frame.size.width/2, 1, [UIColor blackColor]);
        [v setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.adImageV addSubview:v];
        [v addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.closeBtn = v;
    }
    return _closeBtn;
}
- (void)closeBtnClick{
    [UIView animateWithDuration:0.5 animations:^{
        self.adImageV.alpha = 0;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.adImageV.alpha != 0)
    {
        NSLog(@"广告");
    }
}
@end
