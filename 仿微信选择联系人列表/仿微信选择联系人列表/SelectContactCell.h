//
//  SelectContactCell.h
//  ukee
//
//  Created by 刘汤圆 on 2017/11/30.
//  Copyright © 2017年 龙眼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *contactAvatarImg;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;

@end
