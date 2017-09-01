# XianYu
Implement some aspects of a sale platform(XianYu published by Alibaba)

Development language: Objective-C

Tools: XCode 7.2

Target platform: iOS 9.0

### Third-party library used

Name | Explain
--------- | -------------
SDWebImage | [Display network image with cache](https://github.com/rs/SDWebImage)
MJRefresh | [An easy way to use pull-to-refresh](https://github.com/CoderMJLee/MJRefresh)

### Main Page

<img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/Main%20Page.png" width="300">
  
#### Tab bar

<img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/tab%20bar.png" width="300">

embed add button in tab bar.

### Goods List

<img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/table%20view.png" width="300">

To improve efficiency of loading cell, I calculate the height of each cell before it is drawn and store the height in model. When cell would be shown, I can access the height stored in model directly instead of computing to avoid the delay of loading cell.

<figure class="half">
  <img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/refresh-01.jpg" width="300">
  <img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/refresh-02.jpg" width="300">
</figure>

Pull to refresh with animation.

### Photo Selection

### Search item

### Application setting

<If you want to see the vidoe, please click the link https://www.youtube.com/embed/MjRm-qUV3hE>
