# XianYu
Implement some aspects of a sale platform (XianYu published by Alibaba)

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

#### Goods List

<img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/table%20view.png" width="300">

To improve efficiency of loading cell, I calculate the height of each cell before it is drawn and store the height in model. When cell would be shown, I can access the height stored in model directly instead of computing to avoid the delay of loading cell.

<figure class="half">
  <img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/refresh-01.jpg" width="300">
  <img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/refresh-02.jpg" width="300">
</figure>

Pull to refresh with animation.

#### Scroll View

<img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/scroll%20view.png" width="300">

Scroll automatically (manually) to display some image

### Photo Selection

#### Photo Picker

<figure class="half">
  <img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/photo%20picker%201.png.jpg" width="300">
  <img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/photo%20picker%202.png" width="300">
</figure>

User can choose photos under number limit by clicking check mark on left top corner of photo. User can manage his/her choice through the view on bottom. User can click photo to see full size photo.

#### Album Picker

<img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/album%20picker.png" width="300">

User can choose photos in different albums by switching album.

### Search item

<figure class="third">
  <img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/Search%20Advice.png" width="300">
  <img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/Search%20Result-01.png" width="300">
  <img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/Search%20Result-03.jpg" width="300">
</figure>

Search with search advice. When scroll the search results down, the search bar on top would be hidden. Otherwise, it would be shown.

### Application setting

<figure class="half">
  <img src="https://github.com/yuanzhihao/XianYu/raw/master/screen-shot-xianyu/Not%20Sign%20In.png" width="300">
  <img src="https://github.com/yuanzhihao/XianYu/blob/raw/screen-shot-xianyu/Not%20Sign%20In%20Setting.png" width="300">
</figure>

Setting of application is stored in UserDefaults. When entering setting page, the setting would be loaded.
