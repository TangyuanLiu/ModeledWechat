//
//  NSString+Transform.m
//  仿微信选择联系人列表
//
//  Created by yongda on 2017/12/28.
//  Copyright © 2017年 TangyuanLiu. All rights reserved.
//

#import "NSString+Transform.h"

@implementation NSString (Transform)
/**
 把姓名转化成拼音且首字母大写
 */
- (NSString *)transformCharacter {
    
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str stringByReplacingOccurrencesOfString:@" " withString:@""];;
    
    return [pinYin uppercaseString];
}

@end
