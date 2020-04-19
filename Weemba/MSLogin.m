//
//  MSLogin.m
//  Weembra
//
//  Created by Moises Swiczar on 12/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSLogin.h"


@implementation MSLogin

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		thetab = nil;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
//	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
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

-(IBAction) clicklogin:(id)aobj
{
	if(thetab==nil)
	{
		thetab = [[MyTabBarController alloc] init];
	}
	
	[self.navigationController pushViewController:thetab animated:NO];
	
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField==fieldemail)
	{
		[fieldemail resignFirstResponder];
		[fieldpass becomeFirstResponder];
	}

	if (textField==fieldpass)
	{
		[fieldpass resignFirstResponder];
	}
	
	return YES;
	
}


@end
