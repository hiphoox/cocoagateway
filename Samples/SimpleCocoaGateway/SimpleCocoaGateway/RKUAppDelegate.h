//
//  RKUAppDelegate.h
//  SimpleCocoaGateway
//
//  Created by Norberto Ortigoza on 2/10/12.
//  Copyright (c) 2012 Raku. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKUViewController;

@interface RKUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RKUViewController *viewController;

@end
