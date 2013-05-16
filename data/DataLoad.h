//
//  DataLoad.h
//  predict
//
//  Created by Joel R Ballesteros on 9/1/12.
//
//

#import <Foundation/Foundation.h>

@interface DataLoad : NSObject {
    
}

+ (void)copyDatabaseIfNeeded;
+ (NSString *)getDBPath;

@end
