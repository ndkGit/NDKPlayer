//
//  SearchTBVC.m
//  VedioTest
//
//  Created by nidangkun on 2017/6/1.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

#import "SearchTBVC.h"
#import <Masonry.h>

#import "ZFVideoModel.h"
#import "ZFVideoResolution.h"
#import <ZFDownload/ZFDownloadManager.h>
#import "ZFPlayer.h"
#import "searchCell.h"

@interface SearchTBVC ()<ZFPlayerDelegate>

@property (nonatomic, strong) NSMutableArray      *dataSource;

@property (nonatomic, strong) ZFPlayerView        *playerView;

@end

@implementation SearchTBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.001f)];
    
    self.tableView.tableHeaderView = emptyView;
    self.tableView.tableFooterView = emptyView;
    

    [self requestData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"searchCell";
    searchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    /*
    __block searchCell *sCell = cell;
    
    __block ZFVideoModel *model = self.dataSource[indexPath.row];
    
    __block NSIndexPath *blockIndexPath = indexPath;
    
    __weak typeof(self) weakSelf = self;
    
    __weak typeof(sCell) weakCell = sCell;
    
    sCell.model = model;
    
     sCell.playBlock = ^(){
         NSMutableDictionary *mtDic;
         for (ZFVideoResolution *resolution in model.playInfo) {
         [mtDic setObject:resolution.url forKey:resolution.name];
         }
         
         NSURL *firstUrl = [NSURL URLWithString:mtDic.allValues.firstObject];
         
         
         ZFPlayerModel *playerModel = [ZFPlayerModel new];
         playerModel.title = model.title;
         playerModel.videoURL = firstUrl;
         playerModel.placeholderImageURLString = model.coverForFeed;
         playerModel.scrollView = weakSelf.tableView;
         playerModel.indexPath = blockIndexPath;
         
         // 赋值分辨率字典
         playerModel.resolutionDic    = mtDic;
         playerModel.fatherViewTag = weakCell.placeHolderImg.tag;
         
         [weakSelf.playerView playerModel:playerModel delegate:self];
         
         weakSelf.playerView.hasDownload = YES;
         
         [weakSelf.playerView autoPlayTheVideo];
     
     };
     */
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    __block searchCell *sCell = (searchCell *)cell;
    
    __block ZFVideoModel *model = self.dataSource[indexPath.row];
    
    __block NSIndexPath *blockIndexPath = indexPath;
    
    __weak typeof(self) weakSelf = self;
    
    __weak typeof(sCell) weakCell = sCell;
    
    sCell.model = model;
    
    sCell.playBlock = ^(){
        NSMutableDictionary *mtDic = @{}.mutableCopy;
        for (ZFVideoResolution *resolution in model.playInfo) {
            [mtDic setObject:resolution.url forKey:resolution.name];
        }
        
        NSURL *firstUrl = [NSURL URLWithString:mtDic.allValues.firstObject];
        
        
        ZFPlayerModel *playerModel = [ZFPlayerModel new];
        playerModel.title = model.title;
        playerModel.videoURL = firstUrl;
        playerModel.placeholderImageURLString = model.coverForFeed;
        playerModel.scrollView = weakSelf.tableView;
        playerModel.indexPath = blockIndexPath;
    
        // 赋值分辨率字典
        playerModel.resolutionDic    = mtDic;
        playerModel.fatherViewTag = weakCell.placeHolderImg.tag;
        
        
        [weakSelf.playerView playerModel:playerModel delegate:self];
        
        weakSelf.playerView.hasDownload = YES;
        
        [weakSelf.playerView autoPlayTheVideo];
        
    };

    
    
}


#pragma mark -LazyInit
-(ZFPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        //_playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
    }
    return _playerView;
}

- (void)requestData {
    
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"videoData" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *videoList = rootDict[@"videoList"];
    self.dataSource = @[].mutableCopy;
    for (NSDictionary *dataDic in videoList) {
        ZFVideoModel *model = [ZFVideoModel new];
        [model setValuesForKeysWithDictionary:dataDic];
        [self.dataSource addObject:model];
    }
    
}

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
}


@end
