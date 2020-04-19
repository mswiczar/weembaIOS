//
//  MSProyecto.m
//  weembra
//
//  Created by Moises Swiczar on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSProyecto.h"
#import "MSProyectos.h"


@implementation MSProyecto
@synthesize thedict;
@synthesize navImageView;


-(void) clickreturn:(id)aobj
{
	[self.navigationController popViewControllerAnimated:YES];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn retain];
		[btn addTarget:self action:@selector(clickreturn:) forControlEvents:UIControlEventTouchUpInside];
		btn.frame = CGRectMake(3, 10, 70, 33);
		[btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
		[btn setImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateHighlighted];
		
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)viewWillDisappear:(BOOL)animated
{
	[btn removeFromSuperview];
}


- (void)viewDidAppear:(BOOL)animated
{
	[navImageView addSubview:btn];
}	

- (void)dealloc {
    [super dealloc];
}


@end
