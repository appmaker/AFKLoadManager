//
//  AFKDownloadFileWorker.h
//  AFKLoadManager
//
//  Created by Marco Tabini on 10-12-04.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFKDownloadWorker.h"


typedef void (^AFKDownloadFileWorkerTask)(NSString *temporaryFileName);



@interface AFKDownloadFileWorker : AFKDownloadWorker {

	NSString *temporaryFileName;
	NSFileHandle *handle;
	
	AFKDownloadFileWorkerTask fileCompletionTask;
}


@property (nonatomic,retain,readonly) NSString *temporaryFileName;

@property (nonatomic,copy) AFKDownloadFileWorkerTask fileCompletionTask;


@end
