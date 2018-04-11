//
//  DownLoadingCell.h
//  VedioTest
//
//  Created by nidangkun on 2017/6/5.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFDownloadManager.h>

typedef void(^ZFBtnClickBlock)(void);

@interface DownLoadingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileNameLab;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (weak, nonatomic) IBOutlet UILabel *progressLab;

@property (weak, nonatomic) IBOutlet UILabel *speedLab;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;


/** 下载按钮点击回调block */
@property (nonatomic, copy  ) ZFBtnClickBlock  btnClickBlock;
/** 下载信息模型 */
@property (nonatomic, strong) ZFFileModel      *fileInfo;
/** 该文件发起的请求 */
@property (nonatomic,retain ) ZFHttpRequest    *request;
@end
