//
//  DataHowTo.h
//  predict
//
//  Created by Joel R Ballesteros on 11/14/12.
//
//

#import <Foundation/Foundation.h>
 
@interface DataHowTo : NSObject {
    
	NSString *howToText;
	NSDate *dateUpdated;
}

@property (nonatomic, strong)NSString *howToText;
@property (nonatomic, strong)NSDate *dateUpdated;


+ (DataHowTo *) howToWithText:(NSString*)aHowTo dateUpdated:(NSDate*)aDateUpdated;

- (id)initWithHowTo:(NSString*)aHowTo dateUpdated:(NSDate*)aDateUpdated;

@end
