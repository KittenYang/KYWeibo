//
//  BaseTableView.m
//  KittenYang
//
//  Created by Kitten Yang on 14-8-4.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BaseTableView.h"


@implementation BaseTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _initView];
    }
    return self;
}
//使用xib创建
- (void)awakeFromNib{
    [self _initView];
}


- (void)_initView{
    //顶部视图的位置
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    self.dataSource = self;
    self.delegate   = self;
    self.refreshHeader = YES;
    self.isMore = YES;
    
    //上拉刷新
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.backgroundColor = [UIColor clearColor];
    _moreButton.frame = CGRectMake(0, 0, ScreenWidth, 40);
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_moreButton setTitle:@"上拉加载更多" forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(UpToLoadMore) forControlEvents:UIControlEventTouchUpInside];
    
    UIActivityIndicatorView *indicationView =  [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicationView.frame = CGRectMake(100, 10, 20, 20);
    indicationView.tag = 2014;
    [indicationView stopAnimating];
    [_moreButton addSubview:indicationView];
    
    self.tableFooterView = _moreButton;
}


#pragma mark - 上拉加载更多
- (void)UpToLoadMore{
    if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
        [self.eventDelegate pullUp:self];
        _moreButton.enabled = NO;
        [_moreButton setTitle:@"正在加载" forState:UIControlStateNormal];
        UIActivityIndicatorView *indicat = (UIActivityIndicatorView *)[_moreButton viewWithTag:2014];
        [indicat startAnimating];
    }
}

- (void)stopLoadMore{
    if (self.data.count > 0) {
        _moreButton.hidden = NO;
        [_moreButton setTitle:@"上拉加载更多" forState:UIControlStateNormal];
        _moreButton.enabled = YES;
        UIActivityIndicatorView *ac = (UIActivityIndicatorView *)[_moreButton viewWithTag:2014];
        [ac stopAnimating];
        
        if (!self.isMore) {
            [_moreButton setTitle:@"加载完成" forState:UIControlStateNormal];
            _moreButton.enabled = NO;
        }
    }else{
        _moreButton.hidden = YES;
    }
}

#pragma mark - 复写reloadData
- (void)reloadData{
    [super reloadData];
    [self stopLoadMore];    
}

#pragma mark - 设置下拉头视图
- (void) setRefreshHeader:(BOOL)refreshHeader{
    _refreshHeader = refreshHeader;
    
    if (_refreshHeader) {
        [self addSubview:_refreshHeaderView];
    }else{
        if ([_refreshHeaderView superview]) {
            [_refreshHeaderView removeFromSuperview];
        }
    }
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.eventDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.eventDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - 下拉相关的方法

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

//停止加载，弹回下拉
- (void)doneLoadingTableViewData{
	
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
	
}

- (void) baseTableViewRefreshData{
    [_refreshHeaderView initLoading:self];
}


#pragma mark - UIScrollViewDelegate Methods
//滑动时，调用此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

//手指放开调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
    
    float contentOffset = scrollView.contentOffset.y; //contentOffset 偏移量:当前显示内容顶点相对于contentView顶点的偏移量
    float contentHeight = scrollView.contentSize.height; //内容大小的高度
    
    float sub = contentHeight - contentOffset; //所以，当滑到contentView的最低端时，内容的总高度减去偏移量就是当前显示内容的高度.继续拖动，只有scrollView.contentOffset.y 会增加，其他任何高度（scrollView.contentSize.height，scrollView.height）都不会变。因为当前显示内容变小，所以sub减小。
    if ((scrollView.height - sub) > 20) {
        [self UpToLoadMore];
        if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]){
            [self.eventDelegate pullUp:self];
        }
    }
    NSLog(@"%f",scrollView.height);
    
}



#pragma mark - EGORefreshTableHeaderDelegate Methods
//下拉到一定距离手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    if ([self.eventDelegate respondsToSelector:@selector(pullDown:)]) {
        [self.eventDelegate pullDown:self];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}



@end
