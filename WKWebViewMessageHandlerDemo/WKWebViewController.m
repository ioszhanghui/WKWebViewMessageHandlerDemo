//
//  WKWebViewController.m
//  WKWebViewMessageHandlerDemo
//
//  Created by reborn on 16/9/12.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>

@interface WKWebViewController ()<WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic, strong)WKWebView *webView;
@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"WKWebViewMessageHandler";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initWKWebView];
}

- (void)initWKWebView
{

    //创建并配置WKWebView的相关参数
    //1.WKWebViewConfiguration:是WKWebView初始化时的配置类，里面存放着初始化WK的一系列属性；
    //2.WKUserContentController:为JS提供了一个发送消息的通道并且可以向页面注入JS的类，WKUserContentController对象可以添加多个scriptMessageHandler；
    //3.addScriptMessageHandler:name:有两个参数，第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象。添加一个脚本消息的处理器,同时需要在JS中添加，window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用。
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    [userContentController addScriptMessageHandler:self name:@"PostParam"];
    [userContentController addScriptMessageHandler:self name:@"Send"];
    
    configuration.userContentController = userContentController;
    
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    NSString * url=@"http://127.0.0.1/test.html";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    
    self.webView.UIDelegate = self;
    
    [self.view addSubview:self.webView];
}

#pragma mark -- WKScriptMessageHandler
/**
 *  JS 调用 OC 时 webview 会调用此方法
 *
 *  @param userContentController  webview中配置的userContentController 信息
 *  @param message                JS执行传递的消息
 */

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //JS调用OC方法
    
    //message.boby就是JS里传过来的参数
    NSLog(@"body:%@",message.body);
    
    if ([message.name isEqualToString:@"PostParam"]) {
        NSLog(@"name:%@    sex:%@",[message.body objectForKey:@"name"],[message.body objectForKey:@"sex"]);
       
        
    } else if ([message.name isEqualToString:@"Send"]) {
        
        NSLog(@"我被执行了");
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
