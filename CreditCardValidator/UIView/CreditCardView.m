//
//  CreditCardView.m
//  CreditCardValidator
//
//  Created by Aman Agarwal on 07/04/19.
//  Copyright © 2019 Assignment. All rights reserved.
//

#import "CreditCardView.h"
#import "CreditCardValidator.h"

@interface CreditCardView ()<UITextFieldDelegate>

@property (nonatomic, strong) CreditCardValidator *validator;
@property (nonatomic, strong) NSDictionary *numberFormatDictionary;
@property (nonatomic, strong) NSString *cardNumberFormat;

@property (weak, nonatomic) IBOutlet UILabel *creditCardName;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *logoIcon;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation CreditCardView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    //Load credit card view
    [[NSBundle mainBundle] loadNibNamed:@"CreditCardView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
    //create credit card validator
    self.validator = [CreditCardValidator new];
    
    //Setup UITextField
    [self.cardNumberField setTextColor:[UIColor whiteColor]];
    [self.cardNumberField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    self.cardNumberField.delegate = self;
    [self.cardNumberField becomeFirstResponder];
    
    //Setup card icon
    self.logoIcon.layer.masksToBounds = YES;
    self.logoIcon.layer.cornerRadius = 5;
    
    //Setup errorLabel
    [self.errorLabel setTextColor:[UIColor whiteColor]];
    
    //Setup cardNameLabel
    [self.creditCardName setTextColor:[UIColor whiteColor]];
    
    //Setup default format style
    self.cardNumberFormat = @"XXXX  XXXX  XXXX  XXXX";
    
    //DataSource for auto formating
    self.numberFormatDictionary = @{
                              @(16):@"XXXX  XXXX  XXXX  XXXX",
                              @(15):@"XXXX  XXXXXX  XXXXX",
                              @(14):@"XXXX  XXXXXX  XXXX",
                              };
}

/*
 * Update card logo
 * Card name
 * Select auto formator layout
 * Reset error label
 */
- (void)updateCreditCardView:(CreditCardType)type {
    NSDictionary *cardInfo = [self.validator.cardInfo objectForKey:[NSNumber numberWithInt:type]];
    if([cardInfo isKindOfClass:[NSDictionary class]]) {
        if([cardInfo valueForKey:@"imageIcon"]) {
            [self.logoIcon setImage:[UIImage imageNamed:[cardInfo valueForKey:@"imageIcon"]]];
        }
        if([cardInfo valueForKey:@"cardName"]) {
            [self.creditCardName setText:[cardInfo valueForKey:@"cardName"]];
        }
        NSNumber *cardLength = [cardInfo valueForKey:@"lenght"];
        if([self.numberFormatDictionary objectForKey:cardLength]) {
            self.cardNumberFormat = [self.numberFormatDictionary objectForKey:cardLength];
        }
    }
    [self.errorLabel setText:@""];
}

/*
 * Auto format card number
 * Update UITextField
 */
- (void)autoFormatCardNumber:(NSString *)updatedText {
    NSString *text = updatedText;
    NSUInteger len = [text length];
    unichar buffer[len+1];
    [text getCharacters:buffer range:NSMakeRange(0, len)];
    
    NSString *formatText = self.cardNumberFormat;
    NSUInteger formatLen = [formatText length];
    unichar formatBuffer[formatLen+1];
    [formatText getCharacters:formatBuffer range:NSMakeRange(0, formatLen)];
    
    int j = 0;
    for(int i = 0;i < len;i++) {
        if(buffer[i] != ' ') {
            while(formatBuffer[j] != 'X') {
                j++;
            }
            formatBuffer[j] = buffer[i];
        }
        else {
            while(formatBuffer[j] != ' ') {
                j++;
            }
            formatBuffer[j] = buffer[i];
        }
    }
    NSString *finalText = len>0?[NSString stringWithCharacters:formatBuffer length:j+1]:@"";
    [self.cardNumberField setText:[self removeEndSpaceFrom:finalText]];
}


#pragma mark - Utility

- (NSString *)removeEndSpaceFrom:(NSString *)strtoremove{
    NSUInteger location = 0;
    unichar charBuffer[[strtoremove length]];
    [strtoremove getCharacters:charBuffer];
    int i = 0;
    for(i = (int)[strtoremove length]; i >0; i--) {
        NSCharacterSet* charSet = [NSCharacterSet whitespaceCharacterSet];
        if(![charSet characterIsMember:charBuffer[i - 1]]) {
            break;
        }
    }
    return [strtoremove substringWithRange:NSMakeRange(location, i  - location)];
}

- (void)validateCardNumber:(NSString *)text {
    BOOL isValid = [self.validator validateCreditCardNumber:text];
    if(!isValid) {
        [self.errorLabel setText:@"Card info not found"];
    }
    else {
        [self.errorLabel setText:@"Valid card info!"];
    }
}


#pragma mark - UITextFieldEditing

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //Extra characters are typed
    if((textField.text.length+string.length) > self.cardNumberFormat.length){
        return NO;
    }
    
    //More than 1 character is pasted
    if(string.length > 1) {
        [self.errorLabel setText:@"Pasting of characters in not allowed"];
        return NO;
    }
    
    //Non numberic character is entered
    if(string.length == 1) {
        unichar firstChar = [string characterAtIndex:0];
        if(firstChar < '0' || firstChar > '9') {
            [self.errorLabel setText:@"Only numeric values allowed, please enter valid character"];
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    //Selected credit card type
    CreditCardType type = [self.validator selectCreditCardFromString:textField.text];
    //Update credit card view, as per card type
    [self updateCreditCardView:type];
    //AutoFormat credit card number, as per card type
    [self autoFormatCardNumber:textField.text];
    if(textField.text.length >= self.cardNumberFormat.length) {
        [self validateCardNumber:textField.text];
    }
}

/*
 * Validate credit card number
 * Update error label
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self validateCardNumber:textField.text];
    return YES;
}

@end
