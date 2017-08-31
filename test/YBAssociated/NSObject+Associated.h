//
//  NSObject+Associated.h
//  test
//
//  Created by 王迎博 on 2017/8/28.
//  Copyright © 2017年 王颖博. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBAssociatedHeader.h"
#import <objc/runtime.h>

@interface NSObject (Associated)

#pragma mark - 通过runtime动态关联对象

/**
 通过runtime动态关联set对象(block)-block回调

 @param cla 类名
 @param key 值的key
 @param policy policy description
 @param completion 回调方法
 */
+ (void)setAssociatedWithClass:(NSString *)cla key:(NSString *)key policy:(objc_AssociationPolicy)policy completion:(void(^)(id obj))completion;

/**
 通过runtime动态关联get对象(block)-block回调传参

 @param cla 类名
 @param key 值的key
 @param param 可以传出去的参数
 */
+ (void)getAssociatedWithClass:(NSString *)cla key:(NSString *)key param:(id)param;


/**
 添加属性-传值

 @param cla 类名称
 @param propertyName 属性名
 @param value 属性值
 @param policy policy description
 */
+ (void)yb_setAssociatedWithClass:(NSString *)cla withPropertyName:(NSString *)propertyName withValue:(id)value withPolicy:(objc_AssociationPolicy)policy;

/**
 获得属性-传值

 @param cla 类名称
 @param propertyName 属性名
 @return 属性的值
 */
+ (id)yb_getAssociatedValueWithClass:(NSString *)cla withPropertyName:(NSString *)propertyName;


#pragma mark - 通过runtime动态添加property
/**
 通过runtime动态添加property

 @param target 对象
 @param propertyName 属性名
 @param value 值
 */
//+ (void)setPropertyWithtarget:(id)target withPropertyName:(NSString *)propertyName withValue:(id)value;

/**
 通过runtime动态获取property

 @param target 对象
 @param propertyName 属性名
 @return 值
 */
//+ (id)getPropertyValueWithTarget:(id)target withPropertyName:(NSString *)propertyName;


@end
