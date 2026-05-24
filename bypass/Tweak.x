// YTLBypass — minimal v2: hook only the validator (not the cosmetic surface).
//
// v1 nilled setAccessoryIcon:/setErrorText:/accessoryImage: globally, which may
// have interfered with YTLite's settings UI rendering even for non-paywall cells.
// v2 hooks ONLY setValidationHandler: — keep the cosmetic state alone, just ensure
// no cell ever has a validator block set, so all cells default to accessible.
//
// Also adds a runtime-swizzle backup: if YTLite reads `validationHandler` and the
// nil getter isn't enough, returning a no-op success block from a swizzled getter
// is the fallback.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DVNCell : NSObject
@property (nonatomic, copy) id validationHandler;
@end

%hook DVNCell

// Eat any incoming validation block.
- (void)setValidationHandler:(id)handler {
    %orig(nil);
}

// If anything checks the property back, it should see nil (no validator → cell is accessible).
- (id)validationHandler {
    return nil;
}

%end
