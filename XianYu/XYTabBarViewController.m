//
//  ViewController.m
//  XianYu
//
//  Created by YuanZhihao on 6/14/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYTabBarViewController.h"
#import "XYTabBar.h"
#import "UIImage+Image.h"
#import "XYHomeViewController.h"
#import "XYNavigationViewController.h"
#import "UIView+LBExtension.h"
#import "XYFishViewController.h"
#import "XYMessageViewController.h"
#import "XYMineViewController.h"
#import "XYPhotoPickerViewController.h"

#define LBMagin 10

@interface XYTabBarViewController () <XYTabBarDelegate,UITabBarControllerDelegate>

/// 点击发布按钮时的透明背景
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIButton *publishButton;

@property (nonatomic, weak) UIButton *takePhotoButton;

@property (nonatomic, weak) UIButton *albumButton;

@end

@implementation XYTabBarViewController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize
{
    //规定UiTabBarItem的样式
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    //设置常规状态下UiTabBarItem的样式
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    //设置被选中时UiTabBarItem的样式
    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0.0f;
    
    //设置代理，响应点击tab的事件
    self.delegate = self;
    
    //配置每个tab的rootviewcontroller
    [self setUpAllChildVc];
    
    //新建自定义TabBar
    XYTabBar *tabbar = [[XYTabBar alloc] init];
    //设置代理，响应发布按钮点击事件
    tabbar.myDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
    self.publishButton = [[UIButton alloc] init];
    [self.publishButton setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
    [self.publishButton setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateHighlighted];
    [self.publishButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.publishButton.size = CGSizeMake(self.publishButton.currentBackgroundImage.size.width, self.publishButton.currentBackgroundImage.size.height);
    self.publishButton.centerX = self.view.centerX;
    self.publishButton.centerY = tabbar.height * 0.5 - 2 * LBMagin + CGRectGetMinY(tabbar.frame);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击发布按钮的代理方法
- (void)publishButtonClicked:(XYTabBar *)tabBar
{
    /*XYPublishViewController *publishVC = [[XYPublishViewController alloc] init];
    //修改发布界面的显示模式，使该界面能够透明
    publishVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:publishVC animated:YES completion:nil];*/
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    /// 在发布按钮下方插入背景视图
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.publishButton];
    [self.view bringSubviewToFront:self.publishButton];
    
    [UIView animateWithDuration:0.0618f * 3 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        _backgroundView.alpha = 0.85f;
    } completion:nil];
    
    [UIView animateWithDuration:0.1575f animations:^{
        self.publishButton.transform = CGAffineTransformMakeRotation(-0.75f * M_PI);
    }];
    
    UIButton *takePhotoButton = [[UIButton alloc]init];
    takePhotoButton.frame = self.publishButton.frame;
    takePhotoButton.transform = CGAffineTransformMakeTranslation(1, 1);
    [takePhotoButton setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
    [takePhotoButton setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateSelected];
    [takePhotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    self.takePhotoButton = takePhotoButton;
    
    UIButton *albumButton = [[UIButton alloc]init];
    albumButton.frame = self.publishButton.frame;
    albumButton.transform = CGAffineTransformMakeTranslation(1, 1);
    [albumButton setImage:[UIImage imageNamed:@"album"] forState:UIControlStateNormal];
    [albumButton setImage:[UIImage imageNamed:@"album"] forState:UIControlStateSelected];
    [albumButton addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
    self.albumButton = albumButton;
    
    UILabel *photo = [[UILabel alloc] init];
    photo.text = @"拍照";
    photo.font = [UIFont systemFontOfSize:11];
    photo.textColor = [UIColor whiteColor];
    [photo sizeToFit];
    
    UILabel *album = [[UILabel alloc] init];
    album.text = @"相册";
    album.font = [UIFont systemFontOfSize:11];
    album.textColor = [UIColor whiteColor];
    [album sizeToFit];
    
    [self.view insertSubview:takePhotoButton belowSubview:self.publishButton];
    
    [UIView animateWithDuration:0.15f animations:^{
        takePhotoButton.transform = CGAffineTransformRotate(takePhotoButton.transform, -M_PI);
        takePhotoButton.centerX = self.view.centerX * 0.5;
        takePhotoButton.centerY = CGRectGetMinY(self.publishButton.frame) - 80;
        takePhotoButton.transform = CGAffineTransformScale(takePhotoButton.transform, 1.25, 1.25);
    } completion:^(BOOL finished){
        photo.centerX = takePhotoButton.centerX;
        photo.centerY = CGRectGetMaxY(takePhotoButton.frame) + LBMagin;
        [self.backgroundView addSubview:photo];
        [self.view insertSubview:albumButton belowSubview:self.publishButton];
        [UIView animateWithDuration:0.15f animations:^{
            albumButton.transform = CGAffineTransformRotate(albumButton.transform, -M_PI);
            albumButton.centerX = self.view.centerX * 1.5;
            albumButton.centerY = CGRectGetMinY(self.publishButton.frame) - 80;
            albumButton.transform = CGAffineTransformScale(albumButton.transform, 1.25, 1.25);
        } completion:^(BOOL finished) {
            album.centerX = albumButton.centerX;
            album.centerY = CGRectGetMaxY(albumButton.frame) + LBMagin;
            [self.backgroundView addSubview:album];
        }];
    }];
}

- (void)cancelButtonClicked {
    for (UIView *subView in self.backgroundView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            NSLog(@"label");
            [subView setHidden:YES];
            [subView removeFromSuperview];
        }
    }
    [UIView animateWithDuration:0.15f animations:^{
        _takePhotoButton.transform = CGAffineTransformMakeRotation(M_PI);
        _takePhotoButton.center = self.publishButton.center;
        _takePhotoButton.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.15f animations:^{
            _albumButton.transform = CGAffineTransformMakeRotation(M_PI);
            _albumButton.center = self.publishButton.center;
            _albumButton.transform = CGAffineTransformMakeScale(0.5, 0.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1575f animations:^{
                self.publishButton.transform = CGAffineTransformMakeRotation(-0.25f * M_PI);
            } completion:^(BOOL finished) {
                [_takePhotoButton removeFromSuperview];
                [_albumButton removeFromSuperview];
                
                [self.backgroundView removeFromSuperview];
                [self.publishButton removeFromSuperview];
            }];
        }];
    }];
}

#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮

- (void)setUpAllChildVc
{
    XYHomeViewController *HomeVC = [[XYHomeViewController alloc] init];
    [self setUpOneChildVcWithVc:HomeVC Image:@"home_normal" selectedImage:@"home_highlight" title:@"首页"];
    
    XYFishViewController *FishVC = [[XYFishViewController alloc] init];
    [self setUpOneChildVcWithVc:FishVC Image:@"fish_normal" selectedImage:@"fish_highlight" title:@"鱼塘"];
    
    XYMessageViewController *MessageVC = [[XYMessageViewController alloc] init];
    [self setUpOneChildVcWithVc:MessageVC Image:@"message_normal" selectedImage:@"message_highlight" title:@"消息"];
    
    XYMineViewController *MineVC = [[XYMineViewController alloc] init];
    [self setUpOneChildVcWithVc:MineVC Image:@"account_normal" selectedImage:@"account_highlight" title:@"我的"];
}

#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    XYNavigationViewController *nav = [[XYNavigationViewController alloc] initWithRootViewController:Vc];
    
    nav.tag = title;
    
    Vc.view.backgroundColor = [self randomColor];
    
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    Vc.tabBarItem.selectedImage = mySelectedImage;
    
    Vc.tabBarItem.title = title;
    
    Vc.navigationItem.title = title;
    
    [self addChildViewController:nav];
}

- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

- (void)openAlbum {
    XYPhotoPickerViewController *picker = [XYPhotoPickerViewController new];
    [self presentViewController:picker animated:YES completion:nil];
    for (UIView *subView in self.backgroundView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            //[subView setHidden:YES];
            [subView removeFromSuperview];
        }
    }
    [_takePhotoButton removeFromSuperview];
    [_albumButton removeFromSuperview];
    
    [self.backgroundView removeFromSuperview];
    [self.publishButton removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self cancelButtonClicked];
}

- (void)takePhoto {
    
}

@end
