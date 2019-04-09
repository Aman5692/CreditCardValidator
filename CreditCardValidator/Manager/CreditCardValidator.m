//
//  CreditCardValidator.m
//  CreditCardValidator
//
//  Created by Aman Agarwal on 08/04/19.
//  Copyright © 2019 Assignment. All rights reserved.
//

#import "CreditCardValidator.h"

@implementation CreditCardValidator

-(instancetype)init {
    self = [super init];
    if(self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    //Data source for credit card
    self.cardInfo = @{
                      @(kDefault):@{
                              @"starts":@[],
                              @"lenght":@(16),
                              @"cardName":@"",
                              @"imageIcon":@"Default"
                              },
                      @(kAmericanExpress):@{
                              @"lenght":@(15),
                              @"cardName":@"American Express",
                              @"imageIcon":@"AmexLogo",
                              @"regexs":@"^3[4,7]"
                              },
                      @(kDinersClubCarteBlanche):@{
                              @"lenght":@(14),
                              @"cardName":@"Diners Club - Carte Blanche",
                              @"imageIcon":@"Default",
                              @"regexs":@"^30[0-5]"
                              },
                      @(kDinersClubInternational):@{
                              @"lenght":@(14),
                              @"cardName":@"Diners Club - International",
                              @"imageIcon":@"Default",
                              @"regexs":@"^36"
                              },
                      @(kDiscover):@{
                              @"lenght":@(16),
                              @"cardName":@"Discover",
                              @"imageIcon":@"DiscoverLogo",
                              @"regexs":@"^6[011, 22, 44, 45, 46, 47, 48, 49, 5]"
                              },
                      @(kInstaPayment):@{
                              @"lenght":@(16),
                              @"cardName":@"InstaPayment",
                              @"imageIcon":@"Default",
                              @"regexs":@"^63[7-9]"
                              },
                      @(kJCB):@{
                              @"lenght":@(16),
                              @"cardName":@"JCB",
                              @"imageIcon":@"JcbLogo",
                              @"regexs":@"^35"
                              },
                      @(kMastero):@{
                              @"lenght":@(16),
                              @"cardName":@"Maestro",
                              @"imageIcon":@"Default",
                              @"regexs":@"^(5018|5020|5038|5893|6304|6759|6761|6762|6763)"
                              },
                      @(kMasterCard):@{
                              @"lenght":@(16),
                              @"cardName":@"MasterCard",
                              @"imageIcon":@"MasterCardLogo",
                              @"regexs":@"^5[1-5]"
                              },
                      @(kVisa):@{
                              @"lenght":@(16),
                              @"cardName":@"Visa",
                              @"imageIcon":@"VisaLogo",
                              @"regexs":@"^4",
                              },
                      @(kVisaElectron):@{
                              @"lenght":@(16),
                              @"cardName":@"Visa Electron",
                              @"imageIcon":@"VisaLogo",
                              @"regexs":@"^(4026|417500|4508|4844|4913|4917)",
                              }
                      };
    
}

/*
 * Select card type based upon string passed
 */
- (CreditCardType)selectCreditCardFromString:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *keys = [self.cardInfo allKeys];
    for(NSNumber *cardType in keys) {
        NSDictionary *cardInfo = [self.cardInfo objectForKey:cardType];
        NSError *error = NULL;
        NSString *pattern = [cardInfo valueForKey:@"regexs"];
        if([pattern isKindOfClass:[NSString class]]){
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
            NSUInteger numberOfMatches = [regex numberOfMatchesInString:string
                                                            options:0
                                                              range:NSMakeRange(0, [string length])];
            if(numberOfMatches > 0) {
                return [cardType intValue];
            }
        }
    }
    return kDefault;
}

// Validate credit card number based upon LUHN algorithm
- (BOOL)validateCreditCardNumber:(NSString *)string {
    BOOL retVal = false;
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSUInteger len = [string length];
    unichar buffer[len+1];
    [string getCharacters:buffer range:NSMakeRange(0, len)];
    
    NSMutableArray *numbers = [NSMutableArray new];
    for(int i = 0;i < len;i++) {
        [numbers addObject:[NSNumber numberWithUnsignedChar:buffer[i]-'0']];
    }
    NSMutableArray* reversedArray = [[[numbers reverseObjectEnumerator] allObjects] mutableCopy];
    int finalSum = 0;
    for(int i = 0;i < [reversedArray count];i++) {
        if(i%2 == 1){
            int temp = [reversedArray[i] intValue]*2;
            if(temp > 9) {
                temp = temp-9;
            }
            reversedArray[i] = [NSNumber numberWithInt:temp];
            finalSum += temp;
        }
        else {
            finalSum += [reversedArray[i] intValue];
        }
    }
    if(finalSum%10 == 0) retVal = TRUE;
    return retVal;
}

@end
