//
//  predixerGameFindFriendsPlayController.h
//  predict
//
//  Created by Joel R Ballesteros on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface predixerGameFindFriendsPlayController : UITableViewController{
    
    NSMutableArray *myData;
    NSMutableDictionary *sections;  
    UILabel *messageLabel;
    UIView *messageView;
    
}

@property (strong, nonatomic) NSMutableArray *myData;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIView *messageView;
@property (strong, nonatomic) NSMutableDictionary *sections;  

- (id)initWithStyle:(UITableViewStyle)style data:(NSArray *)data;

@end
