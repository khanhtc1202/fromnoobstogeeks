---
title: Fun thing with browser inspect
date: 2018-08-31 02:55:20
tags:
---

Chắc hẳn ít ai có thể mạnh miệng khẳng định rằng: Trong suốt quãng thời gian từ khi biết đến internet cho đến hiện tại, chưa một lần từng tải nội dung số không vi phạm bản quyền trên internet. Nói vậy bởi vì đơn giản như một bức ảnh bạn tải từ 1 trang web đã public cũng có thể là ảnh được lấy một cách không chính thức từ một nguồn nào đó :)) Về phía người dùng, họ luôn muốn nhận nhiều hơn, ngược lại tất nhiên người sở hữu nội dung số (media content) không muốn vậy :))

<!-- more -->

Một cách chắc chắn, có thể nói, những gì đã hiển thị trên thiết bị của bạn, nó đã ở trong tay bạn - vấn đề chỉ là làm thế nào để lấy được nó thôi ( ͡° ͜ʖ ͡°) . Cũng như đã nói ở trên, việc chặn để người dùng không lấy content một cách dễ dàng là một vấn đề mà bất cứ người làm dịch vụ trực tuyến nào cũng phải giải quyết. Trong cả tá những cách hại não mà ai cũng có thể kể ra (mà chẳng biết có bao nhiêu người làm) thì một trong những phương pháp đơn giản nhưng có vẻ mang lại hiệu quả khá tốt là: chặn để người dùng __không tương tác trực tiếp__ được với content trên thiết bị của họ. Có cả đống cách dạng này kiểu như: chặn chuột phải, chặn inspect (của browser), mã hoá content trả về cho device,...và dù là cách nào thì nếu chịu khó mò cũng có thể qua được.

Chắc hẳn là developer, không ai lạ lẫm gì với công cụ inspect của trình duyệt. Nó là một công cụ tuyệt vời! Debug, view request, kiểm tra phần tử,...nếu hỏi một điểm bắt đầu tốt khi muốn "chôm" một cái gì đó từ web, chắc chắn là thử inspect nó :)).

Mọi chuyện sẽ chẳng có gì, nếu như hôm nay, trong khi đang tìm cách __lưu lại một số content đã hiển thị trên thiết bị cá nhân__, mình bắt gặp được một trường hợp khá thú vị như sau:

![gif](https://thumbs.gfycat.com/DistantKindlyCub-size_restricted.gif)

Công cụ inspect của trình duyệt gần như đã bị khoá bởi việc liên tục nhảy vào debugging mode (giống như break point mà các ide hỗ trợ) - một cách khá thông minh :)) Bất cứ khi nào next step, sẽ có 1 debugging block mới được sinh ra và trình duyệt sẽ lại nhảy vào debugging mode, đồng thời theo đó, chức năng kiểm tra phần tử hay bắt request thông qua network cũng sẽ bị khoá (do trình duyệt đang dump).

Lục mò đoạn code gây ra cái cách "khắm bựa" trên, mình bắt được đoạn js có vẻ hack não này

```javascript
!function() {
    !function t() {
        try {
            !function c(t) {
                (1 !== ("" + t / t).length || t % 20 === 0) && function(){}
                .constructor("debugger")(),
                    c(++t)
            }(0)
        } catch (n) {
            setTimeout(t, 1e3)
        }
    }()
}();
```

Để hiểu được đoạn code trên chúng ta tạm chấp nhận một số điểm sau trong js

```javascript
> !function foo() {}()          // will run foo()
> true && funtion foo() {}()    // will run foo()
> false && funtion bar() {} ()  // will not run bar()
```

Giải thích chi tiết hơn cho thứ bựa bên trên có thể tìm thấy tại [đây](https://stackoverflow.com/questions/3755606/what-does-the-exclamation-mark-do-before-the-function). 

Ý tưởng chính của đoạn code trên đến từ đoạn

```javascript
> !function () {}.constructor("debugger")()
```

Đem đoạn code trên chạy thử trên trình duyệt, kết quả sẽ na ná như sau

```javascript
> function a() {}
// undefined
> a.constructor("debugger")
// ƒ anonymous() { debugger }
```

`constructor` property trả về hàm contructor của function a, có một đặc điểm đặc biệt ở đây là, nếu thử 

```javascript
> function foo() {}
> foo.constructor
// ƒ Function() { [native code] }
```

Argument được truyền vào thông qua contructor được treat như là navtive code trong function :)). Do đó `a.constructor("debugger")` trong ví dụ trên sinh ra 1 hàm với thân hàm có nhiệm vụ duy nhất là trigger browser của bạn nhảy vào debug mode :)). Kết hợp với trick để run hàm phía bên trên, ta có được nhân của đoạn code block inspect là hàm `c()` như sau.

```javascript
!function c(t) {
    (1 !== ("" + t / t).length || t % 20 === 0) && function(){}
    .constructor("debugger")(),
        c(++t)
}(0)
```

- bootstrap hàm `c()` với giá trị t = 0
- check expression, expect giá trị `true` => gen hàm ƒ anonymous() { debugger }
- chạy hàm anonymous vừa gen trên, đưa browser về debug mode
- nếu user next step trong debug mode, gọi đệ quy hàm `c()`

Phần còn lại là `try catch` block, trong case lỗi thì tự động boostrap lại toàn bộ luồng trên sau 1s bằng `setTimeout()`. Để ý ở đây trong case biểu thức điều khiển sinh hàm `function(){}.constructor("debugger")()` nếu false và không được chạy nhiều lần, có khả năng đệ quy liên tục hàm `c()` và bạn sẽ nhận được lỗi dạng thế này

```
RangeError: Maximum call stack size exceeded
    at c (recursion.js:1)
    at c (recursion.js:7)
    at c (recursion.js:7)
    at c (recursion.js:7)
    at c (recursion.js:7)
    at c (recursion.js:7)
```

![imgur](https://i.imgur.com/Yixr3jv.gif)

Ok đến đây coi như đã hiểu thêm được một cách block user khá thú vị, tuy nhiên content thì mình vẫn muốn lấy ( ͡° ͜ʖ ͡°) . Tất nhiên, khi đã mò được đến đoạn code gây ra kết quả trên thì __chỉ cần xoá nó đi__ là xong :)) Tuy nhiên còn một cách khác (và nó là nguyên nhân chính khiến mình viết bài này), đó là dùng chính chức năng của browser - giống như cách mà dev "đối phương" dùng, lợi dụng tính năng debugger của browser!

![Imgur](https://i.imgur.com/vylppVW.png)

Đáp án ở ngay bên cạnh đề bài :)) Vị trí được trỏ đến trong ảnh là chức năng `Deactivate breakpoints` của browser, tất cả các breakpoint (bao gồm cả cách breakpoint sinh ra từ sau do hiệu quả của vòng đệ quy bên trên) đề sẽ bị vô hiệu ( ͡° ͜ʖ ͡°) .

Khi lần đầu mình gặp cách block người dùng này, mình đã nghĩ nó là bug do đội dev quên mất chưa xoá debugger ( ͡° ͜ʖ ͡°) sau khi đọc được đoạn nguyên nhân gây ra nó, mình chắc chắn nó là do cố ý :)). __Nó có sáng tạo không? Chắc chắn là có! Nó có hiệu quả không? Mình cũng không chắc nữa :))__ Bài học rút ra, khi bạn có ý tưởng mới nào đó, hãy chắc chắn xem xét hiệu quả của nó trước khi bỏ công ra để làm nó (điều này đúng với cả mình, thay vì bỏ công ra ngồi mò đoạn code trên thì khi biết nó là breakpoint, mình nên tắt luôn nó đi cho rồi T.T ).

Hết rồi :)) Code sample của trick trên có thể tìm thấy tại [đây](https://github.com/khanhtc1202/tricks/tree/master/block).