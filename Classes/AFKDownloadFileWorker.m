//
//  AFKDownloadFileWorker.m
//  AFKLoadManager
//
//  Created by Marco Tabini on 10-12-04.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import "AFKDownloadFileWorker.h"
#import "AFKDownloadManager.h"


@implementation AFKDownloadFileWorker
@synthesize temporaryFileName;


#pragma mark -
#pragma mark Download management


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData {
	[handle writeData:newData];
}



- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	[self.downloadManager workerIsDone:self];
	[self.target performSelector:self.selector withObject:temporaryFileName];
}


#pragma mark -
#pragma mark Initialization and memory management


- (id) init {
	if ((self = [super init])) {
		
		// We synchronize this so that we can save the name of the auto-generate temporary file
		
		@synchronized(self) {
			NSString *template = [NSString stringWithFormat:@"%@AFKLMXXXXXXXXXXXXX", NSTemporaryDirectory()];
			char *cTemplate = (char *) [template cStringUsingEncoding:NSASCIIStringEncoding];
			mktemp(cTemplate);
			
			temporaryFileName = [[NSString stringWithCString:cTemplate encoding:NSASCIIStringEncoding] retain];
			
			[[NSFileManager defaultManager] createFileAtPath:temporaryFileName contents:Nil attributes:Nil];
			handle = [[NSFileHandle fileHandleForUpdatingAtPath:temporaryFileName] retain];
		}
	}

	return self;
}


- (void) dealloc {
	[handle closeFile];
	[handle release];
	
	[[NSFileManager defaultManager] removeItemAtPath:temporaryFileName error:Nil];
	[temporaryFileName release];
	
	[super dealloc];
}


@end
