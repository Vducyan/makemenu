#import "Quang.h"
#import "encrypt.h"
#import <Foundation/Foundation.h>
NSString * const __kHashDefaultValue = NSSENCRYPT("LDVQuang-wOUVDgP5erdZWvfaJuiI2Yy0jExA9BK873a4e265ca2d359be0d270a0f1e97727"); //token package
NSString * const __notificationTitle = NSSENCRYPT("Thông báo"); //Têu đề
NSString * const __notificationTitlenoidung = NSSENCRYPT("Hack fefe"); //Nội dung 
NSString * const __contact = NSSENCRYPT("Liên hệ"); //Nội dung nút liên hệ
NSString * const __Confirm = NSSENCRYPT("Xác nhận"); //Nội dung nút xác nhận
NSString * const __Input = NSSENCRYPT("Nhập Key Ở Đây"); //Nội dung ô nhập
//link liên hệ có thể đổi thành link vượt để gắn link kiếm tiền ở phần package trên server khi tạo package thì trên web có yêu cầu nhập link liên hệ thì đổi từ đó
