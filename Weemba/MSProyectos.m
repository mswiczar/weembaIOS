//
//  MSProyectos.m
//  weembra
//
//  Created by Moises Swiczar on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSProyectos.h"
#import "WeembraAppDelegate.h"

@implementation MSProyectos
@synthesize need_reload;
@synthesize navImageView;


-(void)workOnBackground:(BOOL)background
{
	self.view.userInteractionEnabled = !background;
	if (background)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[backAlert show];
		[progressInd startAnimating];
		
	}
	else
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[progressInd stopAnimating];
		[backAlert dismissWithClickedButtonIndex:0 animated:YES];
	}
}



// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		self.title =@"Proyectos";
		theproyecto=nil;
		
		arrayData = [[NSMutableArray alloc]init];
		progressInd = [[UIActivityIndicatorView alloc] init];
		progressInd.hidesWhenStopped = YES;
		progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[progressInd sizeToFit];
		progressInd.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
										UIViewAutoresizingFlexibleRightMargin |
										UIViewAutoresizingFlexibleTopMargin |
										UIViewAutoresizingFlexibleBottomMargin);
		
		backAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", @"")
											   message:NSLocalizedString(@"Obteniendo Datos\nPor favor aguarde.", @"") //@SK
											  delegate:nil 
									 cancelButtonTitle:nil
									 otherButtonTitles:nil];
		//backAlert.transform = CGAffineTransformTranslate( backAlert.transform, 0.0, -110.0 );//@SK
		
		progressInd.center = CGPointMake(backAlert.frame.size.width / 2.0, -5.0);
		[backAlert addSubview:progressInd];
		
		

    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
	UIImage *image = [UIImage imageNamed: @"weemba.png"];
	self.navImageView = [[UIImageView alloc] initWithImage:image];
	self.navImageView.frame = CGRectMake(0,20, 320, 47);
	[self.navigationController.view addSubview:self.navImageView];

}

-(void) loaddata:(id)aobj
{	
	//WeembraAppDelegate *appDelegate = (WeembraAppDelegate *)[[UIApplication sharedApplication] delegate];
	//[WSCall DoGetFollowers:appDelegate.alogin aarray:arrayData thenametoview:appDelegate.theTWLogin.Screen_name];
	[NSThread sleepForTimeInterval:1];
	NSInteger iii;
	for (iii=0; iii < 10; iii ++) 
	{
		NSMutableDictionary * thedict = [[ NSMutableDictionary alloc]init];
		[thedict setObject:[NSString stringWithFormat:@"Proyecto Nro %d: xxxxxxxx- xxxxxxxxx xxxxxxxx- xxxxxxxxx",iii] forKey:@"desc"];
		[thedict setObject:[NSString stringWithFormat:@"%d",iii] forKey:@"id"];
		[arrayData addObject:thedict];
		[thedict release];
	}
	[thetable reloadData];
	[self workOnBackground:NO];
	
	
}


-(void) showalldata
{
	
	[self workOnBackground:YES];
	
	atimergetdata = [NSTimer scheduledTimerWithTimeInterval:	0.1		// seconds
													 target:		self
												   selector:	@selector (loaddata:)
												   userInfo:	self		// makes the currently-active audio queue (record or playback) available to the updateBargraph method
													repeats:	NO];
	
};



- (void)viewWillAppear:(BOOL)animated
{
	
	
	
	
	if(self.need_reload)
	{
		self.need_reload=NO;
		[self showalldata];
		return;
	}
	
	if([arrayData count]==0)
	{
		[self showalldata];
	}
	
	
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

// This table will always only have one section.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

// One row per book, the number of books is the number of rows.
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
	return [arrayData count];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}
-(IBAction) refresh:(id)aobj
{
	[self showalldata];
	
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (UITableViewCell *)obtainTableCellForRow:(NSInteger)row
{
	UITableViewCell *cell = nil;
	cell = [thetable dequeueReusableCellWithIdentifier:@"UICell"];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UICell"] autorelease];
		cell.selectionStyle = 	UITableViewCellSelectionStyleGray;
		cell.textLabel.numberOfLines = 2;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return cell;
}



- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSInteger row = [indexPath row];
	UITableViewCell *cell = [self obtainTableCellForRow:row];
	
	NSMutableDictionary * thedict = [arrayData objectAtIndex: row];
	cell.textLabel.text = [thedict objectForKey:@"desc"];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSInteger row = [indexPath row];
	if (theproyecto==nil)
	{
		theproyecto =  [[MSProyecto alloc] initWithNibName:@"MSProyecto" bundle:nil];
	}
	theproyecto.navImageView = navImageView;

	NSMutableDictionary *thestore = [arrayData objectAtIndex: row];
	
	theproyecto.thedict = thestore;
	[self.navigationController pushViewController:theproyecto animated:YES];
	[tv deselectRowAtIndexPath:indexPath	animated:YES];
	
	return indexPath;
}
@end
