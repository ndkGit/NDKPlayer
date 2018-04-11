//
//  CollectionViewCell.h
//  VedioTest
//
//  Created by nidangkun on 2017/6/2.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFVideoModel.h"

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *playBtn;
/** model */
@property (nonatomic, strong) ZFVideoModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (nonatomic, copy  ) void(^playBlock)();

@end
