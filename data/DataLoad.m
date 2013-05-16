//
//  DataLoad.m
//  predict
//
//  Created by Joel R Ballesteros on 9/1/12.
//
//

#import "DataLoad.h"

@implementation DataLoad

-(id) init
{
	if ((self = [super init]))
	{
        //[self copyDatabaseIfNeeded];
	}
    
	return self;
}

+ (void)copyDatabaseIfNeeded {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
    
    //Search for sqlite database in documents directory. If not found, add from bundle.
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Predixer.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
    
}

+ (NSString *)getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"Predixer.sqlite"];
}

@end
