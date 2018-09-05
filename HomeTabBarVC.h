//
//  HomeTabBarVC.h
//  CreditRisk
//
//  Created by 刘锐 on 2018/2/2.
//  Copyright © 2018年 刘锐. All rights reserved.
//
typedef enum : int{
    WebVCAD = 1,
}WebVCType;
#import <UIKit/UIKit.h>

@interface HomeTabBarVC : UITabBarController
@property (nonatomic, assign) WebVCType type;
@property (nonatomic, strong) UIImageView * adImageV;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UIView * tabbarView;

@end
