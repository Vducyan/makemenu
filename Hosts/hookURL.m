//  DrawHM
//
//  China Hacker Union
//  DrawHM  QQ 121118811
//  Created by 唐三 on 2021/12/9

#import "hookURL.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
@implementation NSURL (hook)

+ (void)load {
    // Lấy phương thức gốc
    Method originalMethod = class_getClassMethod([self class], @selector(URLWithString:));
    // Lấy phương thức thay thế
    Method swizzledMethod = class_getClassMethod([self class], @selector(hook_URLWithString:));
    // Hoán đổi hai phương thức
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+(instancetype)hook_URLWithString:(NSString *)Str
{
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer)     //定时器
    {
        NSString *filepath9= [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/reportnew.db"];
        NSFileManager *fileManager9= [NSFileManager defaultManager];
        [fileManager9 removeItemAtPath:filepath9 error:nil];
    }];   //匹配日志路径
    
    [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer)
    {
        NSString *filepath9= [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/garena"];
        NSFileManager *fileManager9= [NSFileManager defaultManager];
        [fileManager9 removeItemAtPath:filepath9 error:nil];
    }];   //内存检测路径1.
    
    NSString *filepath9= [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/MReplays"];
    NSFileManager *fileManager9= [NSFileManager defaultManager];
    [fileManager9 removeItemAtPath:filepath9 error:nil];
   



    //域名拦截
    if (
        [Str containsString:@"ff.garenna.vn"] ||
        [Str containsString:@"ff.garena.com"] ||
        [Str containsString:@"https://www.myip.com"] ||
        [Str containsString:@"https://www.checkip.com"] ||
        [Str containsString:@"https://www.whatismyipaddress.com"] ||
        [Str containsString:@"https://www.iplocation.net"] ||
        [Str containsString:@"https://ipinfo.io"] ||
        [Str containsString:@"https://www.whatismyip.com"] ||
        [Str containsString:@"msg.t-mobile.com"] ||
        [Str containsString:@"dav.orange.fr"] ||
        [Str containsString:@"https://report.ff.garena.com/"] ||
        [Str containsString:@"https://hotro.garena.vn/"] ||
        [Str containsString:@"https://forum.garena.vn/freefire"] ||
        [Str containsString:@"https://support.garena.vn/freefire"] ||
        [Str containsString:@"https://blog.garena.com"] ||
        [Str containsString:@"https://ff.garena.com/news"] ||
        [Str containsString:@"https://www.facebook.com/freefirevn"] ||
        [Str containsString:@"https://ff.garena.com"] ||
        [Str containsString:@"akamaihd.net"] ||
        [Str containsString:@"garenanow.com"] ||
        [Str containsString:@"akamaiedge.net"] ||
        [Str containsString:@"freefiremobile.com"] ||
        [Str containsString:@"dl.listdl.com"] ||
        [Str containsString:@"listdl.com"] ||
        [Str containsString:@"hocal.com"] ||
        [Str containsString:@"appsflyer.com"] ||
        [Str containsString:@"gopapi.io "] ||
        [Str containsString:@"1e100.net"] ||
        [Str containsString:@"ff.dr.grtc.garenanow.com"] ||
        [Str containsString:@"appsflyersdk.com"] ||
        [Str containsString:@"dl.dir.freefiremobile.com"] ||
        [Str containsString:@"csoversea.stronghold.freefiremobile.com"] ||
        [Str containsString:@"vn.event.freefiremobile.com"] ||
        [Str containsString:@"ff.sdk.grtc.garenanow.com"] ||
        [Str containsString:@"dl.listdl.com"] ||
        [Str containsString:@"gin.freefiremobile.com"] ||
        [Str containsString:@"dl.gmc.freefiremobile.com"] ||
        [Str containsString:@"firebase-settings.crashlytics.com"] ||
        [Str containsString:@"dl.cdn.freefiremobile.com"] ||
        [Str containsString:@"dl.aw.freefiremobile.com"] ||
        [Str containsString:@"dl.castle.freefiremobile.com"] ||
        [Str containsString:@"bc.googleusercontent.com"] ||
        [Str containsString:@"230.170.87.34.bc.googleusercontent.com"] ||
        [Str containsString:@"230.170.87.35.bc.googleusercontent.com"] ||
        [Str containsString:@"57.183.185.34.bc.googleusercontent.com"] ||
        [Str containsString:@"57.183.185.35.bc.googleusercontent.com"] ||
        [Str containsString:@"14.177.87.35.bc.googleusercontent.com"] ||
        [Str containsString:@"14.177.87.34.bc.googleusercontent.com"] ||
        [Str containsString:@"45.76.126.34.bc.googleusercontent.com"] ||
        [Str containsString:@"45.76.126.35.bc.googleusercontent.com"] ||
        [Str containsString:@"in-f.globh.com"] ||
        [Str containsString:@"freefiremobile.com"] ||
        [Str containsString:@"hackstorenew.bd.freefiremobile.com"] ||
        [Str containsString:@"csoversea.castle.freefiremobile.com"] ||
        [Str containsString:@"common.freefiremobile.com"] ||
        [Str containsString:@"version.common.freefiremobile.com"] ||
        [Str containsString:@"client.common.freefiremobile.com"] ||
        [Str containsString:@"dl.ctl.freefiremobile.com"] ||
        [Str containsString:@"dl.ctlin.freefiremobile.com"] ||
        [Str containsString:@"dl.cvs.freefiremobile.com"] ||
        [Str containsString:@"ind.event.freefiremobile.com"] ||
        [Str containsString:@"za.event.freefiremobile.com"] ||
        [Str containsString:@"bd.event.freefiremobile.com"] ||
        [Str containsString:@"sac.event.freefiremobile.com"] ||
        [Str containsString:@"fg.freefiremobile.com"] ||
        [Str containsString:@"dl.gcp.freefiremobile.com"] ||
        [Str containsString:@"dl.hw.freefiremobile.com"] ||
        [Str containsString:@"client.ind.freefiremobile.com"] ||
        [Str containsString:@"rampage3.ind.freefiremobile.com"] ||
        [Str containsString:@"dl.ks.freefiremobile.com"] ||
        [Str containsString:@"m.freefiremobile.com"] ||
        [Str containsString:@"test.maxcb.freefiremobile.com"] ||
        [Str containsString:@"za.network.freefiremobile.com"] ||
        [Str containsString:@"vn.network.freefiremobile.com"] ||
        [Str containsString:@"id.network.freefiremobile.com"] ||
        [Str containsString:@"bd.network.freefiremobile.com"] ||
        [Str containsString:@"mystery6shop.sea.freefiremobile.com"] ||

        [Str containsString:@"https://www.myip.com"]) {
        
        return [NSURL hook_URLWithString:@" "];
    } else {
        return [NSURL hook_URLWithString:Str];
    }
}

@end
