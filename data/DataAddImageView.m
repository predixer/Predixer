//
//  DataAddImageView.m
//  predict
//
//  Created by Joel R Ballesteros on 2/1/13.
//
//

#import "DataAddImageView.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "Constants.h"

@implementation DataAddImageView

- (id)init {
	if ((self = [super init])) {
        
		if ([arrData count] == 0) {
			arrData = [[NSMutableArray alloc] init];
			receivedData = [[NSMutableData alloc] init];
            
		}
	}
	
	return self;
}

// Custom set accessor to ensure the new list is mutable
- (void)setList:(NSMutableArray *)newList {
	
	if (arrData != newList) {
		arrData = [newList mutableCopy];
	}
}

// Accessor methods for list
- (unsigned)countOfList {
	return [arrData count];
}

#pragma mark Fetch from the internet

- (void)addImageView:(NSString *)imageID isImageView:(BOOL)isView
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss a"];
    [dateFormat setLocale:[NSLocale currentLocale]];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    NSString *isImageView = @"false";
    NSString *isLinkClick = @"false";
    
    if (isView == true) {
        isImageView = @"true";
    }
    else {
        isLinkClick = @"true";
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@AddImageView?id=%@&fb=%@&dt=%@&im=%@&lk=%@", WebServiceSource, imageID, facebookUserID,dateString, isImageView, isLinkClick];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"escapedUrl %@", escapedUrl);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[arrData removeAllObjects];
    
	if (theConnection)
	{
        //NSLog(@"Connection created successfully");
		receivedData = nil;
		receivedData = [NSMutableData data];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
	else
	{
        /*
         //Alert user for connection null response
         UIAlertView *baseAlert = [[UIAlertView alloc]
         initWithTitle:@"Cannot Connect!" message:@"Either the service is down or you don't have an internet connection."
         delegate:self cancelButtonTitle:@"OK"
         otherButtonTitles:nil, nil];
         [baseAlert show];*/
        
        nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"didFinishAddingImageView" object:nil];
	}
}


#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	return;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    //NSLog(@"Connected: %@", data);
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"%@", error);
	receivedData = nil;
    
    /*
     // inform the user
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
     message:@"There was an error while connecting to the server. "
     "Either the service is down or you don't have an internet connection."
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [alert show];*/
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"didFinishAddingImageView" object:nil];
    
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
	//Transform response to string
	NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
 	//NSLog(@"Login JSON Response: %@", response);
	
	//Parse response for JSON values and save to dictionary
	NSDictionary *userInfo = [response JSONValue];
    
    /*
     for (id key in userInfo) {
     //NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
     }*/
    
    NSString *result = (NSString*)[userInfo objectForKey:@"AddImageViewResult"];
    
    if ([result length] > 0)
    {
        //do nothing
    }
    else
    {
        //do nothing
    }
    
    nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"didFinishAddingImageView" object:nil];
    
	receivedData = nil;
    
}

@end
