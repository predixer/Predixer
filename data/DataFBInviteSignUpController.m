//
//  DataFBInviteSignUpController.m
//  predict
//
//  Created by Joel R Ballesteros on 9/17/12.
//
//

#import "DataFBInviteSignUpController.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "DataFBInviteSignUp.h"
#import "Constants.h"

@implementation DataFBInviteSignUpController

@synthesize fbInvitee;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrInvitees count] == 0) {
			arrInvitees = [[NSMutableArray alloc] init];
			fbInvitee = [[DataFBInviteSignUp alloc] init];
			receivedData = [[NSMutableData alloc] init];
            
            nc = [NSNotificationCenter defaultCenter];

            
		}
	}
	
	return self;
}

// Custom set accessor to ensure the new list is mutable
- (void)setList:(NSMutableArray *)newList {
	
	if (arrInvitees != newList) {
		arrInvitees = [newList mutableCopy];
	}
}

// Accessor methods for list
- (unsigned)countOfList {
	return [arrInvitees count];
}


- (DataFBInviteSignUp *)objectInListAtIndex:(unsigned)theIndex {
    
    if ([arrInvitees count] != 0) {
        return [arrInvitees objectAtIndex:theIndex];
    }
    else
    {
        return 0;
    }
}

#pragma mark Fetch from the internet

- (void)getInvitees
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@GetUserFBInvites?fb=%@", WebServiceSource, facebookUserID];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"escapedUrl %@", escapedUrl);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[arrInvitees removeAllObjects];
    
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
        
        [nc postNotificationName:@"didFinishLoadingUserInvitees" object:nil];
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
    
    [nc postNotificationName:@"didFinishLoadingUserInvitees" object:nil];
    
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
	//Transform response to string
	NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
 	//NSLog(@"Login JSON Response: %@", response);
	
	//Parse response for JSON values and save to dictionary
	NSDictionary *userInfo = [response JSONValue];
    
    /*
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }*/
    
    
    NSArray *arrObjects = [[NSArray alloc] init];
    
    arrObjects = [userInfo objectForKey:@"GetUserFBInvitesResult"];
    
    
    for (int i = 0; i < [arrObjects count]; i++) {
        
        NSDictionary *aInvitee = [arrObjects objectAtIndex:i];
        
        NSString *inviterFBID = [NSString stringWithFormat:@"%@", [aInvitee objectForKey:@"InviterFBID"]];
        
        if ([inviterFBID isEqualToString:@"<null>"]) {
            inviterFBID = @"0";
        }
        
        NSString *inviteeFBID = [NSString stringWithFormat:@"%@", [aInvitee objectForKey:@"InviteeFBID"]];
        
        if ([inviteeFBID isEqualToString:@"<null>"]) {
            inviteeFBID = @"0";
        }
        
        NSString *invitePoints = [NSString stringWithFormat:@"%@", [aInvitee objectForKey:@"InvitePoints"]];
        
        if ([invitePoints isEqualToString:@"<null>"]) {
            invitePoints = @"";
        }
        
        NSString *signUpDate = [NSString stringWithFormat:@"%@", [aInvitee objectForKey:@"SignUpDate"]];
        NSDate *addedDate = [[NSDate alloc] init];
        
        if ([signUpDate isEqualToString:@"<null>"]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            signUpDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
            
        }
        else {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
            addedDate = [dateFormatter dateFromString:signUpDate ];
        }
        
        NSString *fbName = [NSString stringWithFormat:@"%@", [aInvitee objectForKey:@"FBName"]];
        
        if ([fbName isEqualToString:@"<null>"]) {
            fbName = @"";
        }
        
        NSString *fbEmail = [NSString stringWithFormat:@"%@", [aInvitee objectForKey:@"FBEmail"]];
        
        if ([fbEmail isEqualToString:@"<null>"]) {
            fbEmail = @"0";
        }
        
        NSString *inviteDate = [NSString stringWithFormat:@"%@", [aInvitee objectForKey:@"InviteDate"]];
        NSDate *dateInvite = [[NSDate alloc] init];
        
        if ([inviteDate isEqualToString:@"<null>"]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            inviteDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
            
        }
        else {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            dateInvite = [dateFormatter dateFromString:inviteDate ];
        }
        
        [arrInvitees addObject:[DataFBInviteSignUp inviteeWithID:inviteeFBID inviterFBID:inviterFBID invitePoints:[invitePoints intValue] signUpDate:addedDate fbName:fbName fbEmail:fbEmail inviteDate:dateInvite]];
        
    }
    
    [nc postNotificationName:@"didFinishLoadingUserInvitees" object:nil];
    
	receivedData = nil;
    
}

@end
