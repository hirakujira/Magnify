#include <substrate.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface PSViewController : UIViewController
@end

@interface PSListController : PSViewController
@end

@interface PSMagnifyController : PSListController
@end

@interface PSMagnifyMode : NSObject
+ (id)magnifyModeWithSize:(CGSize)arg1 name:(id)arg2 localizedName:(id)arg3 isZoomed:(bool)arg4;
// - (id)copyWithZone:(struct _NSZone { }*)arg1;
- (void)dealloc;
- (unsigned long long)hash;
- (bool)isEqual:(id)arg1;
- (bool)isZoomed;
- (id)localizedName;
- (id)name;
- (id)previewHTMLStrings;
- (id)previewStyleSheets;
- (void)setLocalizedName:(id)arg1;
- (void)setName:(id)arg1;
- (void)setPreviewHTMLStrings:(id)arg1;
- (void)setPreviewStyleSheets:(id)arg1;
- (void)setSize:(CGSize)arg1;
- (void)setZoomed:(bool)arg1;
- (CGSize)size;
@end

%hook __NSArrayI
- (id)objectAtIndex:(NSUInteger)index {
    if ([self count] == 2 && index == 2) {
        id obejct = [self objectAtIndex:1];
        if ([obejct isKindOfClass:%c(PSMagnifyMode)]) {
            id obejct2 = [obejct copy];
            [obejct2 setZoomed:YES];
            [obejct2 setSize:CGSizeMake(320*3,568*3)];
            [obejct2 setName:@"Magnify+"];
            [obejct2 setLocalizedName:@"Magnify+"];
            self = (__NSArrayI *)[[NSArray alloc] initWithObjects:[self firstObject],[self objectAtIndex:1],obejct2,nil];
            // NSLog(@"magnifyArray %@",self);
            return obejct2;
        }
    }
    return %orig;
}
%end

%hook PSMagnifyController
-(void)loadView {
    %orig;
    UISegmentedControl *_magnifyModePicker = MSHookIvar<UISegmentedControl *>(self, "_magnifyModePicker");
    // NSMutableDictionary *_webViewsForMagnifyMode = MSHookIvar<NSMutableDictionary *>(self, "_webViewsForMagnifyMode");
    // NSLog(@"%@",_webViewsForMagnifyMode);
    if (_magnifyModePicker.numberOfSegments == 2) {
        [_magnifyModePicker insertSegmentWithTitle:@"Magnify+" atIndex:2 animated:NO];
    }
}
%end
//==============================================================================
%ctor {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    %init;
    [pool release];
}
