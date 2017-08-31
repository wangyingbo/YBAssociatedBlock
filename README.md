# YBAssociatedBlock

### features

+ **一句代码解决多层级页面响应传值（基于runtime和block）；**
+ **一句话给category增加属性；**


**利用宏定义实现上述两种功能；基于宏封装**

### 传值或回调的使用方法

+ **导入**

在项目的`.pch`里导入`#import "YBAssociatedHeader.h"`可以在任何类调用；或者在需要传值和回调的类里导入`#import "YBAssociatedHeader.h"`。

+ **说明**

比如在ViewController里有自定义的view，此view的里又有多个自定义的subView，在最里层的view里有一个button，点击button要响应跳转事件，传统的做法有两种：**1、用delegate或着block；2、用通知或者KVO。**不过弊端是，用第一种方法时如果view的层级很深的话需要用多个delegate或者block传值，多个delegate需要修改方法时很痛苦，block又要担心循环引用的问题；第二种方法通知或者KVO使用步骤冗余，而且需要关注移除时机。
用[**YBAssociated**](https://github.com/wangyingbo/YBAssociatedBlock)时完成不用担心此问题。此种方法是在ViewController里动态的给需要传值或者回调的子view里利用runtime的setAssociate方法增加一个属性，此属性可以是block或者常用类型。然后在子view里利用getAssociate获取值，实现完全解耦，不用import或则@class类名，只需要传入类名字符串就可以实现。

###eg

+ **使用此类进行回调**

在ViewController里调用如下：

        /**一句代码回调*/
         [NSObject setAssociatedWithClass:@"YBView" key:@"YBView_key" policy:OBJC_ASSOCIATION_COPY_NONATOMIC completion:^(id obj) {
          NSLog(@"____%@",obj);
         }];
 
 在子view的button点击方法里调用如下：
 
        - (void)buttonClick:(UIButton *)sender {
            /**一句代码的回调传参*/
            [NSObject getAssociatedWithClass:@"YBView" key:@"YBView_key" param:@[@"wang",@"123",@{@"key":@"value"}]];
            }
            
+ **使用此类传参**

在ViewController里调用如下：

    /**传值*/
    [NSObject yb_setAssociatedWithClass:@"YBView" withPropertyName:@"tagString" withValue:@"wang yingbo test" withPolicy:OBJC_ASSOCIATION_COPY_NONATOMIC];

在子类view里接收传值：

    /**获取传值*/
        id tagStr = [NSObject yb_getAssociatedValueWithClass:@"YBView" withPropertyName:@"tagString"];
        NSLog(@"tag字符串——————————%@",tagStr);

### 给category增加属性的使用方法

+ **在分类的`YBView+Category.h`文件里声明属性**

        @interface YBView (Category)
        @property (nonatomic, copy) NSString *string;
        @end

+ **在分类的`YBView+Category.m`文件里实现**

        @implementation YBView (Category)
        YB_SYNTHESIZE_CATEGORY_PROPERTY_CTYPE(string, setString, NSString *)
        @end





