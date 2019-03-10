//
//  AppDelegate.m
//  iOS_GetUDID_Demo
//
//  Created by 黄云碧 on 2019/3/10.
//  Copyright © 2019 黄云碧. All rights reserved.
//

#import "AppDelegate.h"
#import "SFWebServer.h"

@interface AppDelegate ()
{
    UIBackgroundTaskIdentifier _bgTask;
    
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    SFWebServer *server = [SFWebServer startWithPort:6699];
    [server router:@"GET" path:@"/udid.get" handler:^SFWebServerRespone *(SFWebServerRequest *request) {
        NSString *config = [[NSBundle mainBundle] pathForResource:@"udid" ofType:@"mobileconfig"];
        SFWebServerRespone *response = [[SFWebServerRespone alloc]initWithFile:config];
        response.contentType =  @"application/x-apple-aspen-config";
        return response;
    }];
    
    [server router:@"POST" path:@"/receive.do" handler:^SFWebServerRespone *(SFWebServerRequest *request) {
        
        NSString *raw = [[NSString  alloc]initWithData:request.rawData encoding:NSISOLatin1StringEncoding];
        NSString *plistString = [raw substringWithRange:NSMakeRange([raw rangeOfString:@"<?xml"].location, [raw rangeOfString:@"</plist>"].location + [raw rangeOfString:@"</plist>"].length)];
        
        NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[plistString dataUsingEncoding:NSISOLatin1StringEncoding] options:NSPropertyListImmutable format:nil error:nil];
        NSString *str = [NSString stringWithFormat:@"%@",plist];


        NSLog(@"device info%@",plist);
        SFWebServerRespone *response = [[SFWebServerRespone alloc]initWithHTML:@"success"];
        //值得注意的是重定向一定要使用301重定向,有些重定向默认是302重定向,这样就会导致安装失败,设备安装会提示"无效的描述文件
        response.statusCode = 301;
        response.location = [NSString stringWithFormat:@"iOS-UDID-Demo://?info=%@",str];
        return response;
    }];
    [server router:@"GET" path:@"/show.do" handler:^SFWebServerRespone *(SFWebServerRequest *request) {
        SFWebServerRespone *response = [[SFWebServerRespone alloc]initWithHTML:@"success"];
        return response;
    }];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    _bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:self->_bgTask];
        self->_bgTask = UIBackgroundTaskInvalid;
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSString *urlStr = [url absoluteString];
    urlStr = [urlStr stringByRemovingPercentEncoding];
    if ([urlStr containsString:@"info="]) {
        NSString *plistString = [[urlStr componentsSeparatedByString:@"info="] lastObject];

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"获取设备信息成功" message:plistString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];

    }
    return YES;
}
@end
