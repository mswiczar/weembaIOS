//

//  MyTabBarController.m
//  voip
//
//

#import "MyTabBarController.h"
#import "MSTomador.h"
#import "MSProyectos.h"
#import "MSNotificaciones.h"




@implementation MyTabBarController
@synthesize aroot;
- (id)init
{
	if (self = [super init]) 
	{
		

		MSTomador * atomador = [[MSTomador alloc] initWithNibName:@"MSTomador" bundle:nil];
		atomador.root = self;
		nav_tomador = [[UINavigationController alloc]initWithRootViewController:atomador];
		
		nav_tomador.navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
		
		[atomador release];

		MSNotificaciones * anotificaciones = [[MSNotificaciones alloc] initWithNibName:@"MSNotificaciones" bundle:nil];
		nav_notificaciones = [[UINavigationController alloc]initWithRootViewController:anotificaciones];
		nav_notificaciones.navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

		[anotificaciones release];

		MSProyectos * aproyectos = [[MSProyectos alloc] initWithNibName:@"MSProyectos" bundle:nil];
		nav_proyectos = [[UINavigationController alloc]initWithRootViewController:aproyectos];
		nav_proyectos.navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]
		;

		[aproyectos release];
		
		
		NSArray *localViewControllersArray = [NSArray arrayWithObjects:nav_tomador,nav_notificaciones,nav_proyectos,nil];
		
		self.delegate = self;
		self.viewControllers = localViewControllersArray;
		self.selectedIndex = 0;
		
		}
	return self;
}

-(void) gotoProyects
{
	self.selectedIndex = 2;
}


- (void)loadView 
{
	// Don't invoke super if you want to create a view hierarchy programmatically
	[super loadView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc
{
	[super dealloc];
}

#pragma UITabBarViewControllerDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController
didEndCustomizingViewControllers:(NSArray *)viewControllers
				 changed:(BOOL)changed
{

}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
	/*
	if (viewController==recordcontroller)
	{
		[playcontroller clickstopmusic:playcontroller];
	
	}
	else
	{
	
		if(viewController==playcontroller)
		{
			[playcontroller clickpause:playcontroller];
			//
		}
		else
		{
			[playcontroller clickstopmusic:playcontroller];

			// this is settings controller
		
		}
	}
	 */
}

@end
