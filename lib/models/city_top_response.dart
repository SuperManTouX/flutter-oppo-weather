// 热门城市模型类
// city_top_response
// {
//   "code":"200",
//   "topCityList":[
//     {
//       "name":"北京",
//       "id":"101010100",
//       "lat":"39.90499",
//       "lon":"116.40529",
//       "adm2":"北京",
//       "adm1":"北京市",
//       "country":"中国",
//       "tz":"Asia/Shanghai",
//       "utcOffset":"+08:00",
//       "isDst":"0",
//       "type":"city",
//       "rank":"10",
//       "fxLink":"https://www.qweather.com/weather/beijing-101010100.html"
//     },
//     {
//       "name":"朝阳",
//       "id":"101010300",
//       "lat":"39.92149",
//       "lon":"116.48641",
//       "adm2":"北京",
//       "adm1":"北京市",
//       "country":"中国",
//       "tz":"Asia/Shanghai",
//       "utcOffset":"+08:00",
//       "isDst":"0",
//       "type":"city",
//       "rank":"15",
//       "fxLink":"https://www.qweather.com/weather/chaoyang-101010300.html"
//     },
//     {
//       "name":"海淀",
//       "id":"101010200",
//       "lat":"39.95607",
//       "lon":"116.31032",
//       "adm2":"北京",
//       "adm1":"北京市",
//       "country":"中国",
//       "tz":"Asia/Shanghai",
//       "utcOffset":"+08:00",
//       "isDst":"0",
//       "type":"city",
//       "rank":"15",
//       "fxLink":"https://www.qweather.com/weather/haidian-101010200.html"
//     },
//     {
//       "name":"深圳",
//       "id":"101280601",
//       "lat":"22.54700",
//       "lon":"114.08595",
//       "adm2":"深圳",
//       "adm1":"广东省",
//       "country":"中国",
//       "tz":"Asia/Shanghai",
//       "utcOffset":"+08:00",
//       "isDst":"0",
//       "type":"city",
//       "rank":"13",
//       "fxLink":"https://www.qweather.com/weather/shenzhen-101280601.html"
//     },
//     {
//       "name":"上海",
//       "id":"101020100",
//       "lat":"31.23171",
//       "lon":"121.47264",
//       "adm2":"上海",
//       "adm1":"上海市",
//       "country":"中国",
//       "tz":"Asia/Shanghai",
//       "utcOffset":"+08:00",
//       "isDst":"0",
//       "type":"city",
//       "rank":"11",
//       "fxLink":"https://www.qweather.com/weather/shanghai-101020100.html"
//     },
//     {
//       "name":"浦东新区",
//       "id":"101020600",
//       "lat":"31.24594",
//       "lon":"121.56770",
//       "adm2":"上海",
//       "adm1":"上海市",
//       "country":"中国",
//       "tz":"Asia/Shanghai",
//       "utcOffset":"+08:00",
//       "isDst":"0",
//       "type":"city",
//       "rank":"15",
//       "fxLink":"https://www.qweather.com/weather/pudong-101020600.html"
//     }
//   ],
//   "refer":{
//     "sources":[
//       "QWeather"
//     ],
//     "license":[
//       "QWeather Developers License"
//     ]
//   }
// }
import 'package:flutter_oppo_weather/models/search_city.dart';
import 'package:flutter_oppo_weather/models/weather/refer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_top_response.g.dart';

/// 城市Top数据总响应模型
@JsonSerializable()
class CityTopResponse {
  /// 响应状态码（如200表示成功）
  final String code;

  /// 热门城市列表
  final List<SearchCity> topCityList;

  /// 数据来源及许可信息
  final Refer refer;

  /// 构造函数
  CityTopResponse({
    required this.code,
    required this.topCityList,
    required this.refer,
  });

  /// 从JSON映射为模型对象（由json_serializable生成）
  factory CityTopResponse.fromJson(Map<String, dynamic> json) =>
      _$CityTopResponseFromJson(json);

  /// 将模型对象转换为JSON（由json_serializable生成）
  Map<String, dynamic> toJson() => _$CityTopResponseToJson(this);
}