//
//  DownloadManager.m
//  VedioTest
//
//  Created by nidangkun on 2017/6/5.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

#import "DownloadManager.h"
#import <ZFDownloadManager.h>
#import "DownLoadCell.h"
#import "DownLoadingCell.h"
#import "VedioPlayerVC.h"

#define zfDownLoad [ZFDownloadManager sharedDownloadManager]

@interface DownloadManager ()<UITableViewDelegate,UITableViewDataSource,ZFDownloadDelegate>

@property (strong, nonatomic) IBOutlet UITableView *downLoadTableView;

@property (atomic, strong ) NSMutableArray *downloadObjectArr;


@end

@implementation DownloadManager

- (void)viewDidLoad {
    [super viewDidLoad];
    _downLoadTableView.tableFooterView = [UIView new];
    
    _downLoadTableView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);

    zfDownLoad.downloadDelegate = self;
    
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [self initData];
    
}

- (void)initData {
    [zfDownLoad startLoad];
    NSMutableArray *downladed = zfDownLoad.finishedlist;
    NSMutableArray *downloading = zfDownLoad.downinglist;
    self.downloadObjectArr = @[].mutableCopy;
    [self.downloadObjectArr addObject:downladed];
    [self.downloadObjectArr addObject:downloading];
    [self.downLoadTableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = self.downloadObjectArr[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DownLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadedCell"];
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        cell.fileInfo = fileInfo;
        return cell;
    } else if (indexPath.section == 1) {
        DownLoadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadingCell"];
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        if (request == nil) { return nil; }
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        
        __weak typeof(self) weakSelf = self;
        // 下载按钮点击时候的要刷新列表
        cell.btnClickBlock = ^{
            [weakSelf initData];
        };
        // 下载模型赋值
        cell.fileInfo = fileInfo;
        // 下载的request
        cell.request = request;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        [zfDownLoad deleteFinishFile:fileInfo];
    }else if (indexPath.section == 1) {
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        [zfDownLoad deleteRequest:request];
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @[@"下载完成",@"下载中"][section];
}

#pragma mark - ZFDownloadDelegate

// 开始下载
- (void)startDownload:(ZFHttpRequest *)request {
    NSLog(@"开始下载!");
}

// 下载中
- (void)updateCellProgress:(ZFHttpRequest *)request {
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

// 下载完成
- (void)finishedDownload:(ZFHttpRequest *)request {
    [self initData];
}

// 更新下载进度
- (void)updateCellOnMainThread:(ZFFileModel *)fileInfo {
    
    //NSLog(@"fileInfo.speed==>>>%@",fileInfo.speed);
    
    
    NSArray *cellArr = [self.downLoadTableView visibleCells];
    for (id obj in cellArr) {
        if([obj isKindOfClass:[DownLoadingCell class]]) {
            DownLoadingCell *cell = (DownLoadingCell *)obj;
            
            if([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL]) {
                cell.fileInfo = fileInfo;
            }
            
        }
    }
}


- (IBAction)startAllDownLoad:(id)sender {
    [zfDownLoad startAllDownloads];
}

- (IBAction)stopAllDownLoad:(id)sender {
    [zfDownLoad pauseAllDownloads];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITableViewCell *cell            = (UITableViewCell *)sender;
    NSIndexPath *indexPath           = [self.downLoadTableView indexPathForCell:cell];
    
    ZFFileModel *model = self.downloadObjectArr[indexPath.section][indexPath.row];
    
    NSString *path                   = FILE_PATH(model.fileName);
    //NSURL *videoURL                  = [NSURL fileURLWithPath:path];
    
    VedioPlayerVC *movie = (VedioPlayerVC *)segue.destinationViewController;
    
    movie.vedioUrl = [NSURL fileURLWithPath:path];
    
    
}

@end
