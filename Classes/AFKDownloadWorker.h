//
//  FIDownloadWorker.h
//  Funnies for iPad
//
//  Created by Marco Tabini on 10-08-16.
//  Copyright 2010 AFK Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^AFKDownloadWorkerTask)(NSData *data);



@class AFKDownloadManager;

@interface AFKDownloadWorker : NSObject {

	NSString *method;
	NSURL *url;
	NSDictionary *queryParameters;
	
	NSDictionary *HTTPParameters;
	
	AFKDownloadManager *downloadManager;

	AFKDownloadWorkerTask completionTask;

	BOOL running;
	
	NSURLConnection *urlConnection;
	NSMutableData *content;
	
}


@property (nonatomic,retain) NSString *method;

@property (nonatomic,retain) NSURL *url;
@property (nonatomic,retain) NSDictionary *queryParameters;

@property (nonatomic,retain) NSDictionary *HTTPParameters;

@property (nonatomic,retain) AFKDownloadManager *downloadManager;

@property (nonatomic,copy) AFKDownloadWorkerTask completionTask;

@property (nonatomic,readonly) BOOL running;

@property (nonatomic,retain) NSURLConnection *urlConnection;
@property (nonatomic,retain) NSMutableData *content;


- (void) start;


@end
