//
//  ViewController.m
//  VedioTest
//
//  Created by nidangkun on 2017/5/25.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

#import "ViewController.h"
#import "VedioPlayerVC.h"

@interface ViewController ()

//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray     *dataSource;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"fdsfsadfasd==>>>>%@",self.navigationItem.titleView.frame);
    
    self.navigationItem.titleView.backgroundColor = [UIColor redColor];
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.001f)];
    
    self.tableView.tableHeaderView = emptyView;
    self.tableView.tableFooterView = emptyView;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -17, 0);
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.dataSource = @[@"http://7xqhmn.media1.z0.glb.clouddn.com/femorning-20161106.mp4",
                        @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
                        @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
                        @"http://baobab.wdjcdn.com/14525705791193.mp4",
                        @"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
                        @"http://baobab.wdjcdn.com/1455968234865481297704.mp4",
                        @"http://baobab.wdjcdn.com/1455782903700jy.mp4",
                        @"http://baobab.wdjcdn.com/14564977406580.mp4",
                        @"http://baobab.wdjcdn.com/1456316686552The.mp4",
                        @"http://baobab.wdjcdn.com/1456480115661mtl.mp4",
                        @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                        @"http://baobab.wdjcdn.com/1455614108256t(2).mp4",
                        @"http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4",
                        @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4",
                        @"http://baobab.wdjcdn.com/1456734464766B(13).mp4",
                        @"http://baobab.wdjcdn.com/1456653443902B.mp4",
                        @"http://baobab.wdjcdn.com/1456231710844S(24).mp4"];
    
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark -UITableViewDataSource &UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"listCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
   
    cell.textLabel.text = [NSString stringWithFormat:@"网络视频%ld",indexPath.row+1];
    
    return cell;
}




-(BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    VedioPlayerVC *playerVC = segue.destinationViewController;
    
    UITableViewCell *cell = sender;
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    
    playerVC.vedioUrl = [NSURL URLWithString:self.dataSource[index.row]];
    
}


@end
