#import "Floating/mahoa.h"
// #import "KittyMemory/writeData.hpp"
// #import "KittyMemory/MemoryPatch.hpp"
// #include <substrate.h>
#include <mach-o/dyld.h>



// thanks to shmoo for the usefull stuff under this comment.
#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^
// #define HOOK(offset, ptr, orig) MSHookFunction((void *)getRealOffset(offset), (void *)ptr, (void **)&orig)
// #define HOOK_NO_ORIG(offset, ptr) MSHookFunction((void *)getRealOffset(offset), (void *)ptr, NULL)

// // Note to not prepend an underscore to the symbol. See Notes on the Apple manpage (https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/dlsym.3.html)
// #define HOOKSYM(sym, ptr, org) MSHookFunction((void*)dlsym((void *)RTLD_DEFAULT, sym), (void *)ptr, (void **)&org)
// #define HOOKSYM_NO_ORIG(sym, ptr)  MSHookFunction((void*)dlsym((void *)RTLD_DEFAULT, sym), (void *)ptr, NULL)
// #define getSym(symName) dlsym((void *)RTLD_DEFAULT, symName)

// // Convert hex color to UIColor, usage: For the color #BD0000 you'd use: UIColorFromHex(0xBD0000)
// #define UIColorFromHex(hexColor) [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1.0]

// uint64_t getRealOffset(uint64_t offset){
// 	return KittyMemory::getAbsoluteAddress(NULL, offset);
// }

uint64_t getRealOffset(uint64_t offset){
 return _dyld_get_image_vmaddr_slide(0) + offset;
}


// // Patching a offset without switch.
// void patchOffset(uint64_t offset, std::string hexBytes) {
// 	MemoryPatch patch = MemoryPatch::createWithHex(NULL, offset, hexBytes);
// 	if(!patch.isValid()){



// 		return;
// 	}
// 	if(!patch.Modify()) {



//     }
// }