//
//  ZZScrollView.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 16/10/24.
//  Copyright © 2016年 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZCollectionView : UICollectionView

typedef BOOL(^ZZScrollViewShouldBeginPanGestureHandler)(ZZCollectionView *collectionView, UIPanGestureRecognizer *panGesture);

- (void)setupScrollViewShouldBeginPanGestureHandler:(ZZScrollViewShouldBeginPanGestureHandler)gestureBeginHandler;

@end
