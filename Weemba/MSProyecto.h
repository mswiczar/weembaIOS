//
//  MSProyecto.h
//  weembra
//
//  Created by Moises Swiczar on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MSProyecto : UIViewController {
	NSMutableDictionary * thedict;
	IBOutlet UILabel * label_monto;
	IBOutlet UILabel * label_termino;
	IBOutlet UILabel * label_amortizacion;
	IBOutlet UILabel * label_credit;

	
	IBOutlet UILabel * label_tpersona;
	IBOutlet UILabel * label_taceptacion;
	IBOutlet UILabel * label_tnegociacion;
	IBOutlet UILabel * label_trepublico;
	IBOutlet UILabel * label_tpublico;
	IBOutlet UILabel * label_texpira;
	IBOutlet UILabel * label_tfinalidad;

	IBOutlet UILabel * label_proyectoname;
	IBOutlet UIImageView * vieewProyecto;
	
	UIImageView *navImageView;
	UIButton* btn;

	
}
@property (nonatomic,assign) NSMutableDictionary * thedict;
@property (nonatomic,retain) UIImageView *navImageView;
@end
