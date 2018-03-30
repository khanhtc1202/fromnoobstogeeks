---
title: Log Viewer via HTTP
date: 2018-03-30 17:17:44
tags:
---

Nhân một cuối tuần rảnh rỗi cao hứng nào đấy, mình đã build [một hệ thống nhỏ](http://fromnoobstogeeks.com:7001/videos) - mục đích chính để nó giúp mình *clone tự động anime mới* từ các trang mình đã thu thập rss (phần vì mình lười down từng tập, phần do đợt này mình hay quên nên @@). 

Do là cái hệ thống viết chơi bời trọng 2 ngày nghỉ nên nó thiếu đủ thứ m(-_-)m... Lúc đầu, mình chỉ tập trung vào viết cho nó chạy, nhưng thời gian đầu - do một số lý do khó nói - mà nó chết sập liên tục vì nhiều nguyên do nên mình bắt đầu nghĩ đến logging, tất nhiên là log ra file thôi...Sau đấy một thời gian khi đã chạy khá ổn định, bản thân việc *mò vào server để mở file log ra đọc* mình cũng lười nốt m(-_-)m nên bắt đầu nghĩ xem có cách nào đơn giản (không phải cài hay dùng thêm dịch vụ ngoài nào) mà có thể giúp xem luôn log file ở server từ trình duyệt không :)) 

Ý tưởng giải quyết vấn đề của mình như sau: Nếu có thể serve text data trong log file như data thông thường và gửi chúng trong response trả về thì vấn đề cần giải quyết chỉ là *làm cách nào để lấy được log data dưới dạng stream và dán nó lên response stream* - giải quyết được vấn đề này thì có thể đọc log qua http thông qua 1 request đơn giản lên server rồi. (Lý do phải đọc log data từ log file dưới dạng stream là do log file lớn đọc trong 1 lần thì tốn ram quá, nhất là với cái server dùng ké của mình @@)

Từ đó mình nghĩ các bước thực hiện như sau (do mình đã viết hết xong khung cho hệ thống từ trước nên bước viết endpoint mới là dễ dàng thực hiện nên không được list ra ở đây):
- tìm cách đọc stream data từ log file (ở đây mình nghĩ ngay đến `tail` :)) )
- tìm cách gọi được stream đó từ source code ( server của hệ thống mình viết bằng nodejs )
- gắn stream data đọc được lên stream data của response trả về.
- DONE!!!

![Imgur](https://i.imgur.com/oxoyhf4.png)

![Imgur](https://i.imgur.com/pkxmpfI.png)

P/S:

Repo source code của hệ thống clone anime cho bạn nào quan tâm:

https://github.com/khanhtc1202/animu-crawling-system

Bạn nào ngại cài lại thì down chung từ server của mình cũng được :))) 