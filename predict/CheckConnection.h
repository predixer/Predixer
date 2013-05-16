//
//  CheckConnection.h
//  predict
//
//  Created by Joel R Ballesteros on 11/22/12.
//
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface CheckConnection : NSObject

+(BOOL)hasConnectivity;

@end
