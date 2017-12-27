//
//  SelectMemberCollectionCell.m
//  ukee
//
//  Created by yongda on 2017/8/31.
//  Copyright © 2017年 龙眼. All rights reserved.
//

#import "SelectMemberCollectionCell.h"

@implementation SelectMemberCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.memberHeadImg.layer.masksToBounds = YES;
    self.memberHeadImg.layer.cornerRadius = 3;
    self.memberHeadImg.contentMode = UIViewContentModeScaleAspectFill;
}

@end
