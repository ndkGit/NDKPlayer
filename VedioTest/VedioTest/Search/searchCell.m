//
//  searchCell.m
//  VedioTest
//
//  Created by nidangkun on 2017/6/1.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

#import "searchCell.h"
#import <UIImageView+WebCache.h>

@implementation searchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self layoutIfNeeded];

    self.placeHolderImg.tag = 101;
    
    [self cutRoundView:self.headImg];
    
    
    self.placeHolderImg.userInteractionEnabled = YES;
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.placeHolderImg addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.placeHolderImg);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
}


// 切圆角
- (void)cutRoundView:(UIImageView *)imageView {
    CGFloat corner = imageView.frame.size.width / 2;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
    shapeLayer.path = path.CGPath;
    imageView.layer.mask = shapeLayer;
}


- (void)setModel:(ZFVideoModel *)model {
    [self.placeHolderImg sd_setImageWithURL:[NSURL URLWithString:model.coverForFeed] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    self.contentTitleLab.text = model.title;
}

- (void)playVideo {
    //NSLog(@"dssdfdsf");
    if (self.playBlock) {
        self.playBlock();
    }
}

@end
