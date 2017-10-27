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
    
    
    /**利用msgSend函数调用方法*/
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

@end
