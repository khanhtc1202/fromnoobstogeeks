---
title: Using Package Manager ??
date: 2018-06-19 01:13:17
tags: 
- manual
- package manager
- dev tool
---

Từ cái ngày trẻ trâu copy icon half-life vào usb cho đến khi biết click next next next trong installer của mấy cái app trên windows, bây giờ nhìn lại với mình vẫn là cả một bầu trời kỉ niệm :)) Từ hồi đó cũng gọi là có biết chút ít cái shell của windows nhưng cũng chẳng mấy khi động đến. Cho đến khi lần đầu tiếp xúc với linux, tương tác hồi đó vẫn chủ yếu là trỏ chuột. Dần dần khi đã quen và tương tác chuyển dần sang terminal, cảm giác cài app với command kể cũng ngầu ngầu :)).

<!-- more -->

Sự thần thánh của các package manager là không phải bàn cãi. Khi mới chuyển sang làm quen thử với bất cứ một bản distro nào mới, gần như việc đầu tiên mà bạn vô thức làm sẽ là kiểm tra xem package manager của distro đó là gì. Những cái tên không cần nhắc ai cũng biết đến như: `apt` cho debian base distro, `yum` cho redhat, `pacman` cho arch,... Những gói này được gọi là các `distribution package manager` (để phân biệt với 1 loại package manager nữa sẽ nói bên dưới).

![](https://i.imgur.com/UeyPZjT.png)

Đặc biệt hơn, khi các ngôn ngữ lập trình cũng đều học theo tư tưởng đó, xây dựng những build automation tool cực mạnh như `gradle` của java, `npm` của nodeJS,... Bản thân một phần nhiệm vụ quan trong mà những tool đó đều có chính là package (dependencies) management.

Do chẳng có gì ngoài thời gian rảnh :)) mình đã cài và dùng thử qua kha khá package manager khác nhau (thuộc cả 2 "loại" package manager kể trên), tuy nhiên do chưa có điều kiện, đến tận khi đi làm, mình mới được sờ đến ~~MacBook~~ OS X (một phần cũng do mình không thích hackintosh). 

Khi lần đầu được sờ đến `homebrew`, cảm nhận đầu tiên của mình là mình __không thích nó__ :)) Lý do vì đơn giản là mình anti ruby, chỉ đơn giản vậy thôi :(. Tuy nhiên, trải nghiệm sử dụng thì hoàn toàn ngược lại với cảm nhận ban đầu :)) Cộng đồng support cho brew rất mạnh, bất cứ khi nào muốn cài đặt một gói nào đó, hầu như luôn có thể tìm thấy cách cài trực tiếp chỉ bằng 1,2 command dùng homebrew, có lẽ lý do cũng tương tự như tại sao nếu làm app mobile thì nên ưu tiên làm cho iOs :)).

Một thời gian dài trải nghiệm sự tiện lợi của homebrew, bản thân mình cũng bị lười đi :)) Mình bỏ thói quen tự setup `PATH`, tự build source,...dần dần tất cả giao cả lại cho brew là được. Nhưng đời ếu như mơ, thứ đem lại cái cảm giác tiện lợi đó không phải magic. Chỉ đơn giản là cái phần tay to ngày trước mình làm, package manager dev team đã viết thành code, mà cái gì có code thì rồi nó cũng sẽ có bug :)) 

Sau một lần *lỡ tay* làm cái gì đấy mà mình cũng không nhớ :)) `npm` trong máy của mình không thể cài các package với flag global (kể cả chỉ định chạy dưới quyền su). Lúc đấy thì vẫn như mọi khi, mình nghĩ đơn giản chỉ cần (tư dư cố hữu của dev - cái gì sai thì reset)

```bash
$ # remove old node and its config
$ brew uninstall node && brew prune
$ rm -f /usr/local/bin/npm /usr/local/lib/dtrace/node.d ~/.npm
$ # reinstall node
$ brew install node
```

Cứ nghĩ là đến đây là êm xuôi...nhưng mọi chuyện lại không đơn giản như vậy :( Tại thời điểm lúc đó, brew tool đang có lỗi trong cài đặt gói `npm` - gói đi kèm khi cài đặt `node`. Vấn đề có vẻ nằm ở chính việc cố gắng update npm bằng lệnh `npm update npm -g` theo như giải thích ở [đây](https://gist.github.com/DanHerbert/9520689). Nguyên văn đoạn cần đọc 

> The root of the the issue is really that npm is its own package manager and it is therefore better to have npm manage itself and its packages completely on its own instead of letting Homebrew do it.

Chính việc sử dụng nhiều package manager bản thân nó cũng gây ra vấn đề :)) Lỗi đã được báo lần đầu cách đây 4 năm nhưng có vẻ vì một lý do nào đó, nó lại xuất hiện trong thời gian gần đây ( để ý `Last active` của gist trên chỉ trong khoảng 1 tuần gần đây ). Câu trả lời cho vấn đề và một cách giải quyết chi tiết hơn có thể được tìm thấy ở [đây](https://gist.github.com/rcugut/c7abd2a425bb65da3c61d8341cd4b02d). 

Điểm chung của những cách trên đối với mình là nó *quá dài* và nhiều bước config, còn mình thì lại lười và ngại đọc :( Để giải quyết tình hình, và cũng do có chút thời gian rảnh ( thực ra là nhiều vãi ), mình quyết định trở lại như xưa - không dùng manager tool nữa mà manual __^^'__.

Về cơ bản thì các gói đều có source file và build script, có thể tìm và tải chúng ( từ trang chủ đối với các gói nổi tiếng nhiều người dùng ) dưới dạng các file nén - thường là `.tar.gz`. 

Ví dụ để cài node từ source đơn giản có thể làm theo các bước sau:

1. Tải source & giải nén: với node có thể tìm thấy tại [đây](https://nodejs.org/dist/).
```
$ wget -qO- https://nodejs.org/dist/v8.11.3/node-v8.11.3-darwin-x64.tar.gz \
 | tar xvz
```
2. Copy thư mục source sang `/usr/local/bin` (lưu ý nên để ở đây thay vì `/usr/bin` đối với source locally compiled)
```bash
$ sudo mv node-v8.11.3-darwin-x64/ /usr/local/node
```
3. Thêm path đến bin/ của node vừa copy vào `$PATH`
```bash
$ echo "export PATH=$PATH:/usr/local/node/bin" >> $YOUR_SHELL_RC
```
Lưu ý: trong trường hợp trong bin/ của package sau giải nén chưa có nội dung (source chưa được build), đọc README và build lại theo hướng dẫn là cách đơn giản hơn nhiều so với việc tiếp tục mò google với hi vọng tìm được một cách ăn sẵn nào đó :))

DONE! Đơn giản và không phải đau đầu về vụ depend lẫn nhau giữa các package manager nữa :)) Về cơ bản thì mình thấy cách cài từ source có xịt thì cũng là do bạn thôi, không phải đổ lỗi cho người khác nữa nên đỡ mất công tìm :))

Đến đây là hết rồi :)) Dạo gần đây mình cũng lười, nên viết lại cái note coi như tự nhắc nhở bản thân :v Về cơ bản là __không có magic__ - chỉ __là code của một người nào đó chạy ở chỗ nào đó__ khác thôi, cứ từ từ mà tìm :)).

P/S: Install script tải node theo flow trên có thể tìm thấy tại [đây](https://gist.github.com/khanhtc1202/ef1a256223c804364e692f2d6dff02ca) hoặc tải trực tiếp tại [đây](https://gist.githubusercontent.com/khanhtc1202/ef1a256223c804364e692f2d6dff02ca/raw/7c7e80e704a5901896d876a70ddcdf71e65a540e/install-node-js).