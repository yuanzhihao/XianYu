//
//  XYNavigationViewController.m
//  XianYu
//
//  Created by YuanZhihao on 6/14/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYNavigationViewController.h"
#import "UIImage+Image.h"

#define NavBarColor [UIColor colorWithRed:250/255.0 green:227/255.0 blue:111/255.0 alpha:1.0]

@interface XYNavigationViewController ()

@end

@implementation XYNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//第一次加载该类时，设置UiBarButtonItem和UINavigationBar的样式
+ (void)load
{
    Class class = NSClassFromString(@"XYNavigationViewController");
    
    UIBarButtonItem *item=[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:class]];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    dic[NSForegroundColorAttributeName]=[UIColor blackColor];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    [bar setBackgroundImage:[UIImage imageWithColor:NavBarColor] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *dicBar=[NSMutableDictionary dictionary];
    
    dicBar[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    [bar setTitleTextAttributes:dic];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //当导航控制器中的视图数大于0时，隐藏TabBar
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)viewDidLayoutSubviews {
    CGRect frame = self.toolbar.frame;
    frame.origin = CGPointMake(0, CGRectGetMaxY(self.navigationBar.frame));
    self.toolbar.frame = frame;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
