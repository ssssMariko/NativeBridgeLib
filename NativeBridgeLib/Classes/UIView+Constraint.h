//
//  UIView+Constraint.h
//  JZTKit
//
//  Created by 周光 on 2018/6/4.
//  Copyright © 2018年 JZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Constraint)

/**
 *  获取在父视图上相关属性的约束
 *
 *  @param attribute 约束属性
 *
 *  @return 相对应的约束
 */
- (NSLayoutConstraint *)findConstraintForAttribute:(NSLayoutAttribute)attribute;


/**
 *  获取自身的相关属性的约束
 *
 *  @param attribute 约束属性
 *
 *  @return 相应的约束
 
 */
- (NSLayoutConstraint *)findOwnConstraintForAttribute:(NSLayoutAttribute)attribute;


/*!
 *  更新约束
 *
 *  @param attribute 约束属性
 *  @param constant  约束值
 */
- (void)updateConstraintForAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant;



/*!
 *  移除约束
 *
 *  @param attribute  约束属性
 */
- (void)removeConstraintForAttribute:(NSLayoutAttribute)attribute;

@end
