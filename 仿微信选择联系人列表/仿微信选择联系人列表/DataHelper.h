//
//  DataHelper.h
//  仿微信选择联系人列表
//
//  Created by yongda on 2017/12/28.
//  Copyright © 2017年 TangyuanLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHelper : NSObject
// 获取排序后的通讯录列表
+ (NSMutableArray *) getContactListDataBy:(NSMutableArray *)array;
// 获取分区数(索引列表)
+ (NSMutableArray *) getContactListSectionBy:(NSMutableArray *)array;
@end
