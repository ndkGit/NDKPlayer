//
//  VedioPlayerVCViewController.m
//  VedioTest
//
//  Created by nidangkun on 2017/5/25.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

#import "VedioPlayerVC.h"
#import <Masonry.h>
#import "UINavigationController+ZFFullscreenPopGesture.h"
#import "ZFPlayer.h"
#import <ZFDownloadManager.h>


@interface VedioPlayerVC ()<ZFPlayerDelegate>

@property (strong, nonatomic) ZFPlayerView *playerView;

@property (nonatomic,strong) ZFPlayerModel *playerModel;
@property (weak, nonatomic) IBOutlet UIView *fatherPlayView;


@property (nonatomic, assign) BOOL isPlaying;
@end

@implementation VedioPlayerVC{
    //UIView *playerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        self.playerView.playerPushedOrPresented = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        //        [self.playerView pause];
        self.playerView.playerPushedOrPresented = YES;
    }
}

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}


- (void)viewDidLoad {
    //[self.navigationController.navigationBar setHidden: YES];
    [super viewDidLoad];
    
    
    self.zf_prefersNavigationBarHidden = YES;
    // Do any additional setup after loading the view.

    
    
    // 自动播放，默认不自动播放
    [self.playerView autoPlayTheVideo];
    
    
    
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}


-(BOOL)prefersStatusBarHidden{
    return ZFPlayerShared.isStatusBarHidden;
}

#pragma mark -LazyInit

-(ZFPlayerModel *)playerModel{
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = @"这里设置视频标题";
        _playerModel.videoURL         = self.vedioUrl;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.fatherPlayView;
    }
    return _playerModel;
}

-(ZFPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [ZFPlayerView new];
        [_playerView playerModel:self.playerModel delegate:self];
        self.playerView.hasPreviewView = YES;
        _playerView.hasDownload = YES;
    }
    return _playerView;
}



- (IBAction)playNewVedio:(id)sender {
    self.playerModel.title = @"This is the new Vedio";
    
    [self.playerView resetToPlayNewVideo:self.playerModel];
    
}

#pragma mark -ZFPlayerDelegate

-(void)zf_playerBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
}



@end
