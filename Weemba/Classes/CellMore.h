//  UICellConfig.h

#import <UIKit/UIKit.h>
@interface CellMore: UITableViewCell
{
	UILabel	*Label_first;
	UILabel	*Label_first1;

	UIActivityIndicatorView * thesleep;

}
@property (nonatomic, assign) UILabel	*Label_first;
@property (nonatomic, assign) UILabel	*Label_first1;

-(void) start;
-(void) stop;

@end





