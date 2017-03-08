//
//  RouteAnnotation.h
//  TaxGeneralM
//
//  Created by Apple on 2017/2/23.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface RouteAnnotation : BMKPointAnnotation

///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点  6:楼梯、电梯
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger degree;

//获取该RouteAnnotation对应的BMKAnnotationView
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview;

@end
