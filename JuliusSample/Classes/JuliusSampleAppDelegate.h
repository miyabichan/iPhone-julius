//
//  JuliusSampleAppDelegate.h
//  JuliusSample
//
//  Created by Watanabe Toshinori on 11/01/15.
//  Copyright 2011 FLCL.jp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JuliusSampleViewController;

@interface JuliusSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    JuliusSampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet JuliusSampleViewController *viewController;

@end

