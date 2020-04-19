//
//  MSNotificaciones.h
//  weembra
//
//  Created by Moises Swiczar on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MSNotificaciones : UIViewController {
	IBOutlet UITableView * thetable;
	NSMutableArray *thearray;
	UIActivityIndicatorView			 *progressInd;
	UIAlertView						 *backAlert;
	NSMutableArray					 *arrayData;
	NSTimer *atimergetdata;
	BOOL need_reload;
	
}
@property BOOL need_reload;
@end
