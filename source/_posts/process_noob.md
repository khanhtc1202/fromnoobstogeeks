---
title: Process nooooob
date: 2018-02-05 22:20:07
tags:
---

Chắc chắn ai cũng đã từng nghe đến nhàm tai về `Linux là một hệ điều hành mở`, và mở ở đây là ý chỉ việc cho người dùng tất cả những quyền hạn mà người dùng xứng đáng có, mở về thông tin, về những gì đang thực sự chạy trên cái máy tính của bạn. Một cách tổng quát, hệ điều hành (OS) trên máy tính của bạn giống như người giúp việc của bạn, và việc nó giúp bạn là quản lý những thằng program khác chạy trên máy tính của bạn. Ở góc nhìn của hệ thống, OS quản lý dựa trên đơn vị là các `process`, có thể coi một cách gần đúng `mỗi program có một process` tương ứng với nó và OS thực hiện nhiệm vụ quản lý các program dựa trên các `process` này.


![OS controlling program](https://i.imgur.com/nP920jd.jpg)

Trong hệ thống linux, các process được đánh dấu bởi thông tin là các `PID` tương ứng chỉ sự 