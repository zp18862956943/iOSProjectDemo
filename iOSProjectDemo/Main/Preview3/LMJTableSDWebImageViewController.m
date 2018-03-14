//
//  LMJTableSDWebImageViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJTableSDWebImageViewController.h"
#import "VIDMoviePlayerViewController.h"
#import "LMJXGMVideo.h"

@interface LMJTableSDWebImageViewController ()
/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<LMJXGMVideo *> *videos;
@end

@implementation LMJTableSDWebImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)loadMore:(BOOL)isMore
{
    LMJWeakSelf(self);
    
    NSDictionary *parameters = @{@"type" : @"JSON"};
    
    [[LMJRequestManager sharedManager] GET:[LMJXMGBaseUrl stringByAppendingPathComponent:@"video"] parameters:parameters completion:^(LMJBaseResponse *response) {
        
        [weakself endHeaderFooterRefreshing];
        
        
        if (!response.error && response.responseObject) {
            weakself.videos = [LMJXGMVideo mj_objectArrayWithKeyValuesArray:response.responseObject[@"videos"]];
        } else {
            [weakself.tableView configBlankPage:LMJEasyBlankPageViewTypeNoData hasData:weakself.videos.count hasError:response.error reloadButtonBlock:^(id sender) {
                [weakself.tableView.mj_header beginRefreshing];
            }];
            [weakself.view makeToast:response.errorMsg];
            return ;
        }
        
        [weakself.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        [weakself.tableView reloadData];
    }];
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.imageView.lmj_size = CGSizeMake(80, 80);
    }
    
    [cell.imageView sd_setImageWithURL:self.videos[indexPath.row].image placeholderImage:[UIImage imageNamed:@"public_empty_loading"]];
    
    cell.textLabel.text = self.videos[indexPath.row].ID;
    
    cell.detailTextLabel.text = self.videos[indexPath.row].name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VIDMoviePlayerViewController *playerVc = [[VIDMoviePlayerViewController alloc] init];
    playerVc.videoURL = self.videos[indexPath.row].url.absoluteString;
    
    [self.navigationController pushViewController:playerVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSMutableArray<LMJXGMVideo *> *)videos
{
    if(!_videos)
    {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
