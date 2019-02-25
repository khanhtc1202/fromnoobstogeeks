---
title: How much your objects encapsulate
date: 2019-02-24 18:46:19
tags: 
- oop
- thinking
- design
---

Encapsulate ( tài liệu tiếng Việt thường dịch là `đóng gói` ) hay được nhắc đến và ví dụ như là cách để `che giấu` thông tin trong lập trình hướng đối tượng.

<!-- more -->

> Tức là trạng thái của đối tượng được bảo vệ không cho các truy cập từ code bên ngoài như thay đổi trong thái hay nhìn trực tiếp. Việc cho phép môi trường bên ngoài tác động lên các dữ liệu nội tại của một đối tượng theo cách nào là hoàn toàn tùy thuộc vào người viết mã. Đây là tính chất đảm bảo sự toàn vẹn, bảo mật của đối tượng Trong Java, tính đóng gói được thể hiện thông qua phạm vi truy cập (access modifier).

Từ [wiki](https://en.wikipedia.org/wiki/Encapsulation_(computer_programming)) ta có định nghĩa

> Encapsulation is one of the fundamentals of OOP (object-oriented programming). It refers to the bundling of data with the methods that operate on that data. Encapsulation is used to hide the values or state of a structured data object inside a class, preventing unauthorized parties' direct access to them. Publicly accessible methods are generally provided in the class (so-called getters and setters) to access the values, and other client classes call these methods to retrieve and modify the values within the object.

Những thứ nổi lên và dễ đập vào mắt nhất khi đọc định nghĩa này là "đảm bảo sự toàn vẹn", "không cho các truy cập từ code bên ngoài", "hide the values or state",...đại ý là cấm thay đổi trực tiếp value và state nhưng sau cùng lại có `getters and setters` @@ nếu đã tồn tại 2 thứ này, sau cùng vẫn có cách để bạn thay đổi value hay state của object, vậy rút cuộc encapsulate mang ý nghĩa gì, và liệu cách hiểu như vậy có phải là một cách hiểu đúng :))

Thử nghĩ lại một chút qua ví dụ sau: 

```java
new HTTP("https://www.google.com").read();
new HTTP().read("https://www.google.com");
```

Có gì khác biệt giữa 2 cách code trên ? Class `HTTP` thứ nhất encapsulate URL như là một thành phần của chính nó, trong khi class `HTTP` thứ hai nhận vào URL như là biến cần thiết để thực hiện hành vi `read()`. Về cơ bản, object tạo bởi 2 class nói trên khi gọi read đều thực hiện cùng một hành vi: chúng đọc nội dung từ google. Vậy cách dùng nào `đúng` ? Câu trả lời có vẻ là tuỳ thuộc vào việc dùng chúng vào mục đích gì.

Một cách mô tả về object trong OOP mà ai cũng biết, object là `thế hiện của một thực thể trong thực tế`! Object tồn tại trong cái môi trường được gọi là thực tế đó và biết cách `tương tác với môi trường` thông qua các `hành vi`. Nếu vậy trong ví dụ về object của 2 class `HTTP` bên trên, những object đó thể hiện cho đối tượng nào trong thực tế? Rõ ràng, mỗi class (với thiết kế khác nhau) thể hiện cho một thực thể khác nhau :)

Class `HTTP` thứ nhất, nhận vào một URL thông qua constructor, nó chỉ cho ta biết rằng: object của class này sau khi được khởi tạo thông qua constructor sẽ là thể hiện cho một trang web (cái mà được trỏ đến bởi URL).

Class `HTTP` thứ hai, với một constructor không có tham số, nó chỉ ra rằng: object khởi tạo bởi nó là thể hiện của...vũ trụ (the Universe)!

Có một cách đơn giản để biết một class là thể hiện của thực thể nào trong thực tế, đó là `nhìn vào constructor` - hay một cách cụ thể hơn: cách tạo ra object thuộc kiểu của class đó

> In order to understand what real-life entity an object represents, look at its constructor.

Về cơ bản, class nắm giữ cách tạo ra object trong môi trường object tồn tại, định nghĩa về object được xác định thông qua cách mà nó được tạo ra. Các tham số được truyền vào cho constructor và được encapsulate bởi object, nhằm định nghĩa object đó là thể hiện của thực thể nào trong môi trường.

Và bây giờ, thử làm rõ hơn câu hỏi đã đề ra: __class nào trong 2 class HTTP đã đưa ra được thiết kế đúng?__ bằng cách thay nó bởi câu hỏi: __class nào thể hiện thực thể tốt hơn? web page hay the Universe?__
