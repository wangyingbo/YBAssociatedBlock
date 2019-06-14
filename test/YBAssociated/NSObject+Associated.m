//
//  NSObject+Associated.m
//  test
//
//  Created by 王迎博 on 2017/8/28.
//  Copyright © 2017年 王颖博. All rights reserved.
//

#import "NSObject+Associated.h"



@implementation NSArray (safeGet)

- (id)safeGetAtIndex:(NSInteger)index
{
    if (index + 1>self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end

@implementation NSObject (Associated)

#pragma mark - 通过runtime动态关联对象
+ (void)setAssociatedWithClass:(NSString *)cla key:(NSString *)key policy:(objc_AssociationPolicy)policy completion:(void(^)(id obj))completion
{
    YB_OBJC_SET_ASSOCIATED_OBJECT(NSClassFromString(cla), (__bridge const void *)key, completion, policy);
}

+ (void)getAssociatedWithClass:(NSString *)cla key:(NSString *)key param:(id)param
{
    void(^block)(id obj) = YB_OBJC_GET_ASSOCIATED_OBJECT(NSClassFromString(cla), (__bridge const void*)key);
    
    if (block) {
        block(param);
    }
}

+ (void)yb_setAssociatedWithClass:(NSString *)cla withPropertyName:(NSString *)propertyName withValue:(id)value withPolicy:(objc_AssociationPolicy)policy
{
    id property = objc_getAssociatedObject(NSClassFromString(cla), (__bridge const void *)propertyName);
    
    if(property == nil)
    {
        property = value;
        YB_OBJC_SET_ASSOCIATED_OBJECT(NSClassFromString(cla), (__bridge const void *)propertyName, property, policy);
    }
}

+ (id)yb_getAssociatedValueWithClass:(NSString *)cla withPropertyName:(NSString *)propertyName
{
    id property = YB_OBJC_GET_ASSOCIATED_OBJECT(NSClassFromString(cla), (__bridge const void *)propertyName);
    return property;
}

+ (void)msgSendWithClass:( NSString * _Nonnull )claString withSelector:(NSString * _Nonnull)selString withCompletion:(void(^_Nullable)(id _Nullable obj))completion withParam:(id _Nullable )firstParam, ... NS_REQUIRES_NIL_TERMINATION;
{
    if (!claString || !selString) {
        @throw [NSException exceptionWithName:@"param nil" reason:@"类名或者方法名为空" userInfo:nil];
        return;
    }
    
    id objc;
    SEL sel;
    
    sel = NSSelectorFromString(selString);
    Class class = NSClassFromString(claString);
    id subObjc = [class new];
    
    if (!class) {
        NSLog(@"打印：\n%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:@"类名%@为空，请检查传入的类名",claString]);
        NSException *excp = [NSException exceptionWithName:@"class nil" reason:[NSString stringWithFormat:@"类名%@为空，请检查传入的类名",claString] userInfo:nil];
        [excp raise];
        return;
    }
    
    NSArray *methodsArrSub = [self LogAllMethodsFromClass:subObjc];
    if ([methodsArrSub containsObject:selString]) {
        objc = subObjc;
    }
    
    if (!objc) {
        objc = class;
    }
    
    if (![objc respondsToSelector:sel]) {
        NSLog(@"打印：\n%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:@"方法名%@为空，请检查传入的方法名",NSStringFromSelector(sel)]);
        @throw [NSException exceptionWithName:@"sel nil" reason:[NSString stringWithFormat:@"方法名%@为空，请检查传入的方法名",NSStringFromSelector(sel)] userInfo:nil];
        return;
    }
    
    NSMutableArray *mutArr = [NSMutableArray array];
    [mutArr addObject:firstParam];
    
    if (firstParam) {
        // 取出第一个参数
        //NSLog(@"%@", firstParam);
        // 定义一个指向个数可变的参数列表指针；
        va_list args;
        // 用于存放取出的参数
        id arg;
        // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, firstParam);
        // 遍历全部参数 va_arg返回可变的参数(va_arg的第二个参数是你要返回的参数的类型)
        while ((arg = va_arg(args, id))) {
            //NSLog(@"%@", arg);
            if (arg){ [mutArr addObject:arg]; };
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
    }
    
    //IMP imp = [objc methodForSelector:sel];
    
    Method met = class_getInstanceMethod([objc class],sel);
    //char * method_copyReturnType ( Method m );
    // 获取描述方法参数和返回值类型的字符串
    //const char * method_getTypeEncoding ( Method m );
    //char *returnT = (char *)method_getTypeEncoding(met);
    //printf("类型是：%s\n", returnT);
    
    char returnType[512] = {};
    method_getReturnType(met, returnType, 512);
    //NSLog(@"返回值类型：%s", returnType);
    
    NSString *type = [NSString stringWithFormat:@"%s", returnType];
    
    id (* mySelector)(id self,SEL _cmd,id obj, ... ) = (void *)objc_msgSend;
    //id (* yb_msgSend)(id self,SEL _cmd,...) = (void *)objc_msgSend;
    id obj;
    @try {
        if ([type isEqualToString:@"v"]) {
            mySelector(objc,sel,[mutArr safeGetAtIndex:0],[mutArr safeGetAtIndex:1],[mutArr safeGetAtIndex:2],[mutArr safeGetAtIndex:3],[mutArr safeGetAtIndex:4],[mutArr safeGetAtIndex:5],[mutArr safeGetAtIndex:6],[mutArr safeGetAtIndex:7],[mutArr safeGetAtIndex:8],[mutArr safeGetAtIndex:9]);
            
            return;
        }
        
        obj = mySelector(objc,sel,[mutArr safeGetAtIndex:0],[mutArr safeGetAtIndex:1],[mutArr safeGetAtIndex:2],[mutArr safeGetAtIndex:3],[mutArr safeGetAtIndex:4],[mutArr safeGetAtIndex:5],[mutArr safeGetAtIndex:6],[mutArr safeGetAtIndex:7],[mutArr safeGetAtIndex:8],[mutArr safeGetAtIndex:9]);
        if (completion) {
            completion(obj);
        }
        
        
    } @catch (NSException *exception) {
    } @finally {
    }
    
}

/**
 可变参数
 //https://blog.csdn.net/focusjava/article/details/9290411

 @param aSelector 方法
 @param objects 对象
 @return 返回值
 */
- (id)yb_performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    NSUInteger i = 1;
    for (id object in objects) {
        [invocation setArgument:(__bridge void * _Nonnull)(object) atIndex:++i];
    }
    [invocation invoke];
    
    if ([signature methodReturnLength]) {
        id data;
        [invocation getReturnValue:&data];
        return data;
    }
    return nil;
}

- (id)yb_performSelector:(SEL)aSelector withParameters:(id)firstParameter, ... {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    NSUInteger length = [signature numberOfArguments];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    [invocation setArgument:&firstParameter atIndex:2];
    va_list arg_ptr;
    va_start(arg_ptr, firstParameter);
    for (NSUInteger i = 3; i < length; ++i) {
        void *parameter = va_arg(arg_ptr, void *);
        [invocation setArgument:&parameter atIndex:i];
    }
    va_end(arg_ptr);
    
    [invocation invoke];
    if ([signature methodReturnLength]) {
        id data;
        [invocation getReturnValue:&data];
        return data;
    }
    return nil;
}

inline id yb_performSelector(id target, SEL aSelector,id firstParameter, ...) {
    NSMethodSignature *signature = [target methodSignatureForSelector:aSelector];
    NSUInteger length = [signature numberOfArguments];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:target];
    [invocation setSelector:aSelector];
    
    [invocation setArgument:&firstParameter atIndex:2];
    va_list arg_ptr;
    va_start(arg_ptr, firstParameter);
    for (NSUInteger i = 3; i < length; ++i) {
        void *parameter = va_arg(arg_ptr, void *);
        [invocation setArgument:&parameter atIndex:i];
    }
    va_end(arg_ptr);
    
    [invocation invoke];
    if ([signature methodReturnLength]) {
        id data;
        [invocation getReturnValue:&data];
        return data;
    }
    return nil;
}

/**
 获取类的实例方法
 
 @param obj obj description
 @return return value description
 */
+ (NSArray *)LogAllMethodsFromClass:(id)obj
{
    NSMutableArray *mutArr = [NSMutableArray array];
    u_int count;
    //class_copyMethodList 获取类的所有方法列表
    Method *mothList_f = class_copyMethodList([obj class],&count) ;
    for (int i = 0; i < count; i++) {
        Method temp_f = mothList_f[i];
        // method_getImplementation  由Method得到IMP函数指针
        //IMP imp_f = method_getImplementation(temp_f);
        
        // method_getName由Method得到SEL
        SEL name_f = method_getName(temp_f);
        
        const char * name_s = sel_getName(name_f);
        // method_getNumberOfArguments  由Method得到参数个数
        //int arguments = method_getNumberOfArguments(temp_f);
        // method_getTypeEncoding  由Method得到Encoding 类型
        //const char * encoding = method_getTypeEncoding(temp_f);
        
        //NSLog(@"方法名：%@\n,参数个数：%d\n,编码方式：%@\n",[NSString stringWithUTF8String:name_s], arguments,[NSString stringWithUTF8String:encoding]);
        
        [mutArr addObject:[NSString stringWithUTF8String:name_s]];
    }
    free(mothList_f);
    
    return mutArr;
}


#pragma mark - 动态添加
//在目标target上添加属性，属性名propertyname（可为block），值value-这种方法能够在已有的类中添加property，且能够遍历到动态添加的属性
//+ (void)setPropertyWithtarget:(id)target withPropertyName:(NSString *)propertyName withValue:(id)value
//{
//    //先判断有没有这个属性，没有就添加，有就直接赋值
//    Ivar ivar = class_getInstanceVariable([target class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
//    if (ivar) {
//        return;
//    }
//
//    /*
//       objc_property_attribute_t type = { "T", "@\"NSString\"" };
//       objc_property_attribute_t ownership = { "C", "" }; // C = copy
//       objc_property_attribute_t backingivar  = { "V", "_privateName" };
//       objc_property_attribute_t attrs[] = { type, ownership, backingivar };
//       class_addProperty([SomeClass class], "name", attrs, 3);
//    */
//
//    //objc_property_attribute_t所代表的意思可以调用getPropertyNameList打印，大概就能猜出
//    objc_property_attribute_t type = { "T", [[NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([value class])] UTF8String] };
//    objc_property_attribute_t ownership = { "&", "N" };
//    objc_property_attribute_t backingivar  = { "V", [[NSString stringWithFormat:@"_%@", propertyName] UTF8String] };
//    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
//    if (class_addProperty([target class], [propertyName UTF8String], attrs, 3))
//    {
//        //添加get和set方法
//        class_addMethod([target class], NSSelectorFromString(propertyName), (IMP)getter, "@@:");
//        class_addMethod([target class], NSSelectorFromString([NSString stringWithFormat:@"set%@:",[propertyName capitalizedString]]), (IMP)setter, "v@:@");
//
//        //赋值
//        if (value && propertyName) {
//            //[target setValue:value forKey:propertyName];
//            //NSLog(@"%@", [target valueForKey:propertyName]);
//            NSLog(@"创建属性Property成功");
//        }
//
//    } else {
//        class_replaceProperty([target class], [propertyName UTF8String], attrs, 3);
//        //添加get和set方法
//        class_addMethod([target class], NSSelectorFromString(propertyName), (IMP)getter, "@@:");
//        class_addMethod([target class], NSSelectorFromString([NSString stringWithFormat:@"set%@:",[propertyName capitalizedString]]), (IMP)setter, "v@:@");
//
//        //赋值
//        [target setValue:value forKey:propertyName];
//    }
//}
//
//id getter(id self1, SEL _cmd1) {
//    NSString *key = NSStringFromSelector(_cmd1);
//    Ivar ivar = class_getInstanceVariable([self1 class], "_dictCustomerProperty");  //basicsViewController里面有个_dictCustomerProperty属性
//    NSMutableDictionary *dictCustomerProperty = object_getIvar(self1, ivar);
//    return [dictCustomerProperty objectForKey:key];
//}
//
//void setter(id self1, SEL _cmd1, id newValue) {
//    //移除set
//    NSString *key = [NSStringFromSelector(_cmd1) stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
//    //首字母小写
//    NSString *head = [key substringWithRange:NSMakeRange(0, 1)];
//    head = [head lowercaseString];
//    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:head];
//    //移除后缀 ":"
//    key = [key stringByReplacingCharactersInRange:NSMakeRange(key.length - 1, 1) withString:@""];
//
//    Ivar ivar = class_getInstanceVariable([self1 class], "_dictCustomerProperty");  //basicsViewController里面有个_dictCustomerProperty属性
//    NSMutableDictionary *dictCustomerProperty = object_getIvar(self1, ivar);
//    if (!dictCustomerProperty) {
//         dictCustomerProperty = [NSMutableDictionary dictionary];
//        object_setIvar(self1, ivar, dictCustomerProperty);
//    }
//    [dictCustomerProperty setObject:newValue forKey:key];
//}
//
//+ (id)getPropertyValueWithTarget:(id)target withPropertyName:(NSString *)propertyName
//{
//     //先判断有没有这个属性，没有就添加，有就直接赋值
//     Ivar ivar = class_getInstanceVariable([target class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
//     if (ivar) {
//         return object_getIvar(target, ivar);
//     }
//
//     ivar = class_getInstanceVariable([target class], "_dictCustomerProperty");  //basicsViewController里面有个_dictCustomerProperty属性
//     NSMutableDictionary *dict = object_getIvar(target, ivar);
//     if (dict && [dict objectForKey:propertyName]) {
//         return [dict objectForKey:propertyName];
//     } else {
//         return nil;
//     }
//}

@end
