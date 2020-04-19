//
//  MSLogin.h
//  Weembra
//
//  Created by Moises Swiczar on 12/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTabBarController.h"

@interface MSLogin : UIViewController {
	IBOutlet UITextField * fieldemail;
	IBOutlet UITextField * fieldpass;
	IBOutlet UIButton * butonlogin;
	MyTabBarController * thetab;
	
}
-(IBAction) clicklogin:(id)aobj;


@end
