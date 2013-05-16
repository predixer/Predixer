//
//  predixerSettingsViewControllerViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface predixerSettingsViewControllerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray *items;
    IBOutlet UITableView *tblSettings;
    IBOutlet UIImageView *vwDeauthorized;
}

- (void)pressBack:(id)sender;

@end
