//
//  testShowHUD.m
//  testRepo
//
//  Created by Mariko0Oo on 2021/2/3.
//

#import "TestShowHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>
@implementation TestShowHUD
+(void)showHUD:(UIView *)view{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}
@end
