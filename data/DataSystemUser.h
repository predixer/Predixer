//
//  DataSystemUser.h
//  predict
//
//  Created by Joel R Ballesteros on 10/1/12.
//
//

#import <Foundation/Foundation.h>

@interface DataSystemUser : NSObject {
    
    NSString *userID;
    NSString *userName;
	NSString *email;
	NSDate *dateEntered;
	NSString *isWrongPassword;
    
    
}

@property (nonatomic, strong)NSString *userID;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSDate *dateEntered;
@property (nonatomic, strong)NSString *isWrongPassword;


+ (DataSystemUser *)recordWithID:(NSString *)aUserID userName:(NSString *)aUserName email:(NSString *)aEmail dateEntered:(NSDate *)aDateEntered isWrongPassword:(NSString *)aWrongPassword;

- (id)initWithUserID:(NSString *)aUserID userName:(NSString *)aUserName email:(NSString *)aEmail dateEntered:(NSDate *)aDateEntered isWrongPassword:(NSString *)aWrongPassword;



@end
