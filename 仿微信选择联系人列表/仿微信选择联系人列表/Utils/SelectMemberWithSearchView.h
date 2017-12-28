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

- (void)removeMemberFromSelectArray:(ConatctModel *)member
                          indexPath:(NSIndexPath *)indexPath;

@end


@interface SelectMemberWithSearchView : UIView
@property (nonatomic, weak) id<SelectMemberWithSearchViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITextField *textfield;

- (void)updateSubviewsLayout:(NSMutableArray *)selelctArray;

@end
