//
//  ViewController.m
//  test
//
//  Created by 王迎博 on 2017/8/28.
//  Copyright © 2017年 王颖博. All rights reserved.
//

#import "ViewController.h"
#import "YBView.h"
#import "YBAssociatedHeader.h"
#import "YBView+Category.h"


typedef void(^YBTapBlock)(id obj);

@interface ViewController ()
@property (nonatomic, weak) YBView *myView;

@property (nonatomic, copy) YBTapBlock tapBlock;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    YBView *myView = [[YBView alloc]init];
    myView.backgroundColor = [UIColor brownColor];
    myView.string = @"";
    [self.view addSubview:myView];
    self.myView = myView;
    
    
    
//    void (^t)(NSString *str) = ^(NSString *str){
//        NSLog(@"%@",str);
//    };
    /**原始的*/
//    objc_setAssociatedObject(NSClassFromString(@"YBView"), "asdfghjkl", t, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    /**用宏定义封装的*/
    //YB_OBJC_SET_ASSOCIATED_OBJECT(NSClassFromString(@"YBView"), @"YBView_key", t, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    /**封装成一句代码回调*/
    [NSObject setAssociatedWithClass:@"YBView" key:@"YBView_key" policy:OBJC_ASSOCIATION_COPY_NONATOMIC completion:^(id obj) {
        if (self.tapBlock) {//回调以后再传出回调
            self.tapBlock(obj);
        }
    }];
    
    /**宏定义传值*/
    YB_OBJC_SET_ASSOCIATED_OBJECT(NSClassFromString(@"YBView"), @"YBView_key1", @"测试传值", OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    /**传值*/
    [NSObject yb_setAssociatedWithClass:@"YBView" withPropertyName:@"tagString" withValue:@"wang yingbo test" withPolicy:OBJC_ASSOCIATION_COPY_NONATOMIC];
    
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.myView.frame = CGRectMake(100, 100, 150, 80);
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //被赋值后可以在任意地方响应
    self.tapBlock = ^(id obj) {
        NSLog(@"回调————————%@",obj);
    };
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    YB_OBJC_SET_ASSOCIATED_OBJECT(NSClassFromString(@"YBView"), @"YBView_key1", @"改变传值123", OBJC_ASSOCIATION_COPY_NONATOMIC);
    id changeValue = YB_OBJC_GET_ASSOCIATED_OBJECT(NSClassFromString(@"YBView"), @"YBView_key1");
    NSLog(@"改变传值————————%@",changeValue);
}

@end
