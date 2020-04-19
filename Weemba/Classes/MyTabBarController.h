//
//  MyTabBarController.h
//

#import <UIKit/UIKit.h>


@interface MyTabBarController : UITabBarController<UITabBarControllerDelegate> 
{

	UINavigationController *nav_tomador;
	UINavigationController *nav_notificaciones;
	UINavigationController *nav_proyectos;
	id aroot;
}
@property (nonatomic,assign) id aroot;
-(void) gotoProyects;

@end
