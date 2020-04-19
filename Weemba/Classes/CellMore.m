//
//  UICellConfig.m
//
/*
 UILabel	*itemName;
 UILabel	*itemAddress;
 UILabel	*itemURL;
 UILabel *ItemTel;
 UStore * astore;
 
 */

#import "CellMore.h"

@implementation CellMore
@synthesize  Label_first,Label_first1 ;


-(void)clickonnext:(id)aobj
{

//	[((SearchVC*) aobjectcallback) getthenext];
	
}

-(void)clickonprev:(id)aobj
{
//	[((SearchVC*) aobjectcallback) gettheprev];
	
}


- (id)initWithFrame:(CGRect)aRect reuseIdentifier:(NSString *)identifier
{
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier])
	{
		Label_first = [[UILabel alloc] initWithFrame:aRect];
		Label_first.backgroundColor = [UIColor clearColor];
		Label_first.opaque = NO;
		Label_first.textAlignment = UITextAlignmentLeft;
		Label_first.textColor = [UIColor blackColor]; 
		Label_first.highlightedTextColor = [UIColor blackColor];
		Label_first.font = [UIFont systemFontOfSize:16];
		Label_first.numberOfLines= 1;

		Label_first1 = [[UILabel alloc] initWithFrame:aRect];
		Label_first1.backgroundColor = [UIColor clearColor];
		Label_first1.opaque = NO;
		Label_first1.textAlignment = UITextAlignmentLeft;
		Label_first1.textColor = [UIColor darkGrayColor];
		Label_first1.highlightedTextColor = [UIColor blackColor];
		Label_first1.font = [UIFont systemFontOfSize:14];
		Label_first1.numberOfLines= 1;
		
		thesleep = [[UIActivityIndicatorView  alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		thesleep.hidesWhenStopped=YES;
		
		[self.contentView addSubview:Label_first];
		[self.contentView addSubview:Label_first1];
		[self.contentView addSubview:thesleep];

		self.contentView.backgroundColor = [UIColor clearColor];
	}
	return self;
}




- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect frameItemnAdress = CGRectMake((self.frame.size.width/2)-55,17.5,200, 20);
	Label_first.frame = frameItemnAdress;

	//frameItemnAdress = CGRectMake(55,32.5,200, 20);
	//Label_first1.frame = frameItemnAdress;
	
	frameItemnAdress =thesleep.frame;
	frameItemnAdress.origin.x=(self.frame.size.width/2);
	frameItemnAdress.origin.y=25;
	
	thesleep.frame= frameItemnAdress;


	
}

- (void)dealloc
{
	[Label_first release];
	[Label_first1 release];

    [super dealloc];
}



-(void) start
{
	Label_first.alpha=0;
	[thesleep startAnimating];
	
	/*
	thetimerdownload = [NSTimer scheduledTimerWithTimeInterval:	.2		// seconds
					 									target:		self
													  selector:	@selector (agetdata:)
													  userInfo:	self		// makes the currently-active audio queue (record or playback) available to the updateBargraph method
													   repeats:	NO];
	 */
	
}

-(void) stop
{
	Label_first.alpha=1;
	[thesleep stopAnimating];
}




@end


