//
//  predixerPointsViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 8/26/12.
//
//

#import <UIKit/UIKit.h>

@interface predixerPointsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *items;
    IBOutlet UITableView *tblPoints;
}

- (void)pressBack:(id)sender;

@end
