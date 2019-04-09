//
//  CreditCardValidator.h
//  CreditCardValidator
//
//  Created by Aman Agarwal on 08/04/19.
//  Copyright © 2019 Assignment. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CreditCardType) {
    kDefault = 0,
    kAmericanExpress,
    kDinersClubCarteBlanche,
    kDinersClubInternational,
    kDiscover,
    kInstaPayment,
    kJCB,
    kMastero,
    kMasterCard,
    kVisa,
    kVisaElectron
};

@interface CreditCardValidator : NSObject

@property (nonatomic, strong) NSDictionary *cardInfo;

- (CreditCardType)selectCreditCardFromString:(NSString *)string;

- (BOOL)validateCreditCardNumber:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
