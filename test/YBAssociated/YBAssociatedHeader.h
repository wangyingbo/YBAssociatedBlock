//
//  YBAssociatedHeader.h
//  test
//
//  Created by 王迎博 on 2017/8/28.
//  Copyright © 2017年 王颖博. All rights reserved.
//

#ifndef YBAssociatedHeader_h
#define YBAssociatedHeader_h

#import <objc/runtime.h>
#import "NSObject+Associated.h"


typedef OBJC_ENUM(uintptr_t, yb_objc_AssociationPolicy) {
    YB_OBJC_ASSOCIATION_ASSIGN = OBJC_ASSOCIATION_ASSIGN,
    YB_OBJC_ASSOCIATION_RETAIN_NONATOMIC = OBJC_ASSOCIATION_RETAIN_NONATOMIC,
    YB_OBJC_ASSOCIATION_COPY_NONATOMIC = OBJC_ASSOCIATION_COPY_NONATOMIC,
    YB_OBJC_ASSOCIATION_RETAIN = OBJC_ASSOCIATION_RETAIN,
    YB_OBJC_ASSOCIATION_COPY = OBJC_ASSOCIATION_COPY
};


/** 给category增加任意属性
 *  exemple :
 *  @property (nonatomic,assign)CGPoint point;
 *  YB_SYNTHESIZE_CATEGORY_PROPERTY_CTYPE(point,setPoint,CGPoint)
 *
 *  YB_SYNTHESIZE_CATEGORY_PROPERTY_CTYPE
 *
 *  @param GETTER getter 方法名
 *  @param SETTER setter 方法名字
 *  @param CTYPE 数据类型
 *
 */
#define YB_SYNTHESIZE_CATEGORY_PROPERTY_CTYPE(GETTER,SETTER,CTYPE)\
-(CTYPE)GETTER{\
NSValue *associate_value = objc_getAssociatedObject(self, @selector(GETTER));\
CTYPE  value;\
[associate_value getValue:&value];\
return value;\
}\
-(void)SETTER:(CTYPE)value{\
NSValue *associate_value = [NSValue value:&value withObjCType:@encode(CTYPE)];\
objc_setAssociatedObject(self, @selector(GETTER), associate_value, OBJC_ASSOCIATION_ASSIGN);\
}


/**一句代码解决多层级页面响应传值（基于runtime和block）*/
//#define YB_OBJC_SET_ASSOCIATED_OBJECT(CLASS,KEY,PARAM,POLICY) objc_setAssociatedObject(CLASS, KEY, PARAM, POLICY)
#define YB_OBJC_GET_ASSOCIATED_OBJECT(CLASS,KEY) objc_getAssociatedObject(CLASS, KEY)
#define YB_OBJC_SET_ASSOCIATED_OBJECT(CLASS,KEY,PARAM,POLICY)\
if (CLASS) {\
    Ivar ivar = class_getInstanceVariable(CLASS, [[NSString stringWithFormat:@"_%@", PARAM] UTF8String]);\
    if (ivar){\
        ivar;\
    }\
    else{\
        objc_setAssociatedObject(CLASS, KEY, PARAM, POLICY);\
    }\
}\
else {\
    NSLog(@"YB_OBJC_SET_ASSOCIATED_OBJECT 类为空");\
}\




/** 给category增加任意属性
 *  exemple :
 *  @property (nonatomic,  copy)NSString *string;
 *  YB_SYNTHESIZE_CATEGORY_PROPERTY(string , setString,OBJC_ASSOCIATION_RETAIN_NONATOMIC)
 *
 *  YB_SYNTHESIZE_CATEGORY_PROPERTY_RETAIN retain属性
 *  YB_SYNTHESIZE_CATEGORY_PROPERTY_COPY copy属性
 *  YB_SYNTHESIZE_CATEGORY_PROPERTY_ASSIGN assign属性
 *
 *  @param GETTER getter 方法名
 *  @param SETTER setter 方法名,不需要:
 */
#define YB_SYNTHESIZE_CATEGORY_PROPERTY_RETAIN(GETTER,SETTER) YB_SYNTHESIZE_CATEGORY_PROPERTY(GETTER,SETTER,OBJC_ASSOCIATION_RETAIN_NONATOMIC,id)
#define YB_SYNTHESIZE_CATEGORY_PROPERTY_COPY(GETTER,SETTER)   YB_SYNTHESIZE_CATEGORY_PROPERTY(GETTER,SETTER,OBJC_ASSOCIATION_COPY,id)
#define YB_SYNTHESIZE_CATEGORY_PROPERTY_ASSIGN(GETTER,SETTER) YB_SYNTHESIZE_CATEGORY_PROPERTY(GETTER,SETTER,OBJC_ASSOCIATION_ASSIGN,id)
#define YB_SYNTHESIZE_CATEGORY_PROPERTY_BLOCK(GETTER,SETTER,TYPE)   YB_SYNTHESIZE_CATEGORY_PROPERTY(GETTER,SETTER,OBJC_ASSOCIATION_COPY,TYPE)

#define YB_SYNTHESIZE_CATEGORY_PROPERTY(GETTER,SETTER,objc_AssociationPolicy,TYPE)\
- (TYPE)GETTER{return objc_getAssociatedObject(self, @selector(GETTER));}\
- (void)SETTER:(TYPE)obj{objc_setAssociatedObject(self, @selector(GETTER), obj, objc_AssociationPolicy);}



#endif /* YBAssociatedHeader_h */
