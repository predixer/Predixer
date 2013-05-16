//
//  DataHowTo.m
//  predict
//
//  Created by Joel R Ballesteros on 11/14/12.
//
//

#import "DataHowTo.h"

@implementation DataHowTo

@synthesize howToText;
@synthesize dateUpdated;

+ (DataHowTo *) howToWithText:(NSString*)aHowTo dateUpdated:(NSDate*)aDateUpdated {
    
    return [[DataHowTo alloc] initWithHowTo:aHowTo dateUpdated:aDateUpdated];
    
}

- (id)initWithHowTo:(NSString*)aHowTo dateUpdated:(NSDate*)aDateUpdated {
    
    if ((self = [super init])) {
        
        howToText = [aHowTo copy];
        dateUpdated = [aDateUpdated copy];;
        
	}
	return self;
    
}


@end
