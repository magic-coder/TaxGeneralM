#TaxGeneralM
	This is TaxGeneralM project.(M -> Manager)
	互联网+税务(管理端)
	混搭模式：原生 + Web + (Cordova[Native H5])

# 项目结构(Construction)
* **Classes**：项目源码目录(包含全局、自定义、通用以及各模块目录，每个模块根据实际情况拥有对应的Controller、View、Model、Util)
* **Plugins**：插件目录(存放所有Cordova的Plugin类)
* **Venders**：第三方库目录
* **Resources**：资源目录
* **Supporting Files**：工具文件目录（如：main.m、info.plist、PrefixHeader.pch、*.storyboard文件、）

# 核心技术总结(Technology)
	UICollectionViewController(集合视图)
	UITableViewController(表格视图)
	UIScrollView(滚动视图)
	UIPageControl(多页滑动视图)
	WKWebView/UIWebView(Web视图)

# 基础的核心类(Basic)
	BaseCollectionViewController(通用的集合视图)
	BaseTableViewController(通用的表格视图)
	BaseCordovaViewController(通用的本地Cordova网页视图)
	BaseWebViewController(通用的网页视图)
	BaseScrollView(通用的滚动视图)
	BaseTextField(通用的输入框)
	BaseSandBoxUtil(通用的沙盒操作类)
	BaseHandleUtil(通用的处理方法)
	
# 用到的第三方类库(Classlib)
	Masonry(自动布局调整)
	MJRefresh(下拉刷新、上拉加载)
	MJExtension(json直接转换类)
	AFNetworking(网络连接)
	MBProgressHUD(悬浮提示框)
	WMPageController(分类标签页)
	Cordova(Cordova类库)
	BaiduMap(百度地图)
	BaiduPush(百度云推送)
	WUGestureUnlockView(手势密码)
	SDWebImage & FLAnimatedImage(异步请求加载图片支持https)
	Sangfor(深信服VPN)
	Reachability(检测网络链接状态)

# 自己进行封装的组件(Element)
	YZNetworkingManager(封装网络请求)
	YZProgressHUD(封装悬浮提示框)
	YZAlertView(封装弹框)
	YZTouchID(指纹识别)[Reference : TDTouchID]
	YZRefreshHeader(自定义下拉刷新视图)[Reference : MJRefreshHeader]
	YZYZActionSheet(自定义底部多选提示框)[Reference : LPActionSheet]
	YZMenu(自定义悬浮气泡菜单)[Reference : YCXMenu]
	YZWebViewController(自定义WebView视图)[Reference : CHWebViewController]
	YZCircleProgressButton(自定义倒计时动态按钮)[Reference : WSDrawCircleProgress]

# 自己扩展的类(Extend)
	UIView+YZ
	UIImage+YZ
	UIDevice+YZ	
	
# 系统色彩值(SystemColor)
	**Sytle One**
	红 #F86161	RGB(248,97,97)
	橙 #FCC015	RGB(252,192,21)
	蓝 #1893E3	RGB(24,147,227)
	绿 #39CE9F	RGB(57,206,159)
	**Sytle Two**
	红 #E8453C RGB(232,69,60)
	橙 #F6BC2D RGB(246,188,45)
	蓝 #4587F7 RGB(69,135,247)
	绿 #3AA756 RGB(58,167,86)