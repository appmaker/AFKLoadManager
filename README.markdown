AFKLoadManager
==============

AFKLoadManager helps you manage an arbitrary number of downloading operations via HTTP[S] asynchronously from your iOS app by:

* Limiting the maximum number of downloads so as not to overload the connection
* Performing all downloads asynchronously, without blocking your app, while managing errors for you
* Calling an arbitrary selector when a download completes (successfully or not)
* Passing along arbitrary HTTP parameters to the server (e.g.: Referer, etc.)
* Saving data to file as it is being loaded to minimize memory consumption

The idea behind AFKLoadManager is to provide a little more functionality than the built in -xxxWithURL: methods. It's simple and easy to use, uses only two classes and can be used on any iOS device.

Additionally, AFKLoadManager places all the downloads requested of it in a queue, allowing only a given number of them to occur at any given time (the default is five).


Important
---------

Version 1.0 of AFKDownloadManager (tagged as v1.0 in the repository) is now obsolete. The current version works with iOS 4.0 and higher, supports downloading to file and provides a block-based interface


Usage
-----

The usage is very simple:

* Import AFKLoadManager.h
* Call one of the download queueing methods in AFKLoadManager
* Await a call to your block or callback method when the download is complete

Enqueueing a request
--------------------

Requests are enqueued using one of two families of AFKDownloadManager class methods:

	+ (void) queueDownloadFromURL:(NSURL *) url 
						   method:(NSString *) method 
				  queryParameters:(NSDictionary *) queryParameters 
				   HTTPParameters:(NSDictionary *) HTTPParameters 
					 atTopOfQueue:(BOOL) atTopOfQueue
				  completionBlock:(AFKDownloadWorkerTask) completionBlock;
				
This family of class methods enqueues a worker that loads the resulting data in memory and then executes the associated completion block, which is passed a pointer to the resulting NSData instance.

	+ (void) queueFileDownloadFromURL:(NSURL *) url 
							   method:(NSString *) method 
					  queryParameters:(NSDictionary *) queryParameters 
					   HTTPParameters:(NSDictionary *) HTTPParameters 
						 atTopOfQueue:(BOOL) atTopOfQueue 
					  completionBlock:(AFKDownloadFileWorkerTask) completionBlock;

This family, on the other hand, uses a file-based worker, thereby reducing the overall memory footprint. The completion block, in this case, is passed an NSString instance that contains the path of the temporary file used by the worker. Do note that the temp file is deleted when the worker is released, which is typically right after the completion block exits. Therefore, you should either process the file or move it before the completion block exits.

The remaining parameters of both families of methods are as follows:

* **url** - The URL to download from. HTTP and HTTPS should both work fine. FTP is untested (but should work)
- **method** - The HTTP methods to use (GET, POST, etc.)
* **queryParameters** - An NSDictionary instance that contains any additional query parameters to encode after the URL
* **HTTPParameters** - An NSDictionary instance that contains any additional HTTP headers to pass.
* **atTopOfQueue** - Whether the download should be placed at the beginning of the download queue (in which case it's loaded before anything else) or not

In addition, both families include variants that support a target/selector callback model and provide a simplified interface for operations that do not require passing a method (which defaults to GET) or HTTP headers.


The completion block
--------------------

Depending on the kind of worker that you use, the completion block receives either a pointer to an NSData object that contains the information downloaded from the web, or an NSString instance that contains the path of the temporary file where the data has been downloaded.

Generally, the same holds true uf you use one of the target/selector enqueuing methods:

	- (void) imageLoaded:(NSData *) data {
	  // data contains the data loaded from the web,
	  // or Nil in the event of an error
	}

The demo
--------

This project contains a (Universal) demo that displays a simple timed slideshow using ten images taken from my [Flickr photostream](http://www.flickr.com/photos/mtabini/). It delegates loading to the load manager and then displays them as they become available—as you will see if you try it out, the loading operation does not interfere with the smooth functioning of the app. The demo uses file-based workers and a completion blocks.

Requirements
------------

The library and demo require iOS 4.0 or higher. The demo has been built against iOS 4.2 GM.

Limitations
-----------

The library should be fully thread-safe, although I have not yet tested it as such. The memory-based workers need to be used with caution, as they will load all the data directly into memory. This is probably fine if you only ever need to deal with small documents, but unadvisable when handling large files.