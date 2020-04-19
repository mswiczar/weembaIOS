//
//  MSTomador.m
//  weembra
//
//  Created by Moises Swiczar on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSTomador.h"
#import "MyTabBarController.h"

@implementation MSTomador
@synthesize root;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		self.title =@"Tomador";
		theautorizaciones=nil;
		
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImage *image = [UIImage imageNamed: @"weemba.png"];
	navImageView = [[UIImageView alloc] initWithImage:image];
	[navImageView retain];
	navImageView.frame = CGRectMake(0,20, 320, 45);
	[self.navigationController.view addSubview:navImageView];
	
//	self.navigationController.navigationItem.backBarButtonItem =nil;
//	[imageView release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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

-(IBAction) clickpendientes:(id)aobj
{
	
	if (theautorizaciones==nil)
	{
		theautorizaciones =  [[MSAutorizaciones alloc] initWithNibName:@"MSAutorizaciones" bundle:nil];
	}
	theautorizaciones.navImageView = navImageView;
	
	[self.navigationController pushViewController:theautorizaciones animated:YES];
	
}
-(IBAction) clickpublicados:(id)aobj
{
	[((MyTabBarController*) root) gotoProyects];
}

-(IBAction) clickforos:(id)aobj
{

}


@end
