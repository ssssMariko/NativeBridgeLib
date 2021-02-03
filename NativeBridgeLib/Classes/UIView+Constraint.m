//
//  UIView+Constraint.m
//  JZTKit
//
//  Created by 周光 on 2018/6/4.
//  Copyright © 2018年 JZT. All rights reserved.
//

#import "UIView+Constraint.h"

@implementation UIView (Constraint)


/**
 *  获取在父视图上相关属性的约束
 *
 *  @param attribute 约束属性
 *
 *  @return 相对应的约束
 */
- (NSLayoutConstraint *)findConstraintForAttribute:(NSLayoutAttribute)attribute
{
    for (NSLayoutConstraint *constraint in self.superview.constraints)
        
    {
        if (constraint.firstItem == self && constraint.firstAttribute == attribute)
            
            return constraint;
        
        if (constraint.secondItem == self && constraint.secondAttribute == attribute)
            
            return constraint;
        
    }
    
    
    return nil;
    
}


/**
 *  获取自身的相关属性的约束
 *
 *  @param attribute 约束属性
 *
 *  @return 相应的约束
 */
- (NSLayoutConstraint *)findOwnConstraintForAttribute:(NSLayoutAttribute)attribute {
    for (NSLayoutConstraint *constraint in self.constraints)
        
    {
        
        
        if (constraint.firstItem == self && constraint.firstAttribute == attribute)
            
            return constraint;
        
        
        
        
        if (constraint.secondItem == self && constraint.secondAttribute == attribute)
            
            return constraint;
        
    }
    
    
    
    return nil;
    
}


/*!
 *  更新约束
 *
 *  @param attribute 约束属性
 *  @param constant  约束值
 */
- (void)updateConstraintForAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant
{
    
    if ((attribute == NSLayoutAttributeWidth) || (attribute == NSLayoutAttributeHeight)) {
        
        NSLayoutConstraint *con = [self findOwnConstraintForAttribute:attribute];
        if (con)
        {
            con.constant = constant;
        }
        
    }else
    {
        NSLayoutConstraint *con  = [self findConstraintForAttribute:attribute];
        con.constant = constant;
    }
}

/*!
 *  移除约束
 *
 *  @param attribute  约束属性
 */
- (void)removeConstraintForAttribute:(NSLayoutAttribute)attribute
{
    if ((attribute == NSLayoutAttributeWidth) || (attribute == NSLayoutAttributeHeight)) {
        
        NSLayoutConstraint *con = [self findOwnConstraintForAttribute:attribute];
        if (con)
        {
            [self removeConstraint:con];
            
            con = nil;
        }
        
    }else
    {
        NSLayoutConstraint *con  = [self findConstraintForAttribute:attribute];
        
        if(con)
        {
            [self.superview removeConstraint:con];
            
            con = nil;
        }
    }
    
    
    
}
@end
