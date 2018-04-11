//
//  LaunchView.m
//  VedioTest
//
//  Created by nidangkun on 2017/8/7.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

#define kScreen_Bounds  [UIScreen mainScreen].bounds
#define kScreen_Height  [UIScreen mainScreen].bounds.size.height
#define kScreen_Width   [UIScreen mainScreen].bounds.size.width

#import "LaunchView.h"

@interface LaunchView ()

@end

@implementation LaunchView{
    UIProgressView *progress;
    UIImageView *bgImage;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self addViews];
    
    return self;
}

-(void)addViews{
    [self loadBackView];
    
    
    CGRect frame = kScreen_Bounds;
    CGFloat width = frame.size.width/2;
    CGFloat height = 20;
    frame.origin.x = (frame.size.width - width)/2;
    frame.origin.y = (frame.size.height - height)/2 + 50;
    frame.size.width=  width;
    frame.size.height = height;
    progress = [[UIProgressView alloc]initWithFrame:frame];
    progress.progress = 0;
    
    
    //[self.window insertSubview:progress atIndex:0];
    
    progress.progressTintColor = [UIColor redColor];
    
    [self addSubview:progress];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        //等DidFinished方法结束后,将其添加至window上(不然会检测是否有rootViewController)
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIApplication sharedApplication].delegate window] addSubview:self];
            [self removeSelfView];
        });
    }];
    
    
}

-(void)removeSelfView{
    
    [progress setProgress:0.1 animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [progress setProgress:1 animated:YES];
        } completion:^(BOOL finished) {
            [self doRemove];
        }];
    });
    
}

-(void)doRemove{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

-(void)loadBackView{
    bgImage = [[UIImageView alloc]initWithFrame:kScreen_Bounds];
    if ([self getLaunchImage]) {
        bgImage.image = [self getLaunchImage];
        [self addSubview:bgImage];
    }else{
        if ([self getLaunchSbView]) {
            [self addSubview:[self getLaunchSbView]];
        }else
            [self removeFromSuperview];
    
    }
}

#pragma mark - 获取启动页
- (UIImage *)getLaunchImage{
    UIImage *launchImage = [self assetsLaunchImage];
    if(launchImage) return launchImage;
    return [self storyboardLaunchImage];
}

#pragma mark - 获取Assets里LaunchImage
- (UIImage *)assetsLaunchImage{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";//横屏 @"Landscape"
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict){
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
            launchImageName = dict[@"UILaunchImageName"];
            UIImage *image = [UIImage imageNamed:launchImageName];
            return image;
        }
    }
    return nil;
}

#pragma mark - 获取Storyboard
-(UIView *)getLaunchSbView{
    UIView *view = nil;
    NSString *storyboardLaunchName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchStoryboardName"];
    UIViewController *sbLaunchVC = [[UIStoryboard storyboardWithName:storyboardLaunchName bundle:nil] instantiateInitialViewController];
    if (sbLaunchVC) { 
        view = sbLaunchVC.view;
    }
    return view;
}

- (UIImage *)storyboardLaunchImage{
    NSString *storyboardLaunchName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchStoryboardName"];
    UIViewController *sbLaunchVC = [[UIStoryboard storyboardWithName:storyboardLaunchName bundle:nil] instantiateInitialViewController];
    if(sbLaunchVC){
        UIView *view = sbLaunchVC.view;
        view.frame = kScreen_Bounds;
        
        return [self viewConvertImage:view];
    }
    return nil;
}
#pragma mark - 将View转成Image
- (UIImage*)viewConvertImage:(UIView*)launchView{
    CGSize imageSize = launchView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    [launchView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *launchImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return launchImage;
}

@end
