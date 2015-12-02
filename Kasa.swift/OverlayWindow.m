
#import "OverlayWindow.h"
#include <Carbon/Carbon.h>

// A bunch of defines to handle hotkeys - if command-return is pressed, we switch modes on the blue selection box (another overlay window), switching between vertical/horizontal tracking.
const UInt32 kMyHotKeyIdentifier = 'lasa';
const UInt32 kMyHotKey = 36; //the return key

EventHotKeyRef gMyHotKeyRef;
EventHotKeyID gMyHotKeyID;
EventHandlerUPP gAppHotKeyFunction;

pascal OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData);

@interface OverlayWindow (private)

- (void)switchDirection;

@end

// This routine is called when the command-return hotkey is pressed.  It means it's time to change modes for the blue selection box overlay window.

pascal OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData)
{
    OverlayWindow *window = (OverlayWindow *)userData;

    window.ignoresMouseEvents = !window.ignoresMouseEvents;

    return noErr;
}

@implementation OverlayWindow

// We override this initializer so we can set the NSBorderlessWindowMask styleMask, and set a few other important settings
- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag];
    
    if ( self )
    {
        [self setIgnoresMouseEvents:YES];
        [self setOpaque:NO]; // Needed so we can see through it when we have clear stuff on top
        [self setHasShadow:YES];
        [self setLevel:NSScreenSaverWindowLevel]; // Let's make it sit on top of everything else
    }
    
    contentRect.origin.x=100;
    contentRect.origin.y=100;
    
    return self;
}

- (void)awakeFromNib
{
    // Tracking areas need to be setup to handle when the mouse moves into or out of the main window
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:[[self contentView] bounds] 
                                                            options:NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways 
                                                            owner:self 
                                                            userInfo:nil];
    [[self contentView] addTrackingArea:trackingArea];
    [trackingArea release];

    if ( NSPointInRect([NSEvent mouseLocation],[self frame]) )
        [self mouseEntered:nil];
    else
        [self mouseExited:nil];

        // Start with vertical movement
    
        // Now lets go setup the hotkey handler, using Carbon APIs (there is no ObjC Cocoa HotKey API as of 10.7)
    EventTypeSpec eventType;
    
    gAppHotKeyFunction = NewEventHandlerUPP(MyHotKeyHandler);
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind  = kEventHotKeyPressed;
    
    InstallApplicationEventHandler(gAppHotKeyFunction, 1, &eventType, (void *)self, NULL);
    
    gMyHotKeyID.signature=kMyHotKeyIdentifier;
    gMyHotKeyID.id = 1;
    
    RegisterEventHotKey(kMyHotKey, cmdKey | shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
}

// Windows created with NSBorderlessWindowMask normally can't be key, but we want ours to be
//- (BOOL)canBecomeKeyWindow
//{
//    return YES;
//}

// Here we use NSWindow's -setFrame:display:animate: method to move the trackingWin one cell
// down/right.
- (void)moveCursor
{
    // Apply the new origin to the trackingWin.
    // Call this method again in 1 second to animate to the next state.
    [self performSelector:@selector(moveCursor) withObject:nil afterDelay:1];
}

// Switches the movement direction of the trackingWin
- (void)switchDirection
{
        // Stop any pending calls to -moveCursor since we may issue our own at the end
        // of this method.
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
        // Apply the new frame and animate the change.
    
    if ( NSPointInRect([NSEvent mouseLocation],[self frame]) )
        [self performSelector:@selector(moveCursor) withObject:nil afterDelay:1];
}

#pragma mark - Mouse

// If the mouse enters a window, go make sure we fade in
- (void)mouseEntered:(NSEvent *)theEvent
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

// If the mouse exits a window, go make sure we fade out
- (void)mouseExited:(NSEvent *)theEvent
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSRect  windowFrame = [self frame];
    initialLocation = [NSEvent mouseLocation];
    
    initialLocation.x -= windowFrame.origin.x;
    initialLocation.y -= windowFrame.origin.y;
}
- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint currentLocation;
    NSPoint newOrigin;
    
    NSRect  screenFrame = [[NSScreen mainScreen] frame];
    NSRect  windowFrame = [self frame];
    
    currentLocation = [NSEvent mouseLocation];
    newOrigin.x = currentLocation.x - initialLocation.x;
    newOrigin.y = currentLocation.y - initialLocation.y;
    if( (newOrigin.y+windowFrame.size.height) > (screenFrame.origin.y+screenFrame.size.height) ){
        newOrigin.y=screenFrame.origin.y + (screenFrame.size.height-windowFrame.size.height);
    }
    [self setFrameOrigin:newOrigin];
}

@end
