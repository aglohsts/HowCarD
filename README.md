HowCarD+
===
![](https://i.imgur.com/BwMGY5w.png) 

[![](https://i.imgur.com/A85x7hD.png)](https://testflight.apple.com/join/uk1Rll8L)  Download here :point_right: https://testflight.apple.com/join/uk1Rll8L

## General Info

整理信用卡及相關的優惠資訊，讓擁有多張卡片的小資族群能在對的時間刷對的卡，將回饋最大化。

![](https://i.imgur.com/YQHNLEN.png) ![](https://i.imgur.com/6zocHCy.png) ![](https://i.imgur.com/GyvNjmb.png) ![](https://i.imgur.com/H8yWEDz.png)

## Skills
* 於物件間廣泛使用 **closure** 進行溝通。
* 使用 **weak**、**unowned** 處理 memory leak 及 retain cycle 的問題。
* 使用 **WKWebView** 讓使用者於 App 中瀏覽網頁，並透過 **Key-Value Observing** 追蹤使用者行為。
* 以 **Notification Center** 於不同 view controller 間溝通，當有指定事件發生時即 post notification。

## Features
* **D+ 精選** 
    * 分為 4 類別，最新卡片、最新優惠、精選卡片、精選優惠。
    * 使用 Library：`FoldingCell`。

* **卡好康**
    * 呈現信用卡相關的優惠資訊。
    * 將 `UICollectionView` 置於 `UITableViewCell` 中。
    
* **卡了解**
    * 簡介信用卡，並可點選按鈕以查看詳細資訊。
    * 提供連至信用卡簡介官網及申辦卡片的按鈕方便使用者進一步了解。
    * 使用者能收藏卡片如果已擁有該卡。
    * 若使用者對該卡感興趣，可先將卡片收藏並在 `卡收好` tab 查看。
* **卡收好**
    * 分為 3 類別: 我的卡片、喜歡的優惠、已收藏卡片。
    * 以 `UIScrollView` 方便使用者左右滑動切換不同的類別。
    
* **卡客服**
    * 方便使用者於需要時能即時打電話聯絡客服或連至銀行留言頁面（若該銀行有提供留言功能）。

## Libraries
* Fabric
* Crashlytics
* SwiftLint
* Kingfisher
* IQKeyboardManager
* Firebase SDK
* FoldingCell
* HFCardCollectionViewLayout
* NVActivityIndicatorView

## Requirement
* iOS 11.0+
* Xcode 10.2

## Contacts
**Agnes Lo** :email: lohsts@gmail.com
