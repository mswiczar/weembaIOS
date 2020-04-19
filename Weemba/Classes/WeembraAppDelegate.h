//
//  WeembraAppDelegate.h
//  Weembra
//
//  Created by Moises Swiczar on 12/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSLogin;

@interface WeembraAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MSLogin *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

