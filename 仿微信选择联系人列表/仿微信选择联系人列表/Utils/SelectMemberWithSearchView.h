//
//  SelectMemberWithSearchView.h
//  ukee
//
//  Created by 刘汤圆 on 2017/8/31.
//  Copyright © 2017年 龙眼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConatctModel.h"

@protocol SelectMemberWithSearchViewDelegate <NSObject>
// 点击collection cell取消选中
- (void)removeMemberFromSelectArray:(ConatctModel *)member
                          indexPath:(NSIndexPath *)indexPath;
@end

@interface SelectMemberWithSearchView : UIView
@property (nonatomic, weak) id<SelectMemberWithSearchViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITextField *textfield;

// 当选中人数发生改变时 更改collection view UI
- (void)updateSubviewsLayout:(NSMutableArray *)selelctArray;

@end
