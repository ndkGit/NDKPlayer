//
//  DownLoadCell.h
//  VedioTest
//
//  Created by nidangkun on 2017/6/5.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFDownloadManager.h>

@interface DownLoadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *downLoadLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;

@property (nonatomic,strong) ZFFileModel *fileInfo;

@end
