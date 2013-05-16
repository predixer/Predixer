//
//  predixerHowToViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataGrandPrizeController;
@class DataHowToController;
@class LoadingController;
@class DataHowTo;

@interface predixerHowToViewController : UIViewController{
    
    DataGrandPrizeController *dataController;
    DataHowToController *dataHowToController;
    LoadingController *loadingController;
    DataHowTo *howTo;
    
    IBOutlet UITextView *txtHowTo;
    IBOutlet UILabel *lblMoney;
    
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
}

@property(nonatomic, strong)DataGrandPrizeController *dataController;
@property(nonatomic, strong)DataHowToController *dataHowToController;
@property (strong, nonatomic) LoadingController *loadingController;
@property(nonatomic, strong)DataHowTo *howTo;

- (void)didFinishGettingGrandPrize;
- (void)didFinishGettingHowTo;
- (void)performDismiss;
- (void)pressBack:(id)sender;
- (void)pressSettings:(id)sender;

@end
