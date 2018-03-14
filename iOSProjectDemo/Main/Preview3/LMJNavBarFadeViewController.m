//
//  LMJNavBarFadeViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJNavBarFadeViewController.h"
#import "LMJExpandHeader.h"

@interface LMJNavBarFadeViewController ()
/** <#digest#> */
@property (nonatomic, strong) LMJExpandHeader *expandHander;
@end

@implementation LMJNavBarFadeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top = 0;
    self.tableView.contentInset = contentInset;
    
    UIImageView *imageView = [[LMJExpandImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    
    imageView.lmj_height = 128;
    imageView.lmj_width = kScreenWidth;
    
   _expandHander = [LMJExpandHeader expandWithScrollView:self.tableView expandView:imageView];
    
    // 不透明
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行", indexPath.row];
    
    
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat kNavBarHeight = -self.lmj_navgationBar.height;
    
    CGPoint contentOffset = scrollView.contentOffset;
    
    UIButton *leftBtn = (UIButton *)self.lmj_navgationBar.leftView;
    UIButton *rightBtn = (UIButton *)self.lmj_navgationBar.rightView;
    
    NSLog(@"%@", NSStringFromCGPoint(contentOffset));
    
    if (contentOffset.y <= kNavBarHeight) {
        
        self.lmj_navgationBar.title = [self changeTitle:@"我的" color:[UIColor redColor]];
        
        leftBtn.selected = NO;
        rightBtn.selected = NO;
        
        self.lmj_navgationBar.backgroundColor = [UIColor clearColor];
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
    }else if (contentOffset.y > kNavBarHeight && contentOffset.y < 0)
    {
        self.lmj_navgationBar.title = [self changeTitle:@"我的" color:[UIColor redColor]];
        leftBtn.selected = NO;
        rightBtn.selected = NO;
        
        self.lmj_navgationBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:(1 - contentOffset.y / kNavBarHeight)];
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
    }else if (contentOffset.y >= 0)
    {
        self.lmj_navgationBar.title = [self changeTitle:@"我的" color:[UIColor greenColor]];
        leftBtn.selected = YES;
        rightBtn.selected = YES;
        self.lmj_navgationBar.backgroundColor = [UIColor whiteColor];
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

- (UIStatusBarStyle)navUIBaseViewControllerPreferStatusBarStyle:(LMJNavUIBaseViewController *)navUIBaseViewController
{
    return UIStatusBarStyleLightContent;
}

/**头部标题*/
- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:self.navigationItem.title ?: self.title color:[UIColor redColor]];
}


/** 背景色 */
- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [UIColor clearColor];
}

/** 是否隐藏底部黑线 */
- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
{
    return YES;
}


/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{

//    tabBar_new_click_icon
    
    [leftButton setImage:[UIImage imageNamed:@"tabBar_new_click_icon"] forState:UIControlStateSelected];
    
    return [UIImage imageNamed:@"tabBar_new_icon"];
}
/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
//    mine-setting-icon
    
    [rightButton setImage:[UIImage imageNamed:@"mine-setting-icon"] forState:UIControlStateSelected];
    
    return [UIImage imageNamed:@"mine-setting-icon-click"];
}



#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
}
/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
}


#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle color:(UIColor *)color
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];

    [title addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, title.length)];

    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, title.length)];

    return title;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] postNotificationName:LMJTableViewControllerDeallocNotification object:self];
}

@end
