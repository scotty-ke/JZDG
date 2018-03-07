//
//  DDWebViewController.m
//  NagriHealth
//
//  Created by 丁东 on 2016/11/21.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import "DDWebViewController.h"
#import <WebKit/WebKit.h>
@interface DDWebViewController ()<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *_webView;
    
    UIProgressView *_progressView;
    
    NSUInteger _loadCount;
}


@end

@implementation DDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATOR_HEIGHT)];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [self.view addSubview:_webView];
    [self addObserver];
    if (_url)
    {
        [self loadViewWithUrl:_url];
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        _progressView.progressTintColor = TOPCAIL_COLOR;
        _progressView.trackTintColor = WHITE_COLOR;
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
        _progressView.transform = transform;
        [self.view addSubview:_progressView];
    }
}

-(void)addObserver
{
    [_webView addObserver:self
               forKeyPath:@"estimatedProgress"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
}

-(void)loadViewWithUrl:(NSURL*)url
{
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
}


- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context
{
        
    if (object == _webView && [keyPath isEqualToString:@"estimatedProgress"])
    {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            _progressView.hidden = YES;
            [_progressView setProgress:0 animated:NO];
        }
        else
        {
            _progressView.hidden = NO;
            [_progressView setProgress:newprogress animated:YES];
        }
    }
}

- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    
    if (loadCount == 0) {
        _progressView.hidden = YES;
        [_progressView setProgress:0 animated:NO];
    }else {
        _progressView.hidden = NO;
        CGFloat oldP = _progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [_progressView setProgress:newP animated:YES];
        
    }
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    _loadCount ++;
}
// 内容返回时
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    _loadCount --;
}
//失败
- (void)webView:(WKWebView *)webView didFailNavigation: (null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    _loadCount --;
    NSLog(@"%@",error);
}

-(void)dealloc
{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
