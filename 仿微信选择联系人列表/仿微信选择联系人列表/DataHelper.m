//
//  DataHelper.m
//  仿微信选择联系人列表
//
//  Created by yongda on 2017/12/28.
//  Copyright © 2017年 TangyuanLiu. All rights reserved.
//

#import "DataHelper.h"
#import "ConatctModel.h"
#import "NSString+Transform.h"
#import <UIKit/UIKit.h>

@implementation DataHelper

/**
 联系人数组排序
 
 @param array 原始联系人数组数据
 @return 排序后的联系人数组
 */
+ (NSMutableArray *) getContactListDataBy:(NSMutableArray *)array{
    
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {//排序
        int i;
        NSString *strA = [((ConatctModel *)obj1).name transformCharacter];
        NSString *strB = [((ConatctModel *)obj2).name transformCharacter];
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = [strA characterAtIndex:i];
            char b = [strB characterAtIndex:i];
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;//上升
            }
            else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;//下降
            }
        }
        
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    char lastC = '1';
    NSMutableArray *data;
    NSMutableArray *oth = [[NSMutableArray alloc] init];
    for (ConatctModel *contact in serializeArray) {
        char c = [[contact.name transformCharacter] characterAtIndex:0];
        if (!isalpha(c)) {
            [oth addObject:contact];
        }
        else if (c != lastC){
            lastC = c;
            if (data && data.count > 0) {
                [ans addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:contact];
        }
        else {
            [data addObject:contact];
        }
    }
    if (data && data.count > 0) {
        [ans addObject:data];
    }
    if (oth.count > 0) {
        [ans addObject:oth];
    }
    return ans;
}


/**
 获取分区数(姓氏首字母)

 @param array 排序后的联系人数组
 @return [A,B,C,D.....]
 */
+ (NSMutableArray *)getContactListSectionBy:(NSMutableArray *)array {
    
    NSMutableArray *section = [[NSMutableArray alloc] init];
    [section addObject:UITableViewIndexSearch]; // 索引栏最上方的搜索icon
    for (NSArray *item in array) {
        ConatctModel *model = [item objectAtIndex:0];
        char c = [[model.name transformCharacter] characterAtIndex:0];
        if (!isalpha(c)) {
            c = '#';
        }
        [section addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
    }
    return section;
}




@end
