//
//  YBViewController.m
//  test
//
//  Created by 王迎博 on 2017/11/27.
//  Copyright © 2017年 王颖博. All rights reserved.
//

#import "YBViewController.h"

@interface YBViewController ()

@end

@implementation YBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)dealloc
{
    /**下面这样写会崩溃，原因待解*/
    //__weak __typeof(self)weakSelf = self;
    //NSLog(@"%@",weakSelf);
}


@end
