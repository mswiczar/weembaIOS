//
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface CellAceptDict : UITableViewCell {

	UIImageView *aimage;
	UILabel	*alabel1;
	UILabel	*alabel2;
	UILabel	*alabel3;
	
	id controllerid;
	NSMutableDictionary* anotifdict;
	
}
@property (nonatomic, assign) id controllerid;
@property (nonatomic, assign) NSMutableDictionary* anotifdict;

-(void) show;



@end

