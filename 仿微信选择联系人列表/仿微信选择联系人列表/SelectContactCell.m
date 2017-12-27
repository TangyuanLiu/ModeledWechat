//
//  SelectContactCell.m
//  ukee
//
//  Created by 刘汤圆 on 2017/11/30.
//  Copyright © 2017年 龙眼. All rights reserved.
//

#import "SelectContactCell.h"

@implementation SelectContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _selectedBtn.userInteractionEnabled = NO;
    _contactAvatarImg.layer.masksToBounds = YES;
    _contactAvatarImg.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _selectedBtn.selected = NO;
    [_selectedBtn setImage:[UIImage imageNamed:@"circle_empty"] forState:(UIControlStateNormal)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
