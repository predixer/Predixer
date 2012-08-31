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

#define kImageHeight    30
#define kImageWidth     30

static NSMutableArray *arr_Instances=nil;

- (void)defaultInit
{    
    btn_RadioButton            = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_RadioButton.frame      = CGRectMake(0, 0, kImageWidth, kImageHeight);
    btn_RadioButton.adjustsImageWhenHighlighted = NO;
    [btn_RadioButton setImage:[UIImage imageNamed:@"CheckBox_Deselected.png"] forState:UIControlStateNormal];
    [btn_RadioButton setImage:[UIImage imageNamed:@"CheckBox_Selected.png"] forState:UIControlStateSelected];
    [btn_RadioButton addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_RadioButton];
    
    lbl_RadioButton            = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.bounds.size.width-35, 38)];
    lbl_RadioButton.backgroundColor    = [UIColor clearColor];
    lbl_RadioButton.textAlignment = UITextAlignmentLeft;
    lbl_RadioButton.numberOfLines = 2;
    lbl_RadioButton.lineBreakMode = UILineBreakModeWordWrap;
    lbl_RadioButton.font = [UIFont systemFontOfSize:16];
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
    if(!btn_RadioButton.selected)
    {
        [btn_RadioButton setSelected:YES];
        [RadioButton handleGroup:self];
        [delegate stateChangedForGroupID:nGroupID WithSelectedButton:nID];
    }
}

@end
