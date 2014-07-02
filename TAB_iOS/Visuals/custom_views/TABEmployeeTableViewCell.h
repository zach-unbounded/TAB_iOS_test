//
//  TABEmployeeTableViewCell.h
//  TAB_iOS
//
//  Created by Zachary BURGESS on 02/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

@class TABEmployee;

/** Employee Table View Cell */
@interface TABEmployeeTableViewCell : UITableViewCell

/** the employee's image or the default image untill the correct image is downloaded*/
@property (weak,nonatomic) IBOutlet UIImageView * image_img;

/** the employee's name label */
@property (weak,nonatomic) IBOutlet UILabel * name_lbl;

/** the employee's title label*/
@property (weak,nonatomic) IBOutlet UILabel * title_lbl;

/** the employee's mini biography label*/
@property (weak,nonatomic) IBOutlet UILabel * miniBio_lbl;

/** updates the cells view with data from the employee record
 @paramEmployee employee to update the cell with*/
- (void)updateCellWithEmployee:(TABEmployee*)paramEmployee;

/** static reuse idenifier
 @return string reuse identifier*/
+ (NSString *)reuseIdentifier;

/** the cells Hight varies depending of text in the employees bio
 @param paramText the text that will be used in the bio
 @return the hight a cell would be with the given text*/
+ (CGFloat)cellHeightWithBioText:(NSString*)paramText;

@end
