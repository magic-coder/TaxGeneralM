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
	UICollectionViewController
	UITableViewController
	UIScrollView
	UIPageControl
	WKWebView(UIWebView)

# 基础的核心类(Basic)
	BaseCollectionViewController
	BaseTableViewController
	BaseCordovaViewController
	BaseWebViewController
	BaseScrollView
	BaseTextField
	BaseSandBoxUtil
	
# 用到的第三方类库(Classlib)
	Masonry
	MJRefresh
	MJExtension
	AFNetworking
	MBProgressHUD
	WMPageController
	Cordova
	BaiduMap
	BaiduPush
	WUGestureUnlockView
	SDWebImage & FLAnimatedImage

# 自己进行封装的组件(Element)
	YZNetworkingManager
	YZProgressHUD
	YZAlertView
	YZTouchID(Reference : TDTouchID)
	YZRefreshHeader(Reference : MJRefreshHeader)
	YZYZActionSheet(Reference : LPActionSheet)
	YZMenu(Reference : YCXMenu)
	YZWebViewController(Reference : CHWebViewController)

# 自己扩展的类(Extend)
	UIView+YZ
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