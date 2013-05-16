//
//  DataDrawDate.m
//  predict
//
//  Created by Joel R Ballesteros on 9/28/12.
//
//

#import "DataDrawDate.h"

@implementation DataDrawDate

@synthesize drawID;
@synthesize drawDate;
@synthesize dateEntered;
@synthesize dateUpdated;

+ (DataDrawDate *)drawWithID:(int)aDrawID drawDate:(NSDate*)aDrawDate dateEntered:(NSDate*)aDateEntered dateUpdated:(NSDate*)aDateUpdated {
    
    return [[DataDrawDate alloc] initWithDrawID:aDrawID drawDate:aDrawDate dateEntered:aDateEntered dateUpdated:aDateUpdated];
    
}

- (id)initWithDrawID:(int)aDrawID drawDate:(NSDate*)aDrawDate dateEntered:(NSDate*)aDateEntered dateUpdated:(NSDate*)aDateUpdated {
    
    if ((self = [super init])) {
        
        drawID = aDrawID;
        drawDate = [aDrawDate copy];;
        dateEntered = [aDateEntered copy];
        dateUpdated = [aDateUpdated copy];;
        
	}
	return self;
    
}

@end
