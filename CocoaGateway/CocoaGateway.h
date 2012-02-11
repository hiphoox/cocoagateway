//
//  CocoaGateway.h
//  CocoaGateway
//
//  Created by Norberto Ortigoza on 2/6/12.
//  Copyright (c) 2012 Raku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

@interface CocoaGateway : NSObject

+ (id)sharedListener;
+ (void)listen;

@end
