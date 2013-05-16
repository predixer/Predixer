//
//  predixerPlayCommentsBottomController.m
//  predict
//
//  Created by Joel R Ballesteros on 10/8/12.
//
//

#import "predixerPlayCommentsBottomController.h"
#import "DataComments.h"
#import "DataCommentsController.h"
#import "predixerAppDelegate.h"
#import "DataQuestions.h"
#import "MSLabel.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 299.0f
#define CELL_CONTENT_MARGIN 0.0f

@interface predixerPlayCommentsBottomController ()

@end

@implementation predixerPlayCommentsBottomController

@synthesize dataComments;
@synthesize commentsDataController;
@synthesize questionID;
@synthesize commentsCount;
@synthesize dataQuestion;
@synthesize isAddNewComment;
@synthesize isLoadMore;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if (commentsDataController == nil) {
            commentsDataController = [[DataCommentsController alloc] init];
            
            NSLog(@"Count commentsDataController: %d", [commentsDataController countOfList]);
        }
        
        if (dataQuestion == nil) {
            dataQuestion = [[DataQuestions alloc] init];
        }
        
        arrLineHeight = [[NSMutableArray alloc] init];
        pageNumber = 0;
        
        nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self
               selector:@selector(didFinishLoadingTopComments)
                   name:@"didFinishLoadingTopComments"
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(didFinishLikeComment)
                   name:@"didFinishLikeComment"
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(didFinishLoadingComments)
                   name:@"didFinishLoadingComments"
                 object:nil];
        
        dataComments = [[DataComments alloc] init];
        isLoadMore = NO;
        isAddNewComment = NO;
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingTopComments" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLikeComment" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingComments" object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didFinishLoadingTopComments
{
    dataComments = [commentsDataController objectInListAtIndex:0];
    
    if ([dataComments.totalComments intValue] <= 1)
    {
        btnLoadMore.hidden = YES;
    }
    else
    {
        btnLoadMore.hidden = NO;
    }
    
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
    
    [nc postNotificationName:@"didFinishLoadingCommentsToTable" object:nil];
}

- (void)didFinishLoadingComments
{
    dataComments = [commentsDataController objectInListAtIndex:0];
    
    if ([dataComments.totalComments intValue] <= 1)
    {
        btnLoadMore.hidden = YES;
    }
    else
    {
        
        NSLog(@"%d = %d", [dataComments.totalComments intValue], [commentsDataController countOfList]);
        
        if ([dataComments.totalComments intValue] > [commentsDataController countOfList]) {
            btnLoadMore.hidden = NO;
        }
        else
        {
            btnLoadMore.hidden = YES;
        }
        
    }
    
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
    
    [self performSelector:@selector(performDismiss) withObject:nil afterDelay:0.0f];
    
    
    [nc postNotificationName:@"didFinishLoadingCommentsToTable" object:nil];
    
    
    pageNumber++;
    
}

- (void)getComments{
    
    commentsDataController.questionID = questionID;
    
    NSLog(@"isAddNewComment isLoadMore %d %d", isAddNewComment, isLoadMore);
    
    if (isLoadMore == NO && isAddNewComment == NO) {        
        [commentsDataController getTopComments];
    }
    else if (isAddNewComment == YES && isLoadMore == NO){
        commentsDataController.isAddNewComment = YES;
        [commentsDataController getTopComments];
    }
    else {
        commentsDataController.pageNumber = [NSString stringWithFormat:@"%d", pageNumber];
        [commentsDataController getComments];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [commentsDataController countOfList];
}

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    dataComments = [commentsDataController objectInListAtIndex:indexPath.row];
    
    NSString *text = dataComments.comment;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode: NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    
    NSLog(@"height %f", height + (CELL_CONTENT_MARGIN * 2));
    
    [arrLineHeight addObject:[NSString stringWithFormat:@"%f", height + (CELL_CONTENT_MARGIN * 2)]];
    
    return height + (CELL_CONTENT_MARGIN * 2) + 28;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    //REMOVE ALL CELL SUB-VIEWS FIRST
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    MSLabel *label = nil;
    UIView *vwCommentFooter = nil;
    NSString *strLineHeight = nil;
    UILabel *author = nil;
    UILabel *likes = nil;
    UIImageView *vwLike = nil;
    UIButton *btnLike = nil;
    
    strLineHeight = [arrLineHeight objectAtIndex:indexPath.row];
    
    label = [[MSLabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    [label setLineBreakMode:UILineBreakModeWordWrap];
    [label setMinimumFontSize:FONT_SIZE];
    [label setNumberOfLines:0];
    label.lineHeight = 16;
    [label setFont: [UIFont fontWithName: @"Comic Sans MS" size:FONT_SIZE]];
    [label setTag:1];
    
    
    vwCommentFooter = [[UIView alloc] init];
    vwCommentFooter.frame = CGRectMake(0.0f, [strLineHeight floatValue], 299.0f, 25.0f);
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
    author.frame = CGRectMake(4.0f, 2.0f, 250.0f, 20.0f);
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
    
    [[cell contentView] addSubview:label];
    [[cell contentView] addSubview:vwCommentFooter];
    
    // Configure the cell...
    if ([commentsDataController countOfList] != 0)
    {
        dataComments = [commentsDataController objectInListAtIndex:indexPath.row];
        
        NSLog(@"dataComments.comment %@", dataComments.comment);
        NSLog(@"commentID %@", dataComments.commentID);
        
        NSString *text = dataComments.comment;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        if (!label)
            label = (MSLabel*)[cell viewWithTag:1];
        
        [label setText:text];
        [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
        
        
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)likeComment:(id)sender
{
    
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
    
    UIButton *btn = (UIButton*)sender;
    
    likeIndex = btn.tag;
    commentsDataController.commentID =  [NSString stringWithFormat:@"%d", btn.tag];
    [commentsDataController likeComment];
    
    
}

- (void)didFinishLikeComment
{
    
    for (DataComments *comm in commentsDataController.arrComments) {
        
        NSLog(@"likeIndex %@ = %d",comm.commentID, likeIndex);
        
        if ([comm.commentID intValue] == likeIndex) {
            
            int totalLike =  [comm.totalLikes intValue] + 1;
            comm.totalLikes = [NSString stringWithFormat:@"%d", totalLike];
        }
    }
    
    [self performSelector:@selector(performDismiss) withObject:nil afterDelay:0.0f];
    [self.tableView reloadData];
    
}

- (void)performDismiss
{
    if (baseAlert != nil)
    {
        [aiv stopAnimating];
        [baseAlert dismissWithClickedButtonIndex:0 animated:NO];
        baseAlert = nil;
    }
}

- (IBAction)loadMore:(id)sender
{
    baseAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
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
    
    [arrLineHeight removeAllObjects];
    isLoadMore = YES;
    isAddNewComment = NO;
    
    [self getComments];
}

@end
