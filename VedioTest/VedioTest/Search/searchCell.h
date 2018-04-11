//
//  searchCell.h
//  VedioTest
//
//  Created by nidangkun on 2017/6/1.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"
#import "ZFVideoModel.h"

@interface searchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *contentTitleLab;

@property (weak, nonatomic) IBOutlet UIImageView *placeHolderImg;

@property (nonatomic, strong) UIButton                      *playBtn;
/** model */
@property (nonatomic, strong) ZFVideoModel                  *model;


/** 播放按钮block */
@property (nonatomic, copy  ) void(^playBlock)();

@end
