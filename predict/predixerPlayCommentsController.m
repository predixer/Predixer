//
//  predixerPlayCommentsController.m
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerPlayCommentsController.h"
#import "DataComments.h"
#import "DataCommentsController.h"
#import "predixerPlayCommentsDetailsController.h"
#import "predixerAppDelegate.h"
#import "DataQuestions.h"
#import "MSLabel.h"
#import "LoadingController.h"

@implementation predixerPlayCommentsController

@synthesize dataComments;
@synthesize commentsDataController;
@synthesize questionID;
@synthesize commentsCount;
@synthesize dataQuestion;
@synthesize loadingController;

- (id)init {
	if ((self = [super init])) {
        
        if (commentsDataController == nil) {
            commentsDataController = [[DataCommentsController alloc] init];
            
            NSLog(@"Count commentsDataController: %d", [commentsDataController countOfList]);
        }
        
        if (dataQuestion == nil) {
            dataQuestion = [[DataQuestions alloc] init];
        }
        
        arrLineHeight = [[NSMutableArray alloc] init];
        pageNumber = 1;
	}
	
	return self;
}

-(void) viewDidLoad
{
    nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(didFinishLoadingTopComments)
               name:@"didFinishLoadingTopComments"
             object:nil];
    
    [nc addObserver:self
           selector:@selector(didFinishLikeComment)
               name:@"didFinishLikeComment"
             object:nil];
    
    dataComments = [[DataComments alloc] init];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingTopComments" object:nil];
}

- (void)didFinishLoadingTopComments
{
    commentsCount = [commentsDataController countOfList];
    NSLog(@"commentscount %d", commentsCount);
    
    [self.tableView reloadData];
    
    [nc postNotificationName:@"didFinishLoadingCommentsToTable" object:nil];
}



- (void)getComments{
    
    commentsDataController.questionID = questionID;
    [commentsDataController getTopComments];
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [commentsDataController countOfList];
}

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    return 42;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    //REMOVE ALL CELL SUB-VIEWS FIRST
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    UIView *vwCommentFooter = nil;
    UILabel *author = nil;
    UILabel *likes = nil;
    UIImageView *vwLike = nil;
    UIButton *btnLike = nil;
    
    vwCommentFooter = [[UIView alloc] init];
    vwCommentFooter.frame = CGRectMake(2.0f, 34.0f, 298.0f, 25.0f);
    vwCommentFooter.backgroundColor = [UIColor colorWithRed:0.223f green:0.709f blue:0.290f alpha:1.0f];
    
    btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imgDwn = [UIImage imageNamed:@"btn_Like_C_Dwn.png"];
    UIImage *imgUp = [UIImage imageNamed:@"btn_Like_C_UP.png"];
    btnLike.frame = CGRectMake(185.0f, 1.0f, 58.0f, 22.0f);
    [btnLike setImage:imgDwn forState:UIControlStateNormal];
    [btnLike setImage:imgUp forState:UIControlStateHighlighted];
    [btnLike setImage:imgUp forState:UIControlStateSelected];
    [btnLike addTarget:self action:@selector(likeComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [vwCommentFooter addSubview:btnLike];
    
    author = [[UILabel alloc] init];
    author.frame = CGRectMake(6.0f, 2.0f, 250.0f, 20.0f);
    author.font = [UIFont fontWithName: @"Comic Sans MS" size:12];
    author.backgroundColor = [UIColor clearColor];
    author.textColor = [UIColor whiteColor];
    [vwCommentFooter addSubview:author];
    
    vwLike = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bkd_Like.png"]];
    vwLike.frame = CGRectMake(250.0f, 4.0f, 15.0f, 14.0f);
    [vwCommentFooter addSubview:vwLike];
    
    likes = [[UILabel alloc] init];
    likes.frame = CGRectMake(268.0f, 2.0f, 40.0f, 20.0f);
    likes.font = [UIFont fontWithName: @"Comic Sans MS" size:12];
    likes.backgroundColor = [UIColor clearColor];
    likes.textColor = [UIColor whiteColor];
    [vwCommentFooter addSubview:likes];
    
    [[cell contentView] addSubview:vwCommentFooter];
    
    // Configure the cell...
    if ([commentsDataController countOfList] != 0)
    {
        dataComments = [commentsDataController objectInListAtIndex:indexPath.row];
        
        NSLog(@"dataComments.comment %@", dataComments.comment);
        NSLog(@"commentID %@", dataComments.commentID);
        cell.textLabel.text = dataComments.comment;
        cell.textLabel.font = [UIFont fontWithName: @"Comic Sans MS" size:14];
        
        if ([dataComments.totalLikes length] > 0) {
            likes.text = dataComments.totalLikes;
            //likes.text = @"1000";
        }
        else{
            likes.text = @"0";
        }
        
        NSLog(@"date %@", dataComments.commentDate);
        
        NSArray *arrayDate = [dataComments.commentDate componentsSeparatedByString:@" "];
        
        NSString *strHour = @"";
        NSString *strMin = @"";
        NSString *strDay = @"";
        NSString *strDate = @"";
        
        strDate = [arrayDate objectAtIndex:0];
        
        for (int i=0; i < [arrayDate count]; i++) {
            
            NSLog(@" arrayDate %@",[arrayDate objectAtIndex:i]);
            
            if (i == 1) {
                NSLog(@" time %@",[arrayDate objectAtIndex:i]);
                
                NSArray *arrayTime = [[arrayDate objectAtIndex:i] componentsSeparatedByString:@":"];
                
                for (int j=0; j < [arrayTime count]; j++) {
                    
                    if (j==0) {
                        strHour = [NSString stringWithFormat:@"%@", [arrayTime objectAtIndex:j]];
                    }
                    else if (j==1) {
                        strMin = [NSString stringWithFormat:@"%@", [arrayTime objectAtIndex:j]];
                    }
                }
            }
            else if (i == 2) {
                strDay = [NSString stringWithFormat:@"%@", [arrayDate objectAtIndex:i]];
            }
        }
        
        NSLog(@" answerTime %@:%@ %@ %@", strHour, strMin, strDay, strDate);
        
        author.text = [NSString stringWithFormat:@"%@ at %@:%@ %@", dataComments.fbName, strHour, strMin, strDay] ;
        
        btnLike.tag = [dataComments.commentID intValue];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    predixerPlayCommentsDetailsController *commentDetails = [[predixerPlayCommentsDetailsController alloc] initWithQuestion:[questionID intValue] comment:[commentsDataController objectInListAtIndex:indexPath.row] count:[commentsDataController countOfList]];
    
    commentDetails.dataQuestion = self.dataQuestion;
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [delegate.navigationController pushViewController:commentDetails animated:YES];
    */
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)likeComment:(id)sender
{
    loadingController = [[LoadingController alloc] init];
    loadingController.strLoadingText = @"Liking...";
    [self.view addSubview:loadingController.view];
    
    /*
    baseAlert = [[UIAlertView alloc] initWithTitle:@"Liking..."
                                           message:@""
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
    [baseAlert show];
    
    
    //Activity indicator
    aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.center = CGPointMake(baseAlert.bounds.size.width / 2.0f, baseAlert.bounds.size.height / 1.5f);
    [aiv startAnimating];
    [baseAlert addSubview:aiv];
    */
    
    
    UIButton *btn = (UIButton*)sender;
    
    commentsDataController.commentID =  [NSString stringWithFormat:@"%d", btn.tag];
    [commentsDataController likeComment];
    
    
}

- (void)didFinishLikeComment
{
    int totalLike =  [dataComments.totalLikes intValue] + 1;
    dataComments.totalLikes = [NSString stringWithFormat:@"%d", totalLike];
    
    [self performSelector:@selector(performDismiss) withObject:nil afterDelay:0.0f];
    [self.tableView reloadData];
    
}

- (void)performDismiss
{
    [loadingController.view removeFromSuperview];
    
    if (baseAlert != nil)
    {
        [aiv stopAnimating];
        [baseAlert dismissWithClickedButtonIndex:0 animated:NO];
        baseAlert = nil;
    }
}

@end
