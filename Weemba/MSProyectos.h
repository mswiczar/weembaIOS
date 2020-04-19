//
//  MSProyectos.h
//  weembra
//
//  Created by Moises Swiczar on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSProyecto.h"

@interface MSProyectos : UIViewController {
	IBOutlet UITableView * thetable;
	NSMutableArray *thearray;
	UIActivityIndicatorView			 *progressInd;
	UIAlertView						 *backAlert;
	NSMutableArray					 *arrayData;
	NSTimer *atimergetdata;
	BOOL need_reload;
	MSProyecto * theproyecto ;
	UIImageView *navImageView;
}
@property BOOL need_reload;

@property (nonatomic,retain) UIImageView *navImageView;
@end
