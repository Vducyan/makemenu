#import "LIB/Esp/ImGuiDrawView.h"
#include <mach-o/dyld.h>
#include <mach-o/getsect.h>
#include <mach/mach.h>
#include <math.h> // Thêm dòng này
#import <Foundation/Foundation.h>
#import "Include.h"
#include <vector>
#include <thread>
#include "hook/hook.h"
#include "RequireESP/Vector3.h"
#include "RequireESP/Vector2.h"
#include "RequireESP/Quaternion.h"
#include "RequireESP/Monostring.h"
#include "RequireESP/Esp.h"
#import "JRMemory.framework/Headers/MemScan.h"
#import <UIKit/UIKit.h>




UIWindow *mainWindow;
UIButton *menuView;
@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;


- (void)ghost;
- (void)removeGhost; 
- (void)switchIsChanged:(UISwitch *)SW1;
- (void)text;
@end

@implementation ImGuiDrawView
static bool MenDeal = true;

static bool bo1 = false;
static bool bo2 = false;
static bool bo3 = false;
static bool bo4 = false;
BOOL hasGhostBeenDrawn = NO; // Biến cờ kiểm soát việc vẽ menu Ghost

using namespace std;
std::string string_format(const std::string fmt, ...) {
    std::vector<char> str(100,'\0');
    va_list ap;
    while (1) {
        va_start(ap, fmt);
        auto n = vsnprintf(str.data(), str.size(), fmt.c_str(), ap);
        va_end(ap);
        if ((n > -1) && (size_t(n) < str.size())) {
            return str.data();
        }
        if (n > -1)
            str.resize( n + 1 );
        else
            str.resize( str.size() * 2);
    }
    return str.data();
}

-(void)text{
mainWindow = [[UIApplication


sharedApplication] keyWindow];
CGRect screenBounds = [[UIScreen mainScreen] bounds];
CGFloat screenWidth = CGRectGetWidth(screenBounds);
CGFloat screenHeight = CGRectGetHeight(screenBounds); // Thêm dòng này để tính screenHeight

// Tạo label và căn lề phía dưới bên trái
UILabel *t = [[UILabel alloc] init];
[t setBackgroundColor:[UIColor clearColor]];
t.layer.cornerRadius = 10;
t.textAlignment = NSTextAlignmentLeft;

NSString *encodedString = @"4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI4paI";
NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:encodedString options:0];
NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];

NSLog(@"Decoded string: %@", decodedString);

NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:decodedString];
NSUInteger length = attributedText.length;
NSArray<UIColor *> *colors = @[[UIColor blackColor]];
for (NSUInteger i = 0; i < length; i++) {
    UIColor *color = colors[i % colors.count];
    [attributedText addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(i, 1)];
}

UIFont *font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:8];
[attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, length)];

[t setAttributedText:attributedText];
[t sizeToFit];

// Xác định vị trí căn lề phía dưới bên trái cho label
CGFloat labelX = 8.5;
CGFloat labelY = screenHeight - CGRectGetHeight(t.frame) - 2;
CGRect labelFrame = CGRectMake(labelX, labelY, CGRectGetWidth(t.frame), CGRectGetHeight(t.frame));
[t setFrame:labelFrame];

[mainWindow addSubview:t];


UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 40, 300, 20)];
myLabel.textColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.4 alpha:1.0];
myLabel.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:17];
myLabel.numberOfLines = 1;
myLabel.text = [NSString stringWithFormat:@""];
myLabel.textAlignment = NSTextAlignmentCenter;
myLabel.shadowColor = [UIColor whiteColor];
myLabel.shadowOffset = CGSizeMake(1.0,1.0); 
myLabel.backgroundColor = [UIColor clearColor];

[mainWindow addSubview:myLabel];

}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

    if (!self.device) abort();

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); 
    (void)io;
    
    SetDarkThemeColors();
    io.ConfigWindowsMoveFromTitleBarOnly = true;
    io.IniFilename = NULL;
    static const ImWchar icons_ranges[] = { 0xf000, 0xf3ff, 0 };
    ImFontConfig icons_config;
    ImFontConfig CustomFont;
    CustomFont.FontDataOwnedByAtlas = false;
    icons_config.MergeMode = true;
    icons_config.PixelSnapH = true;
    icons_config.OversampleH = 7;
    icons_config.OversampleV = 7;
    NSString *FontPath = @"/System/Library/Fonts/Core/AvenirNext.ttc";
    io.Fonts->AddFontFromFileTTF(FontPath.UTF8String, 40.f,NULL,io.Fonts->GetGlyphRangesVietnamese());
    io.Fonts->AddFontFromMemoryCompressedTTF(font_awesome_data, font_awesome_size, 25.0f, &icons_config, icons_ranges);
    ImGui_ImplMetal_Init(_device);

    return self;
}
// Định nghĩa hàm timer trong file .m
- (void)timer:(NSTimeInterval)interval block:(void (^)(void))block {
    // Sử dụng NSTimer để gọi block sau khoảng thời gian
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(executeBlock:) userInfo:[block copy] repeats:NO];
}

- (void)executeBlock:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();  // Thực thi block
    }
}

-(void)ghost{
mainWindow = [[UIApplication sharedApplication] keyWindow];

menuView = [[UIButton alloc]initWithFrame: CGRectMake(305, 265, 58, 54)];
menuView.transform = CGAffineTransformMakeScale(1.0, 1.0);                          
menuView.alpha = 1.0f;
menuView.layer.borderColor = [[UIColor clearColor] CGColor];
menuView.layer.borderWidth = 0.0f;
menuView.layer.cornerRadius = 13;
menuView.layer.borderColor = [[UIColor cyanColor] CGColor];
menuView.layer.borderWidth = 1.5f;
menuView.alpha = 1.0f;
menuView.layer.shadowOpacity = 0;
menuView.layer.shadowColor = [UIColor clearColor].CGColor;
menuView.layer.shadowRadius = 0;
[menuView addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
[mainWindow addSubview:menuView];


UILabel *tsw = [[UILabel alloc] initWithFrame:CGRectMake(7, 1, 72, 20.8)];
tsw.textColor = [UIColor colorWithRed:255.0/255.0 green:105.0/255.0 blue:180.0/255.0 alpha:1.0];
tsw.font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:11];
tsw.numberOfLines = 1;
tsw.text = [NSString stringWithFormat:@"Cam Cao"];
tsw.shadowColor = [UIColor clearColor];
tsw.shadowOffset = CGSizeMake(1.1,1.1); 
tsw.backgroundColor = [UIColor clearColor];

[menuView addSubview:tsw];

  UISwitch *sw1 = [[UISwitch alloc] 
initWithFrame: CGRectMake(3.5, 20, 51, 31)];

sw1.layer.borderWidth = 2.5;
sw1.layer.cornerRadius = 5.0;
sw1.layer.borderColor = [UIColor clearColor].CGColor;
sw1.transform = CGAffineTransformMakeScale(1.00, 1.00);
sw1.backgroundColor = [UIColor clearColor];
sw1.layer.cornerRadius = 16;
sw1.thumbTintColor = [UIColor whiteColor];
sw1.onTintColor = [UIColor greenColor];
    [sw1 addTarget:self                action:@selector(switchIsChanged:)                forControlEvents:UIControlEventValueChanged];

    [menuView addSubview:sw1];

hasGhostBeenDrawn = YES; // Đánh dấu menu đã được vẽ

}
- (void)switchIsChanged:(UISwitch *)SW1 {
    
    if ([SW1 isOn]) {
 static dispatch_once_t onceToken;
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
   camcao = true;
});
}
else{
       static dispatch_once_t onceToken;
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
   camcao = false;
     });
}
}
-(void)removeGhost { // Hàm xoá menu Ghost
    if (menuView) {
        [menuView removeFromSuperview];
        menuView = nil;
        hasGhostBeenDrawn = NO; // Đánh dấu menu đã bị xoá
    }
}

+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}

- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}

- (void)loadView{
    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;
    [self text];
}


#pragma mark - Interaction

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}
bool camcao = false;
int CAMCAO(void *instance) {
     if (camcao) {
         return 1;
     }else{
    return 0;
}
}

bool Norecoill = false;
int norecoil(void *instance) {
     if (Norecoill) {
         return 99;
     }else{
    return 1;
}
}




float camxa = 60; 
int CamXa(void *instance) {
    if (camxa > 0.0) {
        return 100.0; 
    } else {
        return 60.0;
    }
}



bool CHUV = true;
int chuV(void *instance) {
     if (CHUV) {
         return 1;
     }else{
    return 0;
}
}
bool NAPDANNHANH = false;
float napdannhanh(void *instance) {
     if (NAPDANNHANH) {
         return 90.0;
     }else{
    return 1.0;
}
}

bool m4a1 = false;
bool xs = false;
bool dame = false;
bool ok = false;
bool tinhyeu = false;
bool luc = false;
bool ngongao = false;
bool aomd = false;
bool macdinh = false;
bool ts = false;
bool namdam = false;
bool ak = false;
bool scar = false;
bool xm8 = false;
bool ump = false;
bool m1014 = false;
bool mp5 = false;
bool an94 = false;
bool nrc = false;
bool db = false;
bool x2 = false;
bool famas = false;
bool m1887 = false;
bool mp40 = false;
bool cc = false; 
bool danthang = false;
bool Aimlock = false;
bool speedx30 = false;
bool rss = false;
bool aimscopev2 = false;
bool tawm = false;
#pragma mark - MTKViewDelegate
#define iPhonePlus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

- (void)drawInMTKView:(MTKView*)view {
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;
    CGFloat framebufferScale = view.window.screen.scale ?: UIScreen.mainScreen.scale;
    if (iPhonePlus) {
        io.DisplayFramebufferScale = ImVec2(2.60, 2.60);
    }else{
        io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    }
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 120);
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];

    if (MenDeal == true) {
        [self.view setUserInteractionEnabled:YES];
    } else if (MenDeal == false) {
        [self.view setUserInteractionEnabled:NO];
    }

    MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder pushDebugGroup:@"ImGui Jane"];

        ImGui_ImplMetal_NewFrame(renderPassDescriptor);
        ImGui::NewFrame();

        ImFont* font = ImGui::GetFont();
        font->Scale = 18.f / font->FontSize;
        
        CGFloat x = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width) - 500) / 2;
        CGFloat y = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height) - 290) / 2;

        ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
        ImGui::SetNextWindowSize(ImVec2(500, 320), ImGuiCond_FirstUseEver);

        if (MenDeal) {
                    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
 std::string Bundle([bundleIdentifier UTF8String]);
 NSString *safari_localizedShortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:NSSENCRYPT("CFBundleShortVersionString")];
 std::string Version([safari_localizedShortVersion UTF8String]);
 NSString *safari_displayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:NSSENCRYPT("CFBundleDisplayName")];
 std::string sName([safari_displayName UTF8String]);
                    std::string namedv = [[UIDevice currentDevice] name].UTF8String;
            NSDate *now = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE dd/MM/yyyy"];
            NSString *dateString = [dateFormatter stringFromDate:now];

            UIDevice *device = [UIDevice currentDevice];
            device.batteryMonitoringEnabled = YES;

            float batteryLevel = device.batteryLevel * 100;
            
            ImGui::Begin(ENCRYPT("CanhiOSCrack VN"), &MenDeal);
            if (ImGui::BeginTabBar("FuncTabBar")) {

                if (ImGui::BeginTabItem(ENCRYPT(ICON_FA_EYE"Esp + AimBot"))) {

                    ImGui::BeginGroupPanel("Esp", ImVec2(470, 0));
                ImGui::Checkbox("Draw Esp", &ESPEnable);
                ImGui::SameLine(150);  


                ImGui::Checkbox("Line", &ESPLine); 

                ImGui::Checkbox("Box", &ESPBox);

                ImGui::Checkbox("Tên", &ESPName); 
ImGui::SameLine(150);
                
ImGui::Checkbox("Máu", &ESPHealth); 
ImGui::SameLine();
                ImGui::Spacing();

                
ImGui::Checkbox("Số Lượng ", &ESPCount);
                  
                    ImGui::Checkbox("AIM", &aim180);

ImGui::Checkbox("Aim Scope", &minh3);

ImGui::Checkbox("Aim Fire", &minh2);

ImGui::Checkbox("Fov", &Fov);
                    
ImGui::SliderFloat("FOV 360", &AimbotFOV, 0.0f, 360.0f, "%.0f");

ImGui::SameLine(150);

                    
ImGui::EndGroupPanel();
                    ImGui::EndTabItem();
                }
        

                if (ImGui::BeginTabItem(ENCRYPT(ICON_FA_COGS "Cài Đặt"))) {
                    ImGui::BeginGroupPanel("Mua Hack IB Tele : @canhioscrack", ImVec2(470, 0));


                    if (ImGui::Button("Fix Login")) {
                        // Ẩn mtkView khi nhấn nút
                        self.mtkView.hidden = YES;
                        MenDeal = NO;  // Thay đổi trạng thái của MenDeal

                        // Đặt timer để phục hồi lại mtkView và cập nhật MenDeal sau một khoảng thời gian
                        [self timer:99 block:^{
                            self.mtkView.hidden = NO;  // Hiển thị lại mtkView
                            MenDeal = YES;  // Cập nhật lại trạng thái MenDeal
                        }];
                    }

                    ImGui::EndGroupPanel();
                    ImGui::EndTabItem();
                }



            
            ImGui::EndTabBar();
            }
            ImGui::End();
            
        }
        if (cc && !hasGhostBeenDrawn) { // Kiểm tra cc và biến cờ
            [self ghost];
        } else if (!cc) {
            [self removeGhost];
        }
        
        DrawEsp();
        ImDrawList* draw_list = ImGui::GetBackgroundDrawList();
        ImGui::Render();
        ImDrawData* draw_data = ImGui::GetDrawData();
        ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);

        [renderEncoder popDebugGroup];
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    [commandBuffer commit];
}


void hooking() {
    void* address[] = {  
        (void*)getRealOffset(ENCRYPTOFFSET("0x103E526F0")), 
        (void*)getRealOffset(ENCRYPTOFFSET("0x10529A408")), 
        (void*)getRealOffset(ENCRYPTOFFSET("0x103851DC4")),
        // (void*)getRealOffset(ENCRYPTOFFSET("0x1040D1ABC")), 
        (void*)getRealOffset(ENCRYPTOFFSET("0x1051D1F94")),
        (void*)getRealOffset(ENCRYPTOFFSET("0x1040D6610")),
        (void*)getRealOffset(ENCRYPTOFFSET("0x1052620FC"))  
    };
    void* function[] = {
        (void*)CamXa,
        (void*)Update,
        (void*)chuV,
        // (void*)noaim1,  
        (void*)norecoil,  
        (void*)napdannhanh,
        (void*)OnDestroy
    };
    hook(address, function, 6);

    Local = (bool (*)(void *))getRealOffset(ENCRYPTOFFSET("0x105258C80"));                           
    Team = (bool (*)(void *))getRealOffset(ENCRYPTOFFSET("0x10526D118"));                               
    get_CurHP = (int (*)(void *))getRealOffset(ENCRYPTOFFSET("0x1052A8A30"));                            
    get_MaxHP = (int(*)(void *))getRealOffset(ENCRYPTOFFSET("0x1052A8AD8"));                           
    get_position = (Vector3(*)(void *))getRealOffset(ENCRYPTOFFSET("0x105F3D46C"));                   
    WorldToViewpoint = (Vector3(*)(void *, Vector3, int))getRealOffset(ENCRYPTOFFSET("0x105EF6394"));   
    get_main = (void *(*)())getRealOffset(ENCRYPTOFFSET("0x105EF6D08"));                                
    get_transform = (void *(*)(void *))getRealOffset(ENCRYPTOFFSET("0x105EF8D78"));    
}

void *hack_thread(void *) {
    sleep(5);
    hooking();
    pthread_exit(nullptr);
    return nullptr;
}

void __attribute__((constructor)) initialize() {
    pthread_t hacks;
    pthread_create(&hacks, NULL, hack_thread, NULL);
}
- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size{}

@end
