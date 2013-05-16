//
//  RadioButton.m
//  predict
//
//  Created by Joel R Ballesteros on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RadioButton.h"

@interface RadioButton()
+ (void)registerInstance:(RadioButton*)radioButton;
- (void)defaultInit;
- (void)handleTap;
@end

@implementation RadioButton

@synthesize lbl_RadioButton;
@synthesize btn_RadioButton;
@synthesize nID;
@synthesize nGroupID;
@synthesize delegate;

#define kImageHeight    33
#define kImageWidth     60

static NSMutableArray *arr_Instances=nil;

- (void)defaultInit
{    
    btn_RadioButton            = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_RadioButton.frame      = CGRectMake(0, 0, kImageWidth, kImageHeight);
    btn_RadioButton.adjustsImageWhenHighlighted = NO;
    [btn_RadioButton setImage:[UIImage imageNamed:@"btn_CheckBox_XGray.png"] forState:UIControlStateNormal];
    [btn_RadioButton setImage:[UIImage imageNamed:@"btn_CheckBox_XGreen.png"] forState:UIControlStateSelected];
    btn_RadioButton.showsTouchWhenHighlighted = YES;
    [btn_RadioButton addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_RadioButton];
    
    lbl_RadioButton            = [[MSLabel alloc] initWithFrame:CGRectMake(34, 0, self.bounds.size.width-50, 35)];
    lbl_RadioButton.backgroundColor    = [UIColor clearColor];
    lbl_RadioButton.textAlignment = UITextAlignmentLeft;
    lbl_RadioButton.numberOfLines = 2;
    lbl_RadioButton.lineHeight = 18;
    lbl_RadioButton.font = [UIFont fontWithName: @"Verdana" size:14];
    [self addSubview:lbl_RadioButton];
    
    [RadioButton registerInstance:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self defaultInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID AndTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultInit];
        [self setGroupID:indexGroup AndID:indexID AndTitle:title];
    }
    return self;
}

- (void)setGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID AndTitle:(NSString *)title
{
    nID = indexID;
    nGroupID = indexGroup;
    lbl_RadioButton.text = title;
}

+ (void)registerInstance:(RadioButton*)radioButton
{
    if(!arr_Instances)
    {
        arr_Instances = [[NSMutableArray alloc] init];
    }    
    [arr_Instances addObject:radioButton];
}

+ (void)handleGroup:(RadioButton*)radioButton
{
    if(arr_Instances) 
    {
        for (int i=0; i<[arr_Instances count]; i++) 
        {
            RadioButton *button = [arr_Instances objectAtIndex:i];
            if ((![button isEqual:radioButton]) && (button.nGroupID == radioButton.nGroupID))
            {
                [button.btn_RadioButton setSelected:NO];
            }
        }
    }
}

+ (NSUInteger)selectedIDForGroupID:(NSUInteger)indexGroup
{
    if(arr_Instances)
    {
        for(int i=0; i<[arr_Instances count]; i++)
        {
            RadioButton *button = [arr_Instances objectAtIndex:i];
            if((button.nGroupID == indexGroup) && (button.btn_RadioButton.isSelected))
            {
                return button.nID;
            }
        }
    }
    return 0;
}

- (void)handleTap
{
        [btn_RadioButton setImage:[UIImage imageNamed:@"btn_CheckBox_XGreen_H.png"] forState:UIControlStateHighlighted];
    
    if(!btn_RadioButton.selected)
    {
        [btn_RadioButton setSelected:YES];
        [RadioButton handleGroup:self];
        [delegate stateChangedForGroupID:nGroupID WithSelectedButton:nID];
    }
}

@end
