//
//  AFKDownloadManager.m
//  Funnies for iPad
//
//  Created by Marco Tabini on 10-08-16.
//  Copyright 2010 AFK Studio. All rights reserved.
//

#import "AFKDownloadManager.h"

@implementation AFKDownloadManager

@synthesize maximumWorkers;


#pragma mark -
#pragma mark Worker management


- (void) processQueue {
	if (liveWorkers.count < self.maximumWorkers) {
		
		if (queue.count) {
			
			AFKDownloadWorker *worker = [queue objectAtIndex:0];
			
			[liveWorkers addObject:worker];
			[queue removeObjectAtIndex:0];
			
			[worker start];
		}
		
	}
	
	if (liveWorkers.count) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kAFKDownloadManagerActivityStarted object:self];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:kAFKDownloadManagerActivityEnded object:self];
	}
}


- (void) workerIsDone:(AFKDownloadWorker *) worker {
	worker.downloadManager = Nil;
	[liveWorkers removeObject:worker];
	
	[self processQueue];
}


- (void) enqueueWorker:(AFKDownloadWorker *) worker atTopOfQueue:(BOOL) atTopOfQueue {
	if (atTopOfQueue) {
		[queue insertObject:worker atIndex:0];
	} else {
		[queue addObject:worker];
	}

	[self processQueue];
}


- (void) setMaximumWorkers:(int) value {
	maximumWorkers = value;
	[self processQueue];
}


#pragma mark -
#pragma mark Initialization and Memory Management


+ (AFKDownloadManager *) defaultManager {
	static AFKDownloadManager *globalInstance;
	
	if (!globalInstance) {
		globalInstance = [AFKDownloadManager new];
	}
	
	return globalInstance;
}


#pragma mark Memory based operations


// Main method


+ (void) queueDownloadFromURL:(NSURL *) url 
					   method:(NSString *) method 
			  queryParameters:(NSDictionary *) queryParameters 
			   HTTPParameters:(NSDictionary *) HTTPParameters 
				 atTopOfQueue:(BOOL) atTopOfQueue
			  completionBlock:(AFKDownloadWorkerTask) completionBlock {
	AFKDownloadManager *manager = [AFKDownloadManager defaultManager];
	
	AFKDownloadWorker *worker = [[AFKDownloadWorker new] autorelease];
	
	worker.url = url;
	worker.method = method;
	worker.queryParameters = queryParameters;
	worker.HTTPParameters = HTTPParameters;
	
	worker.downloadManager = manager;
	worker.completionTask = completionBlock;
	
	[manager enqueueWorker:worker atTopOfQueue:atTopOfQueue];
}


// Main method with target/selector


+ (void) queueDownloadFromURL:(NSURL *) url 
					   method:(NSString *) method 
			  queryParameters:(NSDictionary *) queryParameters 
			   HTTPParameters:(NSDictionary *) HTTPParameters 
				 atTopOfQueue:(BOOL) atTopOfQueue
					   target:(id) target 
					 selector:(SEL) selector {
	[AFKDownloadManager queueDownloadFromURL: url 
									  method: method 
							 queryParameters: queryParameters 
							  HTTPParameters: HTTPParameters 
								atTopOfQueue: atTopOfQueue
							 completionBlock: ^ (NSData *data) {
								 [target performSelector:selector withObject:data];
							 }];
}


// Convenience method (no method and HTTP parameters)


+ (void) queueDownloadFromURL:(NSURL *) url
			  queryParameters:(NSDictionary *) queryParameters
				 atTopOfQueue:(BOOL) atTopOfQueue
			  completionBlock:(AFKDownloadWorkerTask) completionBlock {
	[AFKDownloadManager queueDownloadFromURL:url method:@"GET" queryParameters:queryParameters HTTPParameters:Nil atTopOfQueue:atTopOfQueue completionBlock:completionBlock];
}


// Convenience method (no method and HTTP parameters) with target/selector


+ (void) queueDownloadFromURL:(NSURL *) url
			  queryParameters:(NSDictionary *) queryParameters
				 atTopOfQueue:(BOOL) atTopOfQueue
					   target:(id) target
					 selector:(SEL) selector	{
	[AFKDownloadManager queueDownloadFromURL: url 
									  method: @"GET" 
							 queryParameters: queryParameters 
							  HTTPParameters: Nil 
								atTopOfQueue: atTopOfQueue 
							 completionBlock: ^ (NSData *data) {
								 [target performSelector:selector withObject:data];
							 }];
}


#pragma mark File-based operations


+ (void) queueFileDownloadFromURL:(NSURL *) url 
						   method:(NSString *) method 
				  queryParameters:(NSDictionary *) queryParameters 
				   HTTPParameters:(NSDictionary *) HTTPParameters 
					 atTopOfQueue:(BOOL) atTopOfQueue 
				  completionBlock:(AFKDownloadFileWorkerTask) completionBlock {
	AFKDownloadManager *manager = [AFKDownloadManager defaultManager];
	
	AFKDownloadFileWorker *worker = [[AFKDownloadFileWorker new] autorelease];
	
	worker.url = url;
	worker.method = method;
	worker.queryParameters = queryParameters;
	worker.HTTPParameters = HTTPParameters;
	
	worker.downloadManager = manager;
	
	worker.fileCompletionTask = completionBlock;
	
	[manager enqueueWorker:worker atTopOfQueue:atTopOfQueue];
}


+ (void) queueFileDownloadFromURL:(NSURL *) url 
						   method:(NSString *) method 
				  queryParameters:(NSDictionary *) queryParameters 
				   HTTPParameters:(NSDictionary *) HTTPParameters 
					 atTopOfQueue:(BOOL) atTopOfQueue 
						   target:(id) target
						 selector:(SEL) selector {
	[AFKDownloadManager queueFileDownloadFromURL:url 
										  method:method 
								 queryParameters:queryParameters 
								  HTTPParameters:HTTPParameters 
									atTopOfQueue:atTopOfQueue 
								 completionBlock:^ (NSString *temporaryFileName) {
									 [target performSelector:selector withObject:temporaryFileName];
								 }];
}
	

+ (void) queueFileDownloadFromURL:(NSURL *) url 
				  queryParameters:(NSDictionary *) queryParameters 
					 atTopOfQueue:(BOOL) atTopOfQueue 
				  completionBlock:(AFKDownloadFileWorkerTask) completionBlock {
	[AFKDownloadManager queueFileDownloadFromURL:url 
										  method:@"GET"
								 queryParameters:queryParameters 
								  HTTPParameters:Nil
									atTopOfQueue:atTopOfQueue 
								 completionBlock:completionBlock];
}
	

+ (void) queueFileDownloadFromURL:(NSURL *) url 
				  queryParameters:(NSDictionary *) queryParameters 
					 atTopOfQueue:(BOOL) atTopOfQueue 
						   target:(id) target
						 selector:(SEL) selector {
	[AFKDownloadManager queueFileDownloadFromURL:url 
										  method:@"GET"
								 queryParameters:queryParameters 
								  HTTPParameters:Nil
									atTopOfQueue:atTopOfQueue 
								 completionBlock:^ (NSString *temporaryFileName) {
									 [target performSelector:selector withObject:temporaryFileName];
								 }];
}	
	
- (id) init {
	if (self = [super init]) {
		queue = [NSMutableArray new];
		liveWorkers = [NSMutableArray new];
		maximumWorkers = 5;
	}
	
	return self;
}


- (void) dealloc {
	[queue release];
	[liveWorkers release];
	
	[super dealloc];
}


@end
