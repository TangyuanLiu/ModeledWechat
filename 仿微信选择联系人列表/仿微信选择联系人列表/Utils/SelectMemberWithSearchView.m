//
//  SelectMemberWithSearchView.m
//  ukee
//
//  Created by 刘汤圆 on 2017/8/31.
//  Copyright © 2017年 龙眼. All rights reserved.
//

#import "SelectMemberWithSearchView.h"
#import "SelectMemberCollectionCell.h"


@interface SelectMemberWithSearchView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *selectArray;

@end


@implementation SelectMemberWithSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    [self addSubview:self.collectionView];
    [self addSubview:self.textfield];
}

#pragma mark -------- collectionview delegate/datasource --------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _selectArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectMemberCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SelectMemberCollectionCell class]) forIndexPath:indexPath];
    ConatctModel *model = _selectArray[indexPath.item];
    cell.memberHeadImg.image = [UIImage imageNamed:model.portrait];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // remove the model from selectArray
    ConatctModel *model = _selectArray[indexPath.item];
    [_selectArray removeObject:model];

    if ([_delegate respondsToSelector:@selector(removeMemberFromSelectArray:indexPath:)]) {
        [_delegate removeMemberFromSelectArray:model indexPath:indexPath];
    }
    [self updateSubviewsLayout:_selectArray];
}

#pragma mark -------- method --------
- (void)updateSubviewsLayout:(NSMutableArray *)selelctArray {
    
    self.selectArray = selelctArray;
    
    CGFloat margin = 8;
    NSInteger count = _selectArray.count;
    CGFloat itemWidth = 36;
    CGFloat width = (margin + itemWidth)*count;
    CGFloat x = (count == 0 ? 0 : 10);
    BOOL isLessThan = (width <= 282/375.0*[UIScreen mainScreen].bounds.size.width);
    CGFloat finalWidth = isLessThan ? width : 282/375.0*[UIScreen mainScreen].bounds.size.width;
    self.collectionView.frame = CGRectMake(x, 0, finalWidth, self.bounds.size.height);
    self.textfield.frame = CGRectMake(CGRectGetMaxX(self.collectionView.frame), 16, [UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(self.collectionView.frame), 20);
    self.textfield.leftViewMode = count < 1 ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
    [self.collectionView reloadData];
    
    if (!isLessThan) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectArray.count - 1 inSection:0] atScrollPosition:(UICollectionViewScrollPositionRight) animated:YES];
    }

    [self layoutIfNeeded];
}

#pragma mark -------- lazy init --------
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(36, 36);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 8;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, self.bounds.size.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"SelectMemberCollectionCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SelectMemberCollectionCell class])];
    }
    
    return _collectionView;
}

- (UITextField *)textfield {
    
    if (!_textfield) {
        
        _textfield = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.collectionView.frame), 16, [UIScreen mainScreen].bounds.size.width - self.collectionView.bounds.size.width, 20)];
        _textfield.placeholder = @"搜索";
        _textfield.tintColor = [UIColor blackColor];
        _textfield.textColor = [UIColor blackColor];
        _textfield.font = [UIFont systemFontOfSize:14];
        _textfield.borderStyle = UITextBorderStyleNone;
        _textfield.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(0, 0, 40, 20);
        [btn setImage:[UIImage imageNamed:@"chat_search"] forState:(UIControlStateNormal)];
        btn.enabled = NO;
        _textfield.leftView = btn;
        _textfield.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return _textfield;
}


@end
