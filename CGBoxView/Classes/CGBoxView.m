//
//  CGBoxView.m
//  test
//
//  Created by rainbow on 2021/4/1.
//

#import "CGBoxView.h"
#import <Masonry/Masonry.h>

@interface CGBoxView ()
@property(nonatomic, strong) UIView *fillView;
@property(nonatomic, strong) UIScrollView *contenView;
@property(nonatomic, strong) NSArray *itemViews;
@end

@implementation CGBoxView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configParam];
    }
    return self;
}

- (instancetype)initWithColumn:(int)column count:(int)count items:(CGBoxViewItems)items {
    if (self == [super init]) {
        [self configParam];
        self.items = items;
        self.column = column;
        self.count = count;
        [self setupUI];
    }
    return self;
}

- (void)configParam {
    self.backgroundColor = UIColor.whiteColor;
    _lineWidth = 1;
    _lineColor = UIColor.grayColor;
    _contentEdge = UIEdgeInsetsMake(1, 1, 1, 1);
    _itemMarginX = 1;
    _itemMarginY = 1;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.contenView.backgroundColor = lineColor;
}

- (void)setContentEdge:(UIEdgeInsets)contentEdge {
    _contentEdge = contentEdge;
    [self.contenView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(contentEdge.left);
        make.right.offset(-contentEdge.right);
        make.top.offset(contentEdge.top);
        make.bottom.offset(-contentEdge.bottom);
    }];
}

- (void)setupUI {
    if (self.count <= 0 || self.column <= 0) {
        return;
    }
    
    [self.contenView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self addSubview:self.contenView];
    [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(self.contentEdge.left);
        make.right.offset(-self.contentEdge.right);
        make.top.offset(self.contentEdge.top);
        make.bottom.offset(-self.contentEdge.bottom);
    }];
    
    for (int i = 0; i < self.count; i++) {
        int row = i % self.column;   // ???????????????
        int col = i / self.column;   // ???????????????
        UIView *item = self.items(i, col, row, self);
        item == nil ?: [self.contenView addSubview:item];
    }
    self.itemViews = self.contenView.subviews;
}

- (void)cutItem:(UIView *)item {
    self.count--;
    [item removeFromSuperview];
    self.itemViews = self.contenView.subviews;
    [self layoutSubviews];
}

- (void)addItem:(UIView *)item {
    self.count++;
    [self.contenView addSubview:item];
    self.itemViews = self.contenView.subviews;
    [self layoutSubviews];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat gapX = self.itemMarginX;  //???????????????????????????
    CGFloat gapY = self.itemMarginY;  //???????????????????????????

    [self layoutIfNeeded];

    CGFloat viewWidth = self.contenView.bounds.size.width; //???????????????
    CGFloat itemWidth = (viewWidth - (self.column -1)*gapX)/self.column*1.0f; //???????????? ??? ????????????????????? ?????????????????????????????????????????????????????????

    UIView *last = nil;

    for (int i = 0; i < self.contenView.subviews.count; i++) {
        UIView *item = self.contenView.subviews[i];

        int row = i % self.column;   // ???????????????
        int col = i / self.column;   // ???????????????

        [item mas_remakeConstraints:^(MASConstraintMaker*make) {
            make.size.mas_equalTo(CGSizeMake(itemWidth, itemWidth));
            make.top.offset(col * (itemWidth + gapY));
            make.left.offset(row * (itemWidth + gapX));
        }];
        
        last = item;
    }
    
    // ??????view
    int num = self.count%self.column;
    CGFloat lineWidth = num == 1 ? self.column * gapX : num *gapX;
    CGFloat lastWidth = num == 0 ? itemWidth : (self.column - num + 1)*itemWidth + lineWidth;
    
    if (num != 0 && self.fillColor) {
        [self.fillView removeFromSuperview];
        self.fillView.backgroundColor = self.fillColor;
        [self.contenView addSubview:self.fillView];
        [self.fillView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.top.equalTo(last);
            make.left.equalTo(last.mas_right).offset(gapX);
            make.width.offset(lastWidth);
        }];

        last = self.fillView;
    }
    
    [last mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        if (self.isFull && !self.fillColor) {
            make.width.offset(lastWidth);
        }
    }];
    
    [self.contenView layoutIfNeeded];
    [self.contenView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(CGRectGetMaxY(last.frame));
    }];
}

- (UIView *)fillView {
    if (!_fillView) {
        _fillView = UIView.new;
        _fillView.backgroundColor = UIColor.whiteColor;
    }
    return _fillView;
}

- (UIScrollView *)contenView {
    if (!_contenView) {
        _contenView = UIScrollView.new;
        _contenView.backgroundColor = UIColor.grayColor;
        _contenView.showsHorizontalScrollIndicator = false;
        _contenView.showsVerticalScrollIndicator = false;
    }
    return _contenView;
}


@end
