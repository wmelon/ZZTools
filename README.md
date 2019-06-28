## 功能简介
1. 瀑布流:     自定义collectionView的layout, 提供垂直&amp;水平&amp;浮动;水平&amp;多状态混合瀑布流效果(可实现淘宝SKU选择的浮动效果), 支持设置不同分区不同背景颜色.
2. 星星评价:  可自定义星星数量, 分级, 最低分, 支持拖拽手势, 支持半颗星(同样支持小数, 最低0.01).
3. 页面路由:  模块解耦, 组件化必备, 用法简单, 支持正向传值以及反向传值, 无需继承, 侵入性低.

## 使用方法

### 导入
1. 可直接下载demo, 将ZZTools文件夹拖入工程中使用.

2. cocoapods集成可使用: pod 'ZZTools' , 若搜索不到可尝试先使用pod setup更新.

3. 好用的话, 记得留下你的小星星哦!

### 引用
```

#import "ZZTools.h"

```

## 效果展示

### 瀑布流部分(gif较多, 看起来可能比较花, 可以直接下载demo运行)

<img src="https://github.com/iOS-ZZ/ZZResources/blob/master/ZZResources/ZZLayout/%E5%9E%82%E7%9B%B4.gif" width="212" height="365"><img src="https://github.com/iOS-ZZ/ZZResources/blob/master/ZZResources/ZZLayout/%E6%B5%AE%E5%8A%A8.gif" width="212" height="365"><img src="https://github.com/iOS-ZZ/ZZResources/blob/master/ZZResources/ZZLayout/%E6%B0%B4%E5%B9%B3.gif" width="212" height="365"><img src="https://github.com/iOS-ZZ/ZZResources/blob/master/ZZResources/ZZLayout/%E6%B7%B7%E5%90%88.GIF" width="212" height="365">


### 星星评价(gif帧数较多, 开始看起来比较卡,  加载完成后为具体效果, 真机&模拟器效果十分流畅粘手!)

<img src="https://github.com/iOS-ZZ/ZZResources/blob/master/ZZResources/ZZStarView/%E6%98%9F%E6%98%9F%E8%AF%84%E4%BB%B7.gif" width="212" height="365">

## 用法简介

### ZZLyout使用方法(瀑布流)

##### 建议使用以下方法初始化layou

```

ZZLayout *layout = [[ZZLayout alloc] initWith:ZZLayoutFlowTypeVertical delegate:self];

```
##### 以下协议方法根据瀑布流类型调用, 用法详见demo.
```

/**cell的宽(垂直瀑布流时此协议方法无效, 根据columnNumber和各种间距自适应)*/
- (CGFloat)layout:(ZZLayout *)layout widthForRowAtIndexPath:(NSIndexPath *)indexPath;

/**cell的高(水平瀑布流是此协议方法无效, 根据columnNumber和各种间距自适应)*/
- (CGFloat)layout:(ZZLayout *)layout heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**每个区多少列(浮动瀑布流时时此协议方法无效)*/
- (NSInteger)layout:(ZZLayout *)layout columnNumberAtSection:(NSInteger)section;

```

##### 以下协议方法可选择性实现.
```

/**每个区的边距(上左下右)*/
- (UIEdgeInsets)layout:(ZZLayout *)layout insetForSectionAtIndex:(NSInteger)section;

/**多种类型混合, 暂不支持水平, 可随意兼容垂直和浮动效果*/
- (ZZLayoutFlowType)layout:(ZZLayout *)layout layoutFlowTypeForSectionAtIndex:(NSInteger)section;

/**每个item行间距(如果为水平方向瀑布流, 这里则是左右间距)*/
- (NSInteger)layout:(ZZLayout *)layout lineSpacingForSectionAtIndex:(NSInteger)section;

/**每个item列间距(如果是水平方向瀑布流, 这里则是上下间距)*/
- (CGFloat)layout:(ZZLayout *)layout interitemSpacingForSectionAtIndex:(NSInteger)section;

/**header的size*/
- (CGSize)layout:(ZZLayout *)layout referenceSizeForHeaderInSection:(NSInteger)section;

/**footer的size*/
- (CGSize)layout:(ZZLayout *)layout referenceSizeForFooterInSection:(NSInteger)section;

/**本区区头和上个区区尾的间距*/
- (CGFloat)layout:(ZZLayout *)layout spacingWithLastSectionForSectionAtIndex:(NSInteger)section;

/**指定某个分区的"背景"颜色(从区头, 到区尾的空间, 不包含区头区尾)*/
- (UIColor *)layout:(ZZLayout *)layout colorForSection:(NSInteger)section;

```

### ZZStarView使用方法(星星评价)

##### 请使用以下初始化方法
```
//starView是一个ZZStarView类型的属性, 请自行实现
self.starView = [[ZZStarView alloc] initWithImage:[UIImage imageNamed:@"star"] selectImage:[UIImage imageNamed:@"didStar"] starWidth:20 starHeight:20 starMargin:5 starCount:5 callBack:^(CGFloat userGrade, CGFloat finalGrade) {
    NSLog(@"用户实际选择分 === %.2f, 最终分 === %.2f", userGrade, finalGrade);
}];
//此view宽高自适应, 设置frame时, 只需考虑q起点xy坐标
[self.view addSubview:self.starView];
self.starView.frame = CGRectMake(50, 150, self.starView.bounds.size.width, self.starView.bounds.size.height);
```

##### 一些可选的设置
```
self.starView.sublevel = 0.5;//默认值, 可以不写, 用户可选分值范围是0.5的倍数.(建议在设置分值之前确定此值)
self.starView.grade = [self.params[@"grade1"] floatValue];//设置分值, 可以不写, 默认显示0分.(self.params是UIViewController在ZZRouter中扩展的属性, 包含了所有参数)
self.starView.miniGrade = 0.5;//默认值, 可以不写 ,用户可以设置的最低分值.
```

## 特别鸣谢

部分思路来自其他开源库, 侵删, 联系qq:1156858877

特别鸣谢以下开源作者/开源工具

竖向瀑布流: [CustomLayout](https://github.com/JiWuChao/CustomLayout)

横向瀑布流: [ZZCollectionViewLayout](https://github.com/ZhouZhengzz/ZZCollectionViewLayout)

页面路由: [HHRouter](https://github.com/lightory/HHRouter)

实时FPS: [OttoFPSButton](https://github.com/WuOtto/OttoFPSButton)
