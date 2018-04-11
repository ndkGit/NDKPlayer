//
//  DownLoadCell.m
//  VedioTest
//
//  Created by nidangkun on 2017/6/5.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

#import "DownLoadCell.h"

@implementation DownLoadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFileInfo:(ZFFileModel *)fileInfo {
    _fileInfo = fileInfo;
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    self.downLoadLab.text = fileInfo.fileName;
    self.sizeLab.text = totalSize;
}

@end
