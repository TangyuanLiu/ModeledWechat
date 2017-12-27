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

#define kGreenColor [UIColor colorWithRed:1/255.0 green:190/255.0 blue:86/255.0 alpha:1]

@interface ListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UITableView *indexTableView;
@property (nonatomic, strong) SelectMemberWithSearchView *searchView;


@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择联系人列表";
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.translucent = NO;
    [self setupBarButtonItems];
    [self setupSubViews];
}

- (void)setupBarButtonItems {
    
    UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftBtn.frame = CGRectMake(0, 0, 60, 30);
    [leftBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [leftBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [leftBtn addTarget:self action:@selector(cancleAct) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [rightBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [rightBtn setTitleColor:kGreenColor forState:(UIControlStateNormal)];
    [rightBtn addTarget:self action:@selector(confirmAct) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)setupSubViews {
    
    // 头部搜索view
    self.searchView = [[SelectMemberWithSearchView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 52)];
    _searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchView];
    
    // 列表
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchView.frame)+0.5, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-52-0.5) style:(UITableViewStylePlain)];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.showsVerticalScrollIndicator = NO;
    _listTableView.backgroundColor = [UIColor whiteColor];
    _listTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_listTableView];
    [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectContactCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([SelectContactCell class])];
    
    // 索引
    self.indexTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 30, 100) style:(UITableViewStylePlain)];
    _indexTableView.center = CGPointMake([UIScreen mainScreen].bounds.size.width-20,self.view.center.y);
    _indexTableView.delegate = self;
    _indexTableView.dataSource = self;
    _indexTableView.showsVerticalScrollIndicator = NO;
    _indexTableView.backgroundColor = [UIColor lightGrayColor];
    _indexTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_indexTableView];
    [_indexTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark -------- tableview --------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableView == _listTableView ? 52.0 : 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return tableView == _listTableView ? 30.0 : 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _listTableView) {
        SelectContactCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectContactCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark -------- target/action --------
- (void)cancleAct {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmAct {
    
    NSLog(@"确认......");
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
