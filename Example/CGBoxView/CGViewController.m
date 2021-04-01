//
//  CGViewController.m
//  CGBoxView
//
//  Created by chenggong on 04/01/2021.
//  Copyright (c) 2021 chenggong. All rights reserved.
//

#import "CGViewController.h"
#import <Masonry/Masonry.h>
#import <CGBoxView/CGBoxView.h>

#define kW self.view.frame.size.width
#define kH self.view.frame.size.height

@interface CGViewController ()
@property(nonatomic, strong) UIScrollView *sc;
@property(nonatomic, strong) CGBoxView *box;
@end

@implementation CGViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIView *last = self.sc.subviews.lastObject;
    [self.sc layoutIfNeeded];
    self.sc.contentSize = CGSizeMake(kW, CGRectGetMaxY(last.frame) + 50);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    self.sc = UIScrollView.new;
    self.sc.backgroundColor = UIColor.blackColor;
    self.sc.showsHorizontalScrollIndicator = false;
    self.sc.showsVerticalScrollIndicator = false;
    [self.view addSubview:self.sc];
    [self.sc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(kH);
    }];
    
    UIButton *btn = [self buttonCreat];
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = true;
    [btn setTitle:@"点击添加视图" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [self.sc addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.left.offset(40);
        make.top.offset(100);
        make.width.offset(kW - 80);
    }];
    
    UIButton *subBtn = [self buttonCreat];
    subBtn.layer.cornerRadius = 4;
    subBtn.layer.masksToBounds = true;
    [subBtn setTitle:@"减少一个视图" forState:UIControlStateNormal];
    [subBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [subBtn addTarget:self action:@selector(sub) forControlEvents:UIControlEventTouchUpInside];
    [self.sc addSubview:subBtn];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.left.offset(40);
        make.top.equalTo(btn.mas_bottom).offset(10);
        make.width.offset(kW - 80);
    }];
    
    
    CGBoxView *box = [[CGBoxView alloc] initWithColumn:4 count:15 items:^UIView *(int i, int col, int row, CGBoxView *view) {
        UIButton *item = [self buttonCreat];
        item.tag = i+100;
        [item setTitle:@(i).stringValue forState:UIControlStateNormal];
        return item;
    }];
    self.box = box;
    box.lineColor = UIColor.blackColor;
//    box.contentEdge = UIEdgeInsetsMake(10, 30, 80, 40);
    box.isFull = true;
//    box.fillColor = UIColor.blackColor;
    [self.sc addSubview:box];
    [box mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kW - 20);
        make.left.offset(10);
        make.top.equalTo(subBtn.mas_bottom).offset(50);
    }];


    UILabel *lab = UILabel.new;
    lab.textColor = UIColor.whiteColor;
    lab.font = [UIFont systemFontOfSize:16];
    lab.text = @"这是一个label 约束距顶部视图 20";
    [self.sc addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(box.mas_bottom).offset(20);
    }];
}

- (void)sub {
    [self.box cutItem:self.box.itemViews.lastObject];
}

- (void)add {
    UIButton *item = [self buttonCreat];
    item.tag = self.box.count + 100;
    [item setTitle:@(self.box.count).stringValue forState:UIControlStateNormal];
    [self.box addItem:item];
}


- (UIButton *)buttonCreat {
    UIButton *item = [[UIButton alloc] init];
    item.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f];
    item.titleLabel.font = [UIFont systemFontOfSize:16];
    [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return item;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
