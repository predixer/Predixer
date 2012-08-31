//
//  predixerGameLeaguesViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface predixerGameLeaguesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *tblList;
}

- (void)pressBack:(id)sender;
- (void)pressSettings:(id)sender;

@end
