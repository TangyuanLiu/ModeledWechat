//
//  ListViewController.m
//  仿微信选择联系人列表
//
//  Created by yongda on 2017/12/27.
//  Copyright © 2017年 TangyuanLiu. All rights reserved.
//

#import "ListViewController.h"
#import "SelectMemberWithSearchView.h"
#import "SelectContactCell.h"
#import "YYModel.h"
#import "ConatctModel.h"
#import "DataHelper.h"

#define kGreenColor [UIColor colorWithRed:1/255.0 green:190/255.0 blue:86/255.0 alpha:1]

@interface ListViewController ()<UITableViewDelegate, UITableViewDataSource, SelectMemberWithSearchViewDelegate>
{
    NSArray *_rowArr;//row array
    NSArray *_sectionArr;//section array
}
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UITableView *indexTableView;
@property (nonatomic, strong) SelectMemberWithSearchView *searchView;
@property (nonatomic, strong) NSMutableArray<ConatctModel *> *contactArray;// 模拟数据
@property (nonatomic, strong) NSMutableArray *selectArray; // 选中的model数组
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *tipViewBtn;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) BOOL isScrollToShow;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择联系人列表";
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.selectIndex = 1;
    self.isScrollToShow = YES;
    NSArray *dataArray = @[
                           @{@"portrait":@"1",@"name":@"58"},
                           @{@"portrait":@"2",@"name":@"花无缺"},
                           @{@"portrait":@"3",@"name":@"东方不败"},
                           @{@"portrait":@"4",@"name":@"任我行"},
                           @{@"portrait":@"5",@"name":@"逍遥王"},
                           @{@"portrait":@"6",@"name":@"阿离"},
                           @{@"portrait":@"13",@"name":@"百草堂"},
                           @{@"portrait":@"8",@"name":@"三味书屋"},
                           @{@"portrait":@"9",@"name":@"彩彩"},
                           @{@"portrait":@"10",@"name":@"陈晨"},
                           @{@"portrait":@"11",@"name":@"多多"},
                           @{@"portrait":@"12",@"name":@"峨嵋山"},
                           @{@"portrait":@"7",@"name":@"哥哥"},
                           @{@"portrait":@"14",@"name":@"林俊杰"},
                           @{@"portrait":@"15",@"name":@"足球"},
                           @{@"portrait":@"16",@"name":@"赶集"},
                           @{@"portrait":@"17",@"name":@"搜房网"},
                           @{@"portrait":@"18",@"name":@"欧弟"}];

    for (NSDictionary *dic in dataArray) {
        ConatctModel *model = [ConatctModel yy_modelWithDictionary:dic];
        [self.contactArray addObject:model];
    }
    
    _rowArr = [DataHelper getContactListDataBy:self.contactArray];
    _sectionArr = [DataHelper getContactListSectionBy:[_rowArr mutableCopy]];
    
    [self setupBarButtonItems];
    [self setupSubViews];
}

#pragma mark -------- target/action --------
- (void)cancleAct {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmAct {
    
    NSMutableArray *nameArray = [NSMutableArray array];
    for (ConatctModel *model in self.selectArray) {
        [nameArray addObject:model.name];
    }
    
    NSString *message = [nameArray componentsJoinedByString:@","];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setupBarButtonItems {
    
    UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftBtn.frame = CGRectMake(0, 0, 60, 30);
    [leftBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [leftBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [leftBtn addTarget:self action:@selector(cancleAct) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [_rightBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [_rightBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
//    [_rightBtn addTarget:self action:@selector(confirmAct) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
}

- (void)setupSubViews {
    
    // 头部搜索view
    self.searchView = [[SelectMemberWithSearchView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 52)];
    _searchView.delegate = self;
    _searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchView];
    
    // 列表
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchView.frame)+0.5, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-52-64-0.5) style:(UITableViewStylePlain)];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.showsVerticalScrollIndicator = NO;
    _listTableView.backgroundColor = [UIColor whiteColor];
    _listTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_listTableView];
    [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectContactCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([SelectContactCell class])];
    
    // 索引
    self.indexTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 20, _sectionArr.count*20) style:(UITableViewStylePlain)];
    _indexTableView.center = CGPointMake([UIScreen mainScreen].bounds.size.width-20,self.view.center.y);
    _indexTableView.delegate = self;
    _indexTableView.dataSource = self;
    _indexTableView.scrollEnabled = NO;
    _indexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _indexTableView.showsVerticalScrollIndicator = NO;
    _indexTableView.backgroundColor = [UIColor clearColor];
    _indexTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_indexTableView];
    [_indexTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark -------- tableview --------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return tableView == _listTableView ? _sectionArr.count-1 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableView == _listTableView ? [_rowArr[section] count] : _sectionArr.count;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableView == _listTableView ? 52.0 : 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return tableView == _listTableView ? 30.0 : 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == _listTableView) {
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
        label.text = [_sectionArr objectAtIndex:section+1];
        label.textColor = [UIColor blackColor];
        [header addSubview:label];
        return header;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _listTableView) {
        ConatctModel *model = _rowArr[indexPath.section][indexPath.row];
        SelectContactCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectContactCell class]) forIndexPath:indexPath];
        cell.contactNameLabel.text = model.name;
        cell.contactAvatarImg.image = [UIImage imageNamed:model.portrait];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.selectArray containsObject:model]) {
            cell.selectedBtn.selected = YES;
            [cell.selectedBtn setImage:[UIImage imageNamed:@"circle_green"] forState:(UIControlStateSelected)];
        }else {
            cell.selectedBtn.selected = NO;
            [cell.selectedBtn setImage:[UIImage imageNamed:@"circle_empty"] forState:(UIControlStateSelected)];
        }
        
        return cell;
    }
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_search"]];
            img.center = cell.contentView.center;
            [cell.contentView addSubview:img];
            cell.textLabel.text = @"";
            cell.contentView.backgroundColor = [UIColor clearColor];
        }else {
            
            if (self.selectIndex == indexPath.row) {
                cell.contentView.backgroundColor = kGreenColor;
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.contentView.layer.cornerRadius = 10;
                cell.contentView.layer.masksToBounds = YES;
            }else {
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.textLabel.textColor = [UIColor blackColor];
            }
            
            cell.textLabel.text = _sectionArr[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _listTableView) {
        ConatctModel *model = _rowArr[indexPath.section][indexPath.row];
        SelectContactCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectedBtn.selected = !cell.selectedBtn.selected;
        if (cell.selectedBtn.selected == YES) {
            [cell.selectedBtn setImage:[UIImage imageNamed:@"circle_green"] forState:(UIControlStateSelected)];
            [self.selectArray addObject:model];
        }else {
            [cell.selectedBtn setImage:[UIImage imageNamed:@"circle_empty"] forState:(UIControlStateNormal)];
            [self.selectArray removeObject:model];
        }
        [self updateRightBarButtonItem];
        [self.searchView updateSubviewsLayout:self.selectArray];
    }else {
        if (indexPath.row != 0) {
            self.isScrollToShow = NO;
            self.selectIndex = indexPath.row;
            [_indexTableView reloadData];
            [_listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row-1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self showTipViewWithIndex:indexPath];
        }
    }
}

#pragma mark -------- privite method --------
- (void)updateRightBarButtonItem {
    
    if (self.selectArray.count > 0) {
        [_rightBtn setTitle:[NSString stringWithFormat:@"确定(%ld)",self.selectArray.count] forState:(UIControlStateNormal)];
        [_rightBtn setTitleColor:kGreenColor forState:(UIControlStateNormal)];
        [_rightBtn addTarget:self action:@selector(confirmAct) forControlEvents:(UIControlEventTouchUpInside)];
    }
    else {
        [_rightBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_rightBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    }
    
    [_rightBtn sizeToFit];
}


/**
 显示tipView
 */
- (void)showTipViewWithIndex:(NSIndexPath *)indexPath {

    CGFloat y = CGRectGetMinY(_indexTableView.frame) + indexPath.row*20;
    self.tipViewBtn.frame = CGRectMake(CGRectGetMinX(_indexTableView.frame)-70, y-12, 65, 50);
    [self.view addSubview:self.tipViewBtn];
    self.tipViewBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    NSString *title = _sectionArr[self.selectIndex];
    [self.tipViewBtn setTitle:title forState:(UIControlStateNormal)];
    [self performSelector:@selector(dismissTipViewBtn) withObject:nil afterDelay:0.5];
}

- (void)dismissTipViewBtn {
    
    [self.tipViewBtn removeFromSuperview];
}

#pragma mark -------- custome delegate --------
- (void)removeMemberFromSelectArray:(ConatctModel *)member indexPath:(NSIndexPath *)indexPath {
    
    [_contactArray enumerateObjectsUsingBlock:^(ConatctModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.name isEqualToString:member.name]) {
            [self.selectArray removeObject:obj];
            [_listTableView reloadData];
            [self updateRightBarButtonItem];
        }
    }];
}

#pragma mark --------   --------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.isScrollToShow) {
        // 获取当前屏幕可见范围的indexPath
        NSArray *visiblePaths = [_listTableView indexPathsForVisibleRows];
        
        if (visiblePaths.count < 1) {
            return;
        }
        
        NSIndexPath *indexPath0 = visiblePaths[0];

        // 判断是否已滑到最底部
        CGFloat height = scrollView.frame.size.height;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
        
        NSIndexPath *indexPath;
        if (bottomOffset <= height || fabs(bottomOffset - height) < 1) {
            //在最底部（显示最后一个索引字母）
            NSInteger row = _sectionArr.count-1;
            indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            self.selectIndex = indexPath.row;
        }else {
            indexPath = [NSIndexPath indexPathForRow:indexPath0.section inSection:0];
            self.selectIndex = indexPath.row+1;
        }
        
        [_indexTableView reloadData];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // 重置
    if (!self.isScrollToShow) {
        self.isScrollToShow = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 重置
    if (!self.isScrollToShow) {
        self.isScrollToShow = YES;
    }
}

#pragma mark -------- lazy init --------
- (NSMutableArray *)contactArray {
    
    if (!_contactArray) {
        _contactArray = [NSMutableArray array];
    }
    
    return _contactArray;
}

- (NSMutableArray *)selectArray {
    
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    
    return _selectArray;
}

- (UIButton *)tipViewBtn {
    
    if (!_tipViewBtn) {
        _tipViewBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _tipViewBtn.enabled = NO;
        [_tipViewBtn setBackgroundImage:[UIImage imageNamed:@"chat_letterbg"] forState:(UIControlStateNormal)];
        _tipViewBtn.titleLabel.textColor = [UIColor whiteColor];
        [_tipViewBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    }
    
    return _tipViewBtn;
}

- (void)dealloc {
    
    NSLog(@"%@ is deallco",NSStringFromClass([ListViewController class]));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
