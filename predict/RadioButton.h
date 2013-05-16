//
//  RadioButton.h
//  predict
//
//  Created by Joel R Ballesteros on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLabel.h"

@protocol RadioButtonDelegate <NSObject>
- (void)stateChangedForGroupID:(NSUInteger)indexGroup WithSelectedButton:(NSUInteger)indexID;
@end

@interface RadioButton : UIView
{
    NSUInteger  nID;
    NSUInteger  nGroupID;
    UIButton    *btn_RadioButton;
    MSLabel     *lbl_RadioButton;
    
    id <RadioButtonDelegate> delegate;
}

@property (readwrite, nonatomic) NSUInteger nID;
@property (readwrite, nonatomic) NSUInteger nGroupID;
@property (strong, nonatomic) UIButton *btn_RadioButton;
@property (strong, nonatomic) UILabel *lbl_RadioButton;
@property (strong, nonatomic) id <RadioButtonDelegate> delegate;

- (id)initWithFrame:(CGRect)frame AndGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID AndTitle:(NSString*)title;
- (void)setGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID AndTitle:(NSString*)title;
+ (NSUInteger)selectedIDForGroupID:(NSUInteger)indexGroup;

@end
