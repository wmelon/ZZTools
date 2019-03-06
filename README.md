# 功能简介
自定义collectionView的layout, 提供垂直&amp;水平&amp;浮动瀑布流效果(可实现淘宝SKU选择的浮动效果).

# 使用方法

## 导入
1.可直接下载demo, 将ZZLyout文件夹下的ZZLyout.h&ZZLyout.m拖入工程中使用.

2.cocoapods集成可使用: pod 'ZZTools' ,若搜索不到可尝试先使用pod setup更新.

## 引用
```

#import "ZZTools.h"

```

# 效果展示

## 瀑布流部分

<img src="https://github.com/iOS-ZZ/ZZResources/blob/master/ZZResources/ZZLayout/%E5%9E%82%E7%9B%B4.gif" width="212" height="449"><img src="https://github.com/iOS-ZZ/ZZResources/blob/master/ZZResources/ZZLayout/%E6%B5%AE%E5%8A%A8.gif" width="212" height="449"><img src="https://github.com/iOS-ZZ/ZZResources/blob/master/ZZResources/ZZLayout/%E6%B0%B4%E5%B9%B3.gif" width="212" height="449">

# 用法简介

## ZZLyout使用方法(瀑布流)

#### 建议使用以下方法初始化layou

```

ZZLayout *layout = [[ZZLayout alloc] initWith:ZZLayoutFlowTypeVertical delegate:self];

```

#### 以下协议方法根据瀑布流类型调用, 用法详见demo.
```

/**cell的宽(垂直瀑布流时此协议方法无效, 宽度根据columnNumber和各种间距自适应)*/
- (CGFloat)layout:(ZZLayout *)collectionViewLayout widthForRowAtIndexPath:(NSIndexPath *)indexPath;

/**cell的高(水平瀑布流是此协议方法无效, 高度根据columnNumber和各种间距自适应)*/
- (CGFloat)layout:(ZZLayout *)collectionViewLayout heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**每个区多少列(浮动瀑布流时时此协议方法无效)*/
- (NSInteger)layout:(ZZLayout *)collectionViewLayout columnNumberAtSection:(NSInteger )section;

```

#### 以下协议方法可选择性实现.
```

/**每个区的边距(上左下右)*/
- (UIEdgeInsets)layout:(ZZLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

/**每个item行间距(如果为水平方向瀑布流, 这里则是左右间距)*/
- (NSInteger)layout:(ZZLayout *)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section;

/**每个item列间距(如果是水平方向瀑布流, 这里则是上下间距)*/
- (CGFloat)layout:(ZZLayout*)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section;

/**header的size*/
- (CGSize)layout:(ZZLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

/**footer的size*/
- (CGSize)layout:(ZZLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

/**本区区头和上个区区尾的间距*/
- (CGFloat)layout:(ZZLayout*)collectionViewLayout spacingWithLastSectionForSectionAtIndex:(NSInteger)section;

```

## ZZStarView使用方法(星星评价)

#### 请使用以下初始化方法
```
//starView是一个ZZStarView类型的属性, 请自行实现
self.starView = [[ZZStarView alloc] initWithImage:[UIImage imageNamed:@"star"] selectImage:[UIImage imageNamed:@"didStar"] starWidth:20 starHeight:20 starMargin:5 starCount:5 callBack:^(CGFloat userGrade, CGFloat finalGrade) {
    NSLog(@"用户实际选择分 === %.2f, 最终分 === %.2f", userGrade, finalGrade);
}];
//此view宽高自适应, 设置frame时, 只需考虑q起点xy坐标
[self.view addSubview:self.starView];
self.starView.frame = CGRectMake(50, 150, self.starView.bounds.size.width, self.starView.bounds.size.height);
```

#### 一些可选的设置
```
self.starView.sublevel = 0.5;//默认值, 可以不写, 用户可选分值范围是0.5的倍数.(建议在设置分值之前确定此值)
self.starView.grade = [self.params[@"grade1"] floatValue];//设置分值, 可以不写, 默认显示0分.(self.params是UIViewController在ZZRouter中扩展的属性, 包含了所有参数)
self.starView.miniGrade = 0.5;//默认值, 可以不写 ,用户可以设置的最低分值.
```

# 特别鸣谢

部分思路来自其他开源库, 侵删, 联系qq:1156858877

特别鸣谢以下开源作者/开源工具

竖向瀑布流:https://github.com/JiWuChao/CustomLayout

横向瀑布流:https://github.com/ZhouZhengzz/ZZCollectionViewLayout
