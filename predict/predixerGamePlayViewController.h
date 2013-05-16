//
//  predixerGamePlayViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface predixerGamePlayViewController : UIViewController
{
    IBOutlet UIButton *btnEntertainment;
    IBOutlet UIButton *btnStocks;
    IBOutlet UIButton *btnSports;
    IBOutlet UIButton *btnNews;
    
    
}


- (IBAction)playEntertainment:(id)sender;
- (IBAction)playStocks:(id)sender;
- (IBAction)playSports:(id)sender;
- (IBAction)playNews:(id)sender;

- (void)pressBack:(id)sender;
- (void)pressSettings:(id)sender;

@end
