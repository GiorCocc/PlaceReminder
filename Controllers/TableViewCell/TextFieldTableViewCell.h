//
//  TextFieldTableViewCell.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 16/08/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextFieldTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (void) configureWithTitle:(NSString *)title placeholder:(NSString *)placeholder;
- (void) fillTextFieldWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
