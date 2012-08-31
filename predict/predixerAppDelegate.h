//
//  predixerAppDelegate.h
//  predict
//
//  Created by Joel R Ballesteros on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class predixerViewController;

@interface predixerAppDelegate : UIResponder <UIApplicationDelegate> {
    
    UINavigationController *navigationController;	
    Facebook *facebook;
    NSMutableDictionary *userPermissions;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) predixerViewController *viewController;
@property (strong, nonatomic) Facebook *facebook;
@property (strong, nonatomic) NSMutableDictionary *userPermissions;

@end
