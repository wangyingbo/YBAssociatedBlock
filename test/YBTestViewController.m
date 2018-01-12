//
//  YBTestViewController.m
//  test
//
//  Created by 王迎博 on 2018/1/12.
//  Copyright © 2018年 王颖博. All rights reserved.
//

#import "YBTestViewController.h"
#import "YBView.h"
#import "YBView+Category.h"
#import "YBAssociatedHeader.h"


typedef void(^YBTapBlock)(id obj);

@interface YBTestViewController ()
@property (nonatomic, weak) YBView *myView;
@property (nonatomic, copy) YBTapBlock tapBlock;

@end

@implementation YBTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    YBView *myView = [[YBView alloc]init];
    myView.backgroundColor = [UIColor brownColor];
    myView.string = @"";
    [self.view addSubview:myView];
    self.myView = myView;
    
    @weakify(self);
    self.tapBlock = ^(id obj) {
        @strongify(self);
        self.myView.string = @"hello,OC";
    };
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.tapBlock(nil);
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.myView.frame = CGRectMake(100, 100, 150, 80);
}

- (void)dealloc
{
    YBLog(@"%@被销毁了",[self class]);
}

@end
