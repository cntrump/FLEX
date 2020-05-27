//
//  FLEXDylib.m
//  FLEXDylib
//
//  Created by v on 2020/5/27.
//  Copyright © 2020 Flipboard. All rights reserved.
//

@import FLEX;

@interface FLEXLoader : NSObject

@end

@implementation FLEXLoader

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showFLEX:)
                                                      name:UIApplicationDidBecomeActiveNotification
                                                    object:nil];
    }

    return self;
}

- (void)showFLEX:(NSNotification *)notification {
    [self show];
}

- (void)show {
    BOOL isMain = NSThread.isMainThread;
    dispatch_block_t block = ^{
        [FLEXManager.sharedManager showExplorer];
    };

    if (isMain) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@end

__attribute__((constructor))
static void initialize(void) {
    NSLog(@"======================= libFlex dylib initialize ========================");

    static dispatch_once_t onceToken = 0;
    static FLEXLoader *loader = nil;
    dispatch_once(&onceToken, ^{
        loader = [[FLEXLoader alloc] init];
    });
}
