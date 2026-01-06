import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/constants/index.dart';
import 'package:flutter_oppo_weather/routes/index.dart';
import 'package:flutter_oppo_weather/services/weather/weather_service.dart';
import 'package:flutter_oppo_weather/models/weather/weather_models.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';
import 'package:flutter_oppo_weather/widget/Icon.dart';
import 'package:flutter_oppo_weather/utils/oppo_date_utils.dart';
import 'package:jiffy/jiffy.dart';

class WeatherPage extends StatefulWidget {
  // 城市位置信息参数
  final DisplayCity location;
  final bool isSearchResult;
  // 城市列表长度
  final int cityListLength;
  // 当前城市索引
  final int currentCityIndex;

  // 收藏按钮点击回调
  final Function(DisplayCity?)? onFavoritesPress;

  const WeatherPage({
    super.key,
    this.location = const DisplayCity(name: '北京', id: '101010100', latitude: "39.9042", longitude: "116.4074"),
    this.isSearchResult = false,
    this.cityListLength = 0,
    this.currentCityIndex = 0,

    this.onFavoritesPress,
  });

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // 实时天气返回体
  WeatherNowResponse? _nowResponse;

  // 7天天气数据 [0]是今天的天气
  List<Daily> _forecastData = [];

  // 逐小时天气数据
  List<Hourly> _hourlyData = [];

  // 加载状态
  bool _isLoading = false;

  // 实时天气数据的getter
  Now get now => _nowResponse!.now;

  // 今日天气详情的getter
  Daily get dayDetail => _forecastData![0];

  // 获取屏幕宽度
  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // 获取实时天气数据
  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final service = QWeatherService();
      final data = await service.getWeatherNow(id: widget.location.id);
      setState(() {
        _nowResponse = data;
        _isLoading = false;
      });
    } catch (e) {
      print('获取天气数据失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 获取七天的天气数据
  Future<void> _fetchWeatherForecast() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final service = QWeatherService();
      final data = await service.getWeather7d(location: widget.location.id);
      setState(() {
        _forecastData = data.daily;
        _isLoading = false;
      });
    } catch (e) {
      print('获取天气数据失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 获取24小时天气数据
  Future<void> _fetchWeather24h() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final service = QWeatherService();
      final data = await service.getWeather24h(location: widget.location.id);
      setState(() {
        _hourlyData = data.hourly;
        _isLoading = false;
      });
    } catch (e) {
      print('获取24小时天气数据失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 自动获取天气数据
    _fetchWeatherData();
    // 自动获取7天天气数据
    _fetchWeatherForecast();
    // 自动获取24小时天气数据
    _fetchWeather24h();
    print('初始化天气页面: ${widget.location.name}, ${widget.location.latitude}, ${widget.location.longitude}');
  }

  @override
  void didUpdateWidget(covariant WeatherPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当location参数变化时，重新获取天气数据
    if (oldWidget.location.id != widget.location.id) {
      _fetchWeatherData();
      _fetchWeatherForecast();
      _fetchWeather24h();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !widget.isSearchResult
          ? AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text('${widget.location.name}'),
              actions: [
                TextButton(
                  onPressed: () {
                    // 跳转到细节界面
                    Navigator.pushNamed(context, RouteNames.detail, arguments: widget.location);
                  },
                  child: Text("跳转到细节界面"),
                ),
                IconButton(
                  onPressed: () {
                    // 收藏列表按钮不传递城市信息
                    if (widget.onFavoritesPress != null) {
                      widget.onFavoritesPress!(null);
                    }
                  },
                  icon: NetIcon(name: GlobalConfig.SYS_ICON["城市列表"]!, size: 24),
                  tooltip: '城市列表',
                ),
                IconButton(
                  onPressed: _fetchWeatherData,
                  icon: const Icon(Icons.refresh),
                  tooltip: '刷新数据',
                ),
              ],
            )
          : AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.location.name),
              actions: [
                TextButton(
                  onPressed: () {
                    // 取消按钮不传递城市信息
                    if (widget.onFavoritesPress != null) {
                      widget.onFavoritesPress!(null);
                    }
                  },
                  child: Text(
                    '取消',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (widget.onFavoritesPress != null &&
                        _nowResponse != null) {
                      final city = DisplayCity(
                        name: widget.location.name,
                        id: widget.location.id,
                        latitude: widget.location.latitude,
                        longitude: widget.location.longitude,
                        now: _nowResponse!.now,
                      );
                      widget.onFavoritesPress!(city);
                    }
                  },
                  child: Text(
                    '添加',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
      body: SafeArea(
        child: Container(
          child: _isLoading
              ? _buildLoadingUI()
              : _nowResponse != null
              ? _buildWeatherUI()
              : _buildErrorUI(),
        ),
      ),
    );
  }

  // 构建天气UI
  Widget _buildWeatherUI() {
    return RefreshIndicator(
      onRefresh: () {
        return Future.wait([
          _fetchWeatherData(),
          _fetchWeatherForecast(),
          _fetchWeather24h(),
        ]);
      },
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                GlobalConfig.Gradient_Colors_Weather2English[now.text] != null
                ? GlobalConfig.Gradient_Colors_Weather2English[now.text]
                      as List<Color>
                : [Color.fromARGB(0, 231, 102, 102), Colors.transparent],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 天气图标和温度
                  _buildNow(),
                  SizedBox(height: 30),
                  // 更新时间
                  Text(
                    textAlign: TextAlign.center,
                    '更新时间: ${_formatTime(_nowResponse!.updateTime)}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  // 城市切换原点指示器
                  !widget.isSearchResult && widget.cityListLength > 1
                      ? _buildCityIndicator()
                      : SizedBox(height: 0),
                  SizedBox(height: 30),
                  // 实时小时天气
                  _buildHourly(),
                  SizedBox(height: 30),
                  // 未来七天天气
                  _buildForecast(),
                  SizedBox(height: 30),
                  // 天气详情
                  _buildDetail(),
                  SizedBox(height: 30),
                  // 日出时间
                  _buildSunrise(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 城市切换原点指示器
  Widget _buildCityIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.cityListLength, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == widget.currentCityIndex
                ? Colors.white
                : Colors.white.withOpacity(0.5),
          ),
        );
      }),
    );
  }

  // 当前气温
  Widget _buildNow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 天气图标 (使用占位符，实际项目中可以根据icon值显示对应的图标)
        SizedBox(
          width: 80,
          height: 80,
          child: QIcon(iconCode: now.icon, size: 10),
        ),
        SizedBox(width: 10),
        // 温度
        Column(
          children: [
            Text(
              '${now.temp}°',
              style: const TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '${now.text}  ${dayDetail.tempMin}°/ ${dayDetail.tempMax}°',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  // 实时小时天气
  Widget _buildHourly() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: const Color.fromARGB(69, 116, 114, 114),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _hourlyData?.length ?? 0,
        itemBuilder: (context, index) {
          final Hourly hour = _hourlyData![index];
          final String day = Jiffy.parse(
            hour.fxTime,
            pattern: "yyyy-MM-dd'T'HH:mmZ",
          ).format(pattern: "HH:mm");
          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.detail,
                  arguments: {"location": widget.location, "index": 0},
                );
              },
              borderRadius: BorderRadius.circular(5),
              child: Container(
                width: 80,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // 小时时间格式 HH:mm
                      day,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    // 天气图标
                    QIcon(iconCode: hour.icon, size: 20),

                    Text(
                      '${hour.temp}°',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 未来七天天气
  Widget _buildForecast() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ...List.generate(7, (index) {
            final Jiffy JDay = Jiffy.parse(_forecastData![index].fxDate);
            final String day = JDay.format(pattern: "MM月dd日");

            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.detail,
                  arguments: {"location": widget.location, "index": 1,"clickedJDate":JDay},
                );
              },
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 40, // 固定行高
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        day,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      // jiffy计算星期几
                      Text(
                        OppoDateUtils.getWeekdayText(JDay),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      // 天气图标
                      Expanded(
                        child: QIcon(
                          iconCode: '${_forecastData![index].iconDay}-fill',
                          size: 20,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          textAlign: TextAlign.right,
                          '${_forecastData![index].tempMin}°/${_forecastData![index].tempMax}°',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.detail,
                  arguments: {"location": widget.location, "index": 2},
                );
              },
              child: Text(
                '未来15天天气详情',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 天气详情
  Widget _buildDetail() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: getScreenWidth(context) > 600 ? 6 : 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildDetailItem('体感温度', '${now.feelsLike}°C'),
        _buildDetailItem('湿度', '${now.humidity}%'),
        _buildDetailItem('风向', now.windDir),
        _buildDetailItem('风力', '${now.windScale}级'),
        _buildDetailItem('气压', '${now.pressure}百帕'),
        _buildDetailItem('能见度', '${now.vis}km'),
      ],
    );
  }

  // 日出日落时间
  Widget _buildSunrise() {
    // 获取当前时间
    final nowTime = Jiffy.now();
    // 解析日出时间
    final sunriseParse = Jiffy.parse(dayDetail.sunrise, pattern: 'HH:mm');
    // 解析日落时间
    final sunsetParse = Jiffy.parse(dayDetail.sunset, pattern: 'HH:mm');
    // 重新设置时间为当前日期的日出日落时间
    final sunriseTime = Jiffy.parseFromMap({
      Unit.year: nowTime.year,
      Unit.month: nowTime.month,
      Unit.day: nowTime.date,
      Unit.hour: sunriseParse.hour,
      Unit.minute: sunriseParse.minute,
    });
    // 重新设置时间为当前日期的日落时间
    final sunsetTime = Jiffy.parseFromMap({
      Unit.year: nowTime.year,
      Unit.month: nowTime.month,
      Unit.day: nowTime.date,
      Unit.hour: sunsetParse.hour,
      Unit.minute: sunsetParse.minute,
    });

    // 计算日出到日落的总分钟数
    final totalMinutes = sunsetTime.diff(sunriseTime, unit: Unit.minute);

    // 计算当前时间与日出时间的分钟差
    final passedMinutes = nowTime.diff(sunriseTime, unit: Unit.minute);

    // 计算已过时间和未过时间的flex值
    int passedFlex = 0;
    int remainingFlex = 10;
    // 标记当前时间是否大于日落时间
    final isAfterSunset = nowTime.isAfter(sunsetTime);
    if (totalMinutes > 0) {
      // 定义计算占比的分子和分母
      num ratioNumerator = passedMinutes;
      num ratioDenominator = totalMinutes;

      // 若当前时间大于日落时间，交换分子和分母
      if (isAfterSunset) {
        final temp = ratioNumerator;
        ratioNumerator = ratioDenominator;
        ratioDenominator = temp;
      }

      // 计算已过时间占比
      final passedRatio = ratioNumerator / ratioDenominator;

      if (passedRatio <= 0) {
        // 还未日出
        passedFlex = 0;
        remainingFlex = 10;
      } else if (passedRatio >= 1) {
        // 已经日落（或交换后占比达到1）
        passedFlex = 10;
        remainingFlex = 0;
      } else {
        // 日出后日落前（或交换后合理占比区间），计算flex值
        passedFlex = (passedRatio * 10).round();
        remainingFlex = 10 - passedFlex;
      }
      // 关键：当前时间大于日落时间时，交换passedFlex和remainingFlex的结果
      if (isAfterSunset) {
        final tempFlex = passedFlex;
        passedFlex = remainingFlex;
        remainingFlex = tempFlex;
      }
    } else {
      print('总分钟数无效: $totalMinutes');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 出落图标
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  NetIcon(name: isAfterSunset ? 'sunset' : 'sunrise', size: 20),
                  Text(
                    isAfterSunset ? '日落' : '日出',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  NetIcon(name: isAfterSunset ? 'sunrise' : 'sunset', size: 20),
                  Text(
                    isAfterSunset ? '日出' : '日落',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 进度条
          Row(
            children: [
              // 已经过的时间
              Expanded(
                flex: passedFlex,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 146, 148, 150),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              // 图标
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: QIcon(iconCode: '${100}-fill', size: 20),
              ),
              // 未过的时间
              Expanded(
                flex: remainingFlex,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 8, 6, 6),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTime(dayDetail.sunrise),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                _formatTime(dayDetail.sunset),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 构建详情项元素
  Widget _buildDetailItem(String label, String value) {
    return InkWell(
      onTap: () {
        // 点击详情项时的操作
        print('点击了 $label: $value');
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 图标
            NetIcon(
              // 根据屏幕宽度调整图标大小
              size: getScreenWidth(context) > 600 ? 20 : 28,
              name: GlobalConfig.DETAIL_ICON[label]!,
            ),
            // 详情项标签
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 83, 81, 81),
              ),
            ),
            // 详情项值
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建加载UI
  Widget _buildLoadingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 天气相关图标
          Icon(
            Icons.cloud_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 20),
          // 加载进度指示器
          CircularProgressIndicator(
            strokeWidth: 4,
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(height: 20),
          // 加载文本提示
          Text(
            '正在获取天气数据...',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  // 构建错误UI
  Widget _buildErrorUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.red),
        const SizedBox(height: 20),
        const Text('获取天气数据失败', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _fetchWeatherData, child: const Text('重试')),
      ],
    );
  }

  // 格式化时间
  String _formatTime(String timeStr) {
    try {
      return Jiffy.parse(timeStr).format(pattern: 'HH:mm');
    } catch (e) {
      return timeStr;
    }
  }
}
