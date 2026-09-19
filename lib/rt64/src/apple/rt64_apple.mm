#include "rt64_apple.h"

#import <Foundation/Foundation.h>
#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

const char* GetHomeDirectory() {
    return strdup([NSHomeDirectory() UTF8String]);
}

CocoaWindow::CocoaWindow(void* window)
    : windowHandle(window), cachedRefreshRate(0) {
    cachedAttributes = {0, 0, 0, 0};

    if ([NSThread isMainThread]) {
        updateWindowAttributesInternal(false);
        updateRefreshRateInternal(false);
    } else {
        updateWindowAttributesInternal(true);
        updateRefreshRateInternal(true);
    }
}

CocoaWindow::~CocoaWindow() {}

void CocoaWindow::updateWindowAttributesInternal(bool forceSync) {
    auto updateBlock = ^{
#if TARGET_OS_IPHONE
        UIView *view = (__bridge UIView *)windowHandle;
        CGRect contentFrame = view.bounds;
        // RT64's swap-chain dimensions are pixel dimensions. UIKit view bounds
        // are measured in points, so reporting them directly makes rendering
        // cover only one quarter of a Retina drawable (half each dimension).
        UIScreen *screen = view.window.screen ?: UIScreen.mainScreen;
        const CGFloat contentScale = MAX(screen.scale, 1.0);
#else
        NSWindow *nsWindow = (__bridge NSWindow *)windowHandle;
        NSRect contentFrame = [[nsWindow contentView] frame];
        const CGFloat contentScale = 1.0;
#endif

        std::lock_guard<std::mutex> lock(attributesMutex);
        cachedAttributes.x = static_cast<int>(contentFrame.origin.x);
        cachedAttributes.y = static_cast<int>(contentFrame.origin.y);
        cachedAttributes.width = static_cast<int>(contentFrame.size.width * contentScale);
        cachedAttributes.height = static_cast<int>(contentFrame.size.height * contentScale);
    };

    if (forceSync) {
        dispatch_sync(dispatch_get_main_queue(), updateBlock);
    } else if ([NSThread isMainThread]) {
        updateBlock();
    } else {
        dispatch_async(dispatch_get_main_queue(), updateBlock);
    }
}

void CocoaWindow::updateRefreshRateInternal(bool forceSync) {
    auto updateBlock = ^{
#if TARGET_OS_IPHONE
        cachedRefreshRate.store(static_cast<int>([UIScreen mainScreen].maximumFramesPerSecond));
#else
        NSWindow *nsWindow = (__bridge NSWindow *)windowHandle;
        NSScreen *screen = [nsWindow screen];
        if (@available(macOS 12.0, *)) {
            cachedRefreshRate.store(static_cast<int>([screen maximumFramesPerSecond]));
        }
#endif
    };

    if (forceSync) {
        dispatch_sync(dispatch_get_main_queue(), updateBlock);
    } else if ([NSThread isMainThread]) {
        updateBlock();
    } else {
        dispatch_async(dispatch_get_main_queue(), updateBlock);
    }
}

void CocoaWindow::getWindowAttributes(CocoaWindowAttributes* attributes) const {
    if ([NSThread isMainThread]) {
        const_cast<CocoaWindow*>(this)->updateWindowAttributesInternal(false);
    }

    {
        std::lock_guard<std::mutex> lock(attributesMutex);
        *attributes = cachedAttributes;
    }

    if (![NSThread isMainThread]) {
        const_cast<CocoaWindow*>(this)->updateWindowAttributesInternal(false);
    }
}

int CocoaWindow::getRefreshRate() const {
    if ([NSThread isMainThread]) {
        const_cast<CocoaWindow*>(this)->updateRefreshRateInternal(false);
    }

    const int rate = cachedRefreshRate.load();
    if (![NSThread isMainThread]) {
        const_cast<CocoaWindow*>(this)->updateRefreshRateInternal(false);
    }
    return rate;
}

void CocoaWindow::toggleFullscreen() {
#if !TARGET_OS_IPHONE
    if ([NSThread isMainThread]) {
        NSWindow *nsWindow = (__bridge NSWindow *)windowHandle;
        [nsWindow toggleFullScreen:NULL];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSWindow *nsWindow = (__bridge NSWindow *)windowHandle;
            [nsWindow toggleFullScreen:NULL];
        });
    }
#endif
}
