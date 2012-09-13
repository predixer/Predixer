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

@implementation predixerPlayCommentsController

@synthesize dataComments;
@synthesize commentsDataController;
@synthesize questionID;
@synthesize commentsCount;
@synthesize dataQuestion;

- (id)init {
	if ((self = [super init])) {
        
        if (commentsDataController == nil) {
            commentsDataController = [[DataCommentsController alloc] init];
            
            NSLog(@"Count commentsDataController: %d", [commentsDataController countOfList]);
        }
        
        if (dataQuestion == nil) {
            dataQuestion = [[DataQuestions alloc] init];
        }
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
    
    dataComments = [[DataComments alloc] init];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingTopComments" object:nil];
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
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    
    // Configure the cell...
    if ([commentsDataController countOfList] != 0)
    {
        dataComments = [commentsDataController objectInListAtIndex:indexPath.row];
        
        NSLog(@"dataComments.comment %@", dataComments.comment);
        NSLog(@"commentID %@", dataComments.commentID);
        cell.textLabel.text = dataComments.comment;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"By %@ on %@", dataComments.fbName, dataComments.commentDate];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    predixerPlayCommentsDetailsController *commentDetails = [[predixerPlayCommentsDetailsController alloc] initWithQuestion:[questionID intValue] comment:[commentsDataController objectInListAtIndex:indexPath.row] count:[commentsDataController countOfList]];
    
    commentDetails.dataQuestion = self.dataQuestion;
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [delegate.navigationController pushViewController:commentDetails animated:YES];
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
