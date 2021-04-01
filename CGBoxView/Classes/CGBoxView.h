//
//  CGBoxView.h
//  test
//
//  Created by rainbow on 2021/4/1.
//

#import <UIKit/UIKit.h>

@class CGBoxView;
typedef UIView *(^CGBoxViewItems)(int index, int column, int row, CGBoxView *view);

@interface CGBoxView : UIView

/// 列数
@property(nonatomic, assign) int column;

/// item的个数
@property(nonatomic, assign) int count;

/// 分割线的宽度 (默认: 1)
@property(nonatomic, assign) CGFloat lineWidth;

/// 分割线的颜色 (默认: grayColor)
@property(nonatomic, strong) UIColor *lineColor;

/// 内边距 (默认: (1, 1, 1, 1))
@property(nonatomic, assign) UIEdgeInsets contentEdge;

/// 每个视图之间的 行间距 (默认: 1)
@property(nonatomic, assign) CGFloat itemMarginX;

/// 每个视图之间的 列间距 (默认: 1)
@property(nonatomic, assign) CGFloat itemMarginY;

/// 是否补空
@property(nonatomic, assign) BOOL isFull;

/// 补空视图的颜色
@property(nonatomic, strong) UIColor *fillColor;

/// 设置每个视图
@property(nonatomic, copy) CGBoxViewItems items;

/// 添加一个视图
- (void)addItem:(UIView *)item;

/// 消除一个视图
- (void)cutItem:(UIView *)item;

/// 所有子视图的合集
@property(nonatomic, strong, readonly) NSArray *itemViews;


/// 初始化防滑
/// @param column 列数
/// @param count 一共有多少个
/// @param items 设置每个格子的视图
- (instancetype)initWithColumn:(int)column count:(int)count items:(CGBoxViewItems)items;

@end
