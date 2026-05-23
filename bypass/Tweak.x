// YTLBypass — disables the runtime paywall validation in YTLite 5.2.x.
//
// YTLite 5.2 introduced a server-side access check that runs whenever the user tries
// to change settings. The gating UX surface lives on `DVNCell.validationHandler` —
// a block property the dev sets on each "paid" cell. When the user taps the cell,
// the framework invokes that block, which hits a remote endpoint and only allows
// the change if the device is whitelisted.
//
// Strategy: short-circuit the gating UX. Force `setValidationHandler:` to ignore
// incoming blocks → every cell ends up with no validator → cells default to the
// "no check needed" path → toggles persist.
//
// Also defang the lock-icon and error-text paths so the UI doesn't show "subscribe
// required" messaging for cells that previously had validators.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DVNCell : NSObject
@property (nonatomic, copy) id validationHandler;
@property (nonatomic, strong) UIImage *accessoryIcon;
@property (nonatomic, strong) NSString *errorText;
@end

@interface DVNTableViewController : UIViewController
@end

%hook DVNCell

// Eat any incoming validation block — cell has no validator → defaults to accessible.
- (void)setValidationHandler:(id)handler {
    %orig(nil);
}

// In case some code reads it back and conditions on non-nil, return nil too.
- (id)validationHandler {
    return nil;
}

// Don't render the lock icon. The accessoryIcon parameter on cell factories is used
// to display a small badge next to gated rows; nilling it removes the lock UI.
- (void)setAccessoryIcon:(UIImage *)icon {
    %orig(nil);
}

// Don't render error text like "Subscribe to use this feature".
- (void)setErrorText:(NSString *)text {
    %orig(nil);
}

%end

%hook DVNTableViewController

// The lock icon next to settings rows comes through here. Return nil for everything.
- (UIImage *)accessoryImage:(id)arg {
    return nil;
}

%end
