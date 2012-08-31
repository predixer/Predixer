//
//  predixerPlayNewsViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataQuestions;
@class DataQuestionsController;

@interface predixerPlayNewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *tblList;
    IBOutlet UILabel *lblDate;
    
    DataQuestionsController *dataController;
	DataQuestions *dataQuestions;
    
	UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong)DataQuestionsController *dataController;
@property (nonatomic, strong)DataQuestions *dataQuestions;

- (void)didFinishLoadingData;
- (void)performDismiss;
- (void)pressBack:(id)sender;
- (void)pressSettings:(id)sender;

@end
