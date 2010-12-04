//
//  AFKDownloadManager.h
//  Funnies for iPad
//
//  Created by Marco Tabini on 10-08-16.
//  Copyright 2010 AFK Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFKDownloadWorker.h"
#import "AFKDownloadFileWorker.h"

#define kAFKDownloadManagerActivityStarted @"kAFKDownloadManagerActivityStarted"
#define kAFKDownloadManagerActivityEnded @"kAFKDownloadManagerActivityEnded"


@class AFKDownloadWorker;

@interface AFKDownloadManager : NSObject {
	
	NSMutableArray *queue;
	
	NSMutableArray *liveWorkers;

	int maximumWorkers;
	
}


@property (nonatomic,assign) int maximumWorkers;


+ (AFKDownloadManager *) defaultManager;

// Memory operations

+ (void) queueDownloadFromURL:(NSURL *) url 
					   method:(NSString *) method 
			  queryParameters:(NSDictionary *) queryParameters 
			   HTTPParameters:(NSDictionary *) HTTPParameters 
				 atTopOfQueue:(BOOL) atTopOfQueue
			  completionBlock:(AFKDownloadWorkerTask) completionBlock;

+ (void) queueDownloadFromURL:(NSURL *) url 
					   method:(NSString *) method 
			  queryParameters:(NSDictionary *) queryParameters 
			   HTTPParameters:(NSDictionary *) HTTPParameters 
				 atTopOfQueue:(BOOL) atTopOfQueue
					   target:(id) target 
					 selector:(SEL) selector;

+ (void) queueDownloadFromURL:(NSURL *) url
			  queryParameters:(NSDictionary *) queryParameters
				 atTopOfQueue:(BOOL) atTopOfQueue
			  completionBlock:(AFKDownloadWorkerTask) completionBlock;

+ (void) queueDownloadFromURL:(NSURL *) url
			  queryParameters:(NSDictionary *) queryParameters
				 atTopOfQueue:(BOOL) atTopOfQueue
					   target:(id) target
					 selector:(SEL) selector;


// File operations


+ (void) queueFileDownloadFromURL:(NSURL *) url 
						   method:(NSString *) method 
				  queryParameters:(NSDictionary *) queryParameters 
				   HTTPParameters:(NSDictionary *) HTTPParameters 
					 atTopOfQueue:(BOOL) atTopOfQueue 
				  completionBlock:(AFKDownloadFileWorkerTask) completionBlock;
	
+ (void) queueFileDownloadFromURL:(NSURL *) url 
						   method:(NSString *) method 
				  queryParameters:(NSDictionary *) queryParameters 
				   HTTPParameters:(NSDictionary *) HTTPParameters 
					 atTopOfQueue:(BOOL) atTopOfQueue 
						   target:(id) target
						 selector:(SEL) selector;

+ (void) queueFileDownloadFromURL:(NSURL *) url 
				  queryParameters:(NSDictionary *) queryParameters 
					 atTopOfQueue:(BOOL) atTopOfQueue 
				  completionBlock:(AFKDownloadFileWorkerTask) completionBlock;
	
+ (void) queueFileDownloadFromURL:(NSURL *) url 
				  queryParameters:(NSDictionary *) queryParameters 
					 atTopOfQueue:(BOOL) atTopOfQueue 
						   target:(id) target
						 selector:(SEL) selector;
	

- (void) workerIsDone:(AFKDownloadWorker *) worker;


@end
