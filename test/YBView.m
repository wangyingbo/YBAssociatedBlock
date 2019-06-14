//
//  YBView.m
//  test
//
//  Created by 王迎博 on 2017/8/28.
//  Copyright © 2017年 王颖博. All rights reserved.
//

#import "YBView.h"
#import "YBAssociatedHeader.h"
#import <objc/message.h>



@interface YBView ()

@property (nonatomic, weak) UIButton *button;

@end

@implementation YBView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"点击测试" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.button = button;
    
}

- (void)buttonClick:(UIButton *)sender
{
    sender.tag = 1001;
    
    
    /**封装成一句代码的回调传参*/
    [NSObject getAssociatedWithClass:@"YBView" key:@"YBView_key" param:@[@"wang",@"123",@{@"key":@"value"}]];
    
    
    /**宏定义传值*/
    id myValue = YB_OBJC_GET_ASSOCIATED_OBJECT(NSClassFromString(@"YBView"), @"YBView_key1");
    NSLog(@"传值————————%@",myValue);
    
    
    /**获取传值*/
    id tagStr = [NSObject yb_getAssociatedValueWithClass:@"YBView" withPropertyName:@"tagString"];
    NSLog(@"tag字符串——————————%@",tagStr);
    
    
    /**利用msgSend函数调用任意类的类方法和实例方法，公有或私有方法*/
    [NSObject msgSendWithClass:@"ViewController" withSelector:@"testSendWithParam:withName:withCompletion:" withCompletion:^(id obj) {
        
        NSLog(@"函数返回值：%@",obj);
        
    } withParam:sender,@"param2",^(bool isOrNot,id res){
        
        NSLog(@"block参数的返回值：%@!%@",isOrNot?@"yes":@"no",res);
        
    } , nil];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.button.frame = self.bounds;
}

+ (void)print:(NSString *)firstArg, ... NS_REQUIRES_NIL_TERMINATION {
    if (firstArg) {
        // 取出第一个参数
        NSLog(@"%@", firstArg);
        // 定义一个指向个数可变的参数列表指针；
        va_list args;
        // 用于存放取出的参数
        NSString *arg;
        // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, firstArg);
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
        while ((arg = va_arg(args, NSString *))) {
            NSLog(@"%@", arg);
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
    }
}


@end
