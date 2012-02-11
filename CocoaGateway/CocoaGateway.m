//
//  CocoaGateway.m
//  CocoaGateway
//
//  Created by Norberto Ortigoza on 2/6/12.
//  Copyright (c) 2012 Raku. All rights reserved.
//

#import "CocoaGateway.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyHTTPConnection.h"
#include "JavascriptCore.h"
#import "JavascriptCore-dlsym.h"
#import "JSCocoaController.h"

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface CocoaGateway ()
{
	HTTPServer *httpServer;
}

- (void)setupListener;

@end


@implementation CocoaGateway

+ (id)sharedListener {
  static CocoaGateway *me = 0x00;

  if (!me) {
    me = [[CocoaGateway alloc] init];
  }
  
  return me;
}

+ (void)listen {
  [[self sharedListener] setupListener];
}

- (void)setupListener {
  
  // Fetch JS symbols
  [JSCocoaSymbolFetcher populateJavascriptCoreSymbols];
  
  // Load iPhone bridgeSupport
  [[BridgeSupportController sharedController] loadBridgeSupport:[NSString stringWithFormat:@"%@/iPhone.bridgesupport", [[NSBundle mainBundle] bundlePath]]];
  // Load js class kit
  id c = [JSCocoaController sharedController];

  // Configure our logging framework.
  // To keep things simple and fast, we're just going to log to the Xcode console.
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
	
	// Create server using our custom MyHTTPServer class
	httpServer = [[HTTPServer alloc] init];
	
	// Tell the server to broadcast its presence via Bonjour.
	// This allows browsers such as Safari to automatically discover our service.
	[httpServer setType:@"_http._tcp."];
	
	// Normally there's no need to run our server on any specific port.
	// Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
	// However, for easy testing you may want force a certain port so you can just hit the refresh button.
	[httpServer setPort:59123];
  
  // We're going to extend the base HTTPConnection class with our MyHTTPConnection class.
	// This allows us to do all kinds of customizations.
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	
	// Serve files from our embedded Web folder
	NSString *webPath = [[NSBundle mainBundle] resourcePath];
	DDLogInfo(@"Setting document root: %@", webPath);
	
	[httpServer setDocumentRoot:webPath];
	
	// Start the server (and check for problems)
	
	NSError *error;
	if(![httpServer start:&error])
	{
		DDLogError(@"Error starting HTTP Server: %@", error);
	}
  
}

@end
