//
//  CellSpinner.m
//  Detelefoongids
//
//  Created by Moises Swiczar on 4/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CellNotifDict.h"

#import "UChache.h"

@implementation CellNotifDict
@synthesize  controllerid,anotifdict;





- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier
{
	if (self = [super initWithStyle:style reuseIdentifier:identifier])

	{
		

		CGRect aRect;
		
		alabel1 = [[UILabel alloc] initWithFrame:aRect];
		alabel1.backgroundColor = [UIColor clearColor];
		alabel1.opaque = NO;
		alabel1.textAlignment = UITextAlignmentLeft;
		alabel1.textColor = [UIColor blackColor];
		alabel1.highlightedTextColor = [UIColor blackColor];
		alabel1.font = [UIFont boldSystemFontOfSize:14];
		alabel1.numberOfLines= 1;
		
		
		alabel2 = [[UILabel alloc] initWithFrame:aRect];
		alabel2.backgroundColor = [UIColor clearColor];
		alabel2.opaque = NO;
		alabel2.textAlignment = UITextAlignmentLeft;
		alabel2.textColor = [UIColor grayColor];
		alabel2.highlightedTextColor = [UIColor blackColor];
		alabel2.font = [UIFont italicSystemFontOfSize:10];
		alabel2.numberOfLines= 6;

		
		
		alabel3 = [[UILabel alloc] initWithFrame:aRect];
		alabel3.backgroundColor = [UIColor clearColor];
		alabel3.opaque = NO;
		alabel3.textAlignment = UITextAlignmentLeft;
		alabel3.textColor = [UIColor grayColor];
		alabel3.highlightedTextColor = [UIColor blackColor];
		alabel3.font = [UIFont italicSystemFontOfSize:10];
		alabel3.numberOfLines= 1;
		
		
		
		
		CGRect frameimage = CGRectMake(10,7.5,45, 45);
		aimage = [[UIImageView alloc] initWithFrame:frameimage];
		aimage.image =[UIImage imageNamed:@"profile.png"];

		


		
		[self.contentView addSubview:alabel1];
		[self.contentView addSubview:alabel2];
		[self.contentView addSubview:alabel3];
		
		
		
		[self.contentView addSubview:aimage];


		self.contentView.backgroundColor = [UIColor clearColor];
		

	}
	return self;
}


- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect frameLabel1 = CGRectMake(55,10,250, 15);
	alabel1.frame = frameLabel1;
	
	CGRect frameLabel2 = CGRectMake(55,25,250, 90);
	alabel2.frame = frameLabel2;

	CGRect frameLabel3 = CGRectMake(55,120,250, 15);
	alabel3.frame = frameLabel3;
	
	CGRect frameimage = CGRectMake(5,10,45,45); 
	aimage.frame = frameimage;

	
	
}

- (void)dealloc
{
	[aimage release];
	[alabel1 release];
	[alabel2 release];
	[alabel3 release];
    [super dealloc];
}


-(void) show
{
	NSData * thedata = [UChache cachedIconFromURL:[anotifdict objectForKey:@"profile_image_url"]];
	if (nil ==thedata)
	{
		aimage.image = [UIImage imageNamed:@"cuadraro.png"];

	}
	else 
	{
		aimage.image = [UIImage imageWithData:thedata];
		
	}

	alabel1.text = [anotifdict objectForKey:@"nombre"];
	alabel2.text = [anotifdict objectForKey:@"desc"];
	alabel3.text = [anotifdict objectForKey:@"fecha"];

}





@end
