
#import <Cocoa/Cocoa.h>

@interface OverlayWindow : NSWindow
{
    NSPoint initialLocation;
}
@property (assign) IBOutlet NSTextField *informationLabel;

@end
