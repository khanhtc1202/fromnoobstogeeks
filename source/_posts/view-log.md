---
title: Log Viewer via HTTP
date: 2018-03-30 17:17:44
tags:
---

Nhân một cuối tuần rảnh rỗi cao hứng nào đấy, mình đã build [một hệ thống nhỏ](http://fromnoobstogeeks.com:7001/videos) - mục đích chính để nó giúp mình `clone tự động anime mới` từ các trang mình đã thu thập rss (phần vì mình lười down từng tập, phần do đợt này mình hay quên nên @@). 

Do là cái hệ thống viết chơi bời trong 2 ngày nghỉ nên nó thiếu đủ thứ m(- -)m... Lúc đầu, mình chỉ tập trung vào viết cho nó chạy, nhưng thời gian đầu - do một số lý do khó nói - mà nó chết sập liên tục @@ mình bắt đầu nghĩ đến logging, tất nhiên là log ra file thôi...Sau đấy một thời gian khi đã chạy khá ổn định, dần dần bản thân việc `mò vào server để mở file log ra đọc` mình cũng lười nốt m(- -)m nên bắt đầu nghĩ xem có cách nào đơn giản (không phải cài hay dùng thêm dịch vụ ngoài nào) mà có thể giúp xem luôn log file ở server từ trình duyệt không :)) 

Ý tưởng giải quyết vấn đề của mình như sau: Nếu có thể serve text data trong log file như data thông thường và gửi chúng trong response trả về thì vấn đề cần giải quyết chỉ là `làm cách nào để lấy được log data dưới dạng stream và dán nó lên stream data của response` - giải quyết được vấn đề này thì có thể đọc log qua http thông qua 1 request đơn giản lên server rồi. (Lý do phải đọc log data từ log file dưới dạng stream là do log file lớn đọc trong 1 lần thì tốn ram quá, nhất là với cái server dùng ké của mình @@)

Từ đó mình nghĩ các bước thực hiện như sau (do mình đã viết hết xong khung cho hệ thống từ trước nên bước viết endpoint mới là dễ dàng thực hiện nên không được list ra ở đây):
1. Tìm cách đọc stream data từ log file (ở đây mình nghĩ ngay đến `tail` :)) )
2. Tìm cách gọi được stream đó từ source code ( server của hệ thống mình viết bằng nodejs )
3. Gắn stream data đọc được lên stream data của response trả về.
4. DONE!!!

Bắt tay vào làm nào :))

Trong nodejs, để sử dụng các linux command, cách đơn giản nhất là sử dụng thư viện [child_process](https://nodejs.org/api/child_process.html), về cơ bản khi dùng method `spawn()` của thư viện này, 1 process mới được sinh ra và gán cho `<ChildProcess> object` thực hiện command và trả về kết quả bạn có thể gọi được thông qua property `.stdout`.

```javascript
    ...
    var spawn = require('child_process').spawn;
    ...
    obj.show = function(req, res, next) {
        res.header('Content-Type','text/html;charset=utf-8');
        var tail = spawn('tail', ['-f', config.app.logPath]);
        console.log(tail.stdout);
    };
```

kết quả thu được 

```bash
[nodemon] starting `node app.js`
Loaded: log controller.
Loaded: monitor controller.
Loaded: streamer controller.
Loaded: videos controller.
Server running on 127.0.0.1: 3000
Loaded file [Fuyu] Citrus - 12 [720p].mkv ready to view!
Loaded file [Fuyu] Hakumei to Mikochi - 11 [720p].mkv ready to view!
Loaded file [Fuyu] Killing Bites - 11 [720p].mkv ready to view!
...
```

Có vẻ đã get stream thành công :)) giờ gán nó cho data stream của response là xong :)

```javascript
    ...
    var spawn = require('child_process').spawn;
    ...
    obj.show = function(req, res, next) {
        res.header('Content-Type','text/html;charset=utf-8');
        var tail = spawn('tail', ['-f', config.app.logPath]);
        tail.stdout.pipe(res);
    };
```

Ở đây mình dùng `pipe()` để stream đọc được đang ở `stdout` của process sinh ra bởi spawn() được viết thẳng sang cho res (socket) :)) chắc cũng không hẳn là socket nhưng theo ý hiểu ở đây có thể coi nó gần giống như vậy :D lý do vì

![Imgur](https://i.imgur.com/LucItFe.png?1)

Như đã thấy trong hình trên, stream data của response chưa bắt được event end :)) lý do vì stdout của process đang chạy lệnh tail vẫn chưa hoàn thành (vì nó là tail mà :) ). Như vậy nếu bây giò mình viết thêm gì đấy vào file log thì trên trình duyệt, nội dung của tab log mình đang xem cũng thay đổi luôn - quá tuyệt :)) thử nào...

![Imgur](https://media.giphy.com/media/cm1SRZW8XOEGFZNy8V/giphy.gif)

Bản `uncensored` có thể xem tại [đây](https://youtu.be/41XIFcZKfEU).

Done!!! :)))) vậy là đã hoàn thành việc view log thông qua http, lại còn realtime nữa chứ :))))...

Nhưng có gì đấy không đúng ở đây @@ Nếu như mình ngắt kết nối đến server (tắt cái tab đang nhận log ở trình duyệt) thì sẽ thế nào với cái process get log stream :v
Nghĩ thế nên mình lại vào server check lại và...

```shell
$ ps aux | grep tail
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root     12951  0.0  0.0   4408   248 pts/3    S+   07:55   0:00 tail -f logs/run.log
root     12961  0.0  0.0   4408   248 pts/3    S+   07:59   0:00 tail -f logs/run.log
root     12971  0.0  0.0   4408   248 pts/3    S+   08:05   0:00 tail -f logs/run.log
```

Không ổn!!! Thế này đọc log 100 lần thì có cả trăm cái process chạy tail nó lưu lại ở server, nghĩ đến thôi đã thấy rùng mình @@.

Hiện trạng của cái log view như sau:

![Imgur](https://i.imgur.com/vJbERcj.jpg)

Vấn đề hiện tại sẽ được giải quyết nếu bắt được trạng thái data stream của response bị terminated! Và rất may đây là nodejs :)) chẳng có gì ngoài event, do vậy vấn đề sẽ được giải quyết dễ dàng khi sửa đoạn code gán stream data như sau.

```javascript
    ...
    var spawn = require('child_process').spawn;
    ...
    obj.show = function(req, res, next) {
        res.header('Content-Type','text/html;charset=utf-8');
        var tail = spawn('tail', ['-f', config.app.logPath]);
        res.on('close', function(){
            console.log("Response ended");
            tail.kill("SIGINT");
        }).on('finish', function() {
            console.log("Response finished successfully");
            tail.kill("SIGINT");
        });
        tail.stdout.pipe(res);
    };
```

Ở đây `'close'` là event sẽ được bắt khi response connection bị ngắt đột ngột và `'finish'` là event hit khi response connection bị đóng do lý do tự nhiên (timeout của trình duyệt chẳng hạn). Khi bắt được event này, chỉ cần `kill` process đang chạy lệnh tail là xong (giống như lệnh kill trong linux thông thường).

Ok giờ thử lại nào! Đây là trạng thái của server khi có request đọc log đến.

![Imgur](https://i.imgur.com/oxoyhf4.png)

Và giờ thì thử ngắt nó đi :))))

![Imgur](https://i.imgur.com/pkxmpfI.png)

DONE!!!! Lần này thì có vẻ không còn vấn đề nào nữa :)))
Định lười nhưng cuối cùng thành ra khá lòng vòng mới có thể giải quyết hết vấn đề @@ Nên nếu có cần đưa ra kết luận gì đó thì sẽ là đừng lười như mình, kết quả không tốt đẹp gì đâu :)))

P/S:

Repo source code của hệ thống clone anime cho bạn nào quan tâm:

https://github.com/khanhtc1202/animu-crawling-system

Bạn nào ngại cài lại thì down chung từ server của mình cũng được :))) 

Nhân đây mình còn rất nhiều cuối tuần rảnh rỗi @@ còn hứng thì lúc nào cũng có :)) bạn nào có ý tưởng gì hay sẵn sàng chia sẻ thì mình xin một chân ngồi hóng nhé :))).
