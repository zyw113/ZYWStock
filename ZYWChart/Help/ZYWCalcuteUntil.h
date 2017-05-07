//
//  ZYWCalcuteUntil.h
//  ZYWChart
//
//  Created by limc on 12/26/13.
//  Copyright (c) 2013 limc. All rights reserved.
// 

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MACDParameter) {
    MACDParameterDIFF,
    MACDParameterMACD,
    MACDParameterDEA,
};

void NSArrayToCArray(NSArray *array, double outCArray[]);

NSArray *CArrayToNSArray(const double inCArray[], int length, int outBegIdx, int outNBElement);

NSArray *CArrayToNSArrayWithParameter(const double inCArray[], int length, int outBegIdx, int outNBElement, double parmeter);

//  KDJ
NSArray *KDJCArrayToNSArray(const double inCArray[], int length, int outBegIdx, int outNBElement);

//  MACD类型
NSArray *MACDCArrayToNSArray(const double inCArray[], int length, int outBegIdx, int outNBElement, NSArray *items, MACDParameter parameter);

NSArray *MDCArrayToNSArray(const double inCArray[], int length, int outBegIdx, int outNBElement, NSArray *items);

void freeAndSetNULL(void *ptr);

CGFloat customComputeMA(NSArray *items, NSInteger days);
