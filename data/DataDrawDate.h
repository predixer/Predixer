//
//  DataDrawDate.h
//  predict
//
//  Created by Joel R Ballesteros on 9/28/12.
//
//

#import <Foundation/Foundation.h>

@interface DataDrawDate : NSObject {
    
    int drawID;
    NSDate *drawDate;
	NSDate *dateEntered;
	NSDate *dateUpdated;
}

@property(readwrite) int drawID;
@property (nonatomic, strong)NSDate *drawDate;
@property (nonatomic, strong)NSDate *dateEntered;
@property (nonatomic, strong)NSDate *dateUpdated;


+ (DataDrawDate *)drawWithID:(int)aDrawID drawDate:(NSDate*)aDrawDate dateEntered:(NSDate*)aDateEntered dateUpdated:(NSDate*)aDateUpdated;

- (id)initWithDrawID:(int)aDrawID drawDate:(NSDate*)aDrawDate dateEntered:(NSDate*)aDateEntered dateUpdated:(NSDate*)aDateUpdated;

@end
