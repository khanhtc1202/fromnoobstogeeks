---
title: Memory trick
date: 2017-12-22 18:42:41
mathjax: true
tags: 
- trick
- os
- memory
---

Nếu đã từng có thời gian làm việc với C (hay ông nào kinh hơn làm hẳn với Assembly :) ) chắc ai cũng nhớ sự kinh hoàng của **core dump fail** :'( . Dù có sử dụng [`gdb`](https://en.wikipedia.org/wiki/GNU_Debugger) debug thì chắc cũng phải bỏ ra cả mớ thời gian và công sức mà nhiều khi lỗi bắt nguồn từ những cái vớ vẩn nào đó mà bình thường ta không để ý :'( . Mặt khác bạn nên thấy may mắn khi ít ra còn biết chương trình đã lỗi ở đâu đó để mà sửa, có những lỗi nằm ở nhưng nơi hiểm hơn - không làm cho chương trình dừng nhưng kết quả thì sai lè. Một trong số những nguyên nhân chính dẫn đến nó là vấn đề [`tràn số`](https://en.wikipedia.org/wiki/Overflow)

<!-- more -->

Hôm nay trong khi đang mò code hệ thống, mình vớ được 1 đoạn đại ý như sau.

```C
// Same as (l+r)/2, but avoids overflow for
// large l and h
int m = l+(r-l)/2;
```

Không còn gì để nói thêm ngoài tuyệt vời :joy:

Đoạn code trên làm nhiệm vụ tính **trung bình cộng của 2 số l và r** với giả thiết đầu vào là **l nhỏ hơn hoặc bằng r**

Thông thường khi nghĩ đến tính trung bình cộng, bạn cho rằng đơn giản chỉ cần **cộng chúng lại và chia cho số số hạng** nhưng chính phần đơn giản đó khiến cho chúng ta nhiều lúc [`mất ngủ đến mấy ngày :)`](https://i.ytimg.com/vi/Uvw0xNSj0H0/maxresdefault.jpg) (cái này gợi nhớ đến dấu `;` thần thánh hoặc `}` mà chắc ai cũng đã dính rồi :joy: ).

Bạn cũng có thể dễ dàng dính tràn số với những đoạn code kiểu này - mà mình nghĩ chắc cũng không ít người vẫn làm thế :)) bao gồm cả người đang viết bài này :'(

```C
for(int i = 0; i < length; i++) {
    sum += array[i];
}
```

Việc thực hiện phép cộng bừa bãi nhiều khi thực sự gây ra những hậu quả bất ngờ khi đem chạy thuật toán với các test case lớn (ai chơi codejam chắc biết rõ vụ này).

Đoạn code mình vớ được hôm nay đem đến 1 ý tưởng không mới (chắc ai cũng biết nhưng chẳng mấy để ý) về vụ tránh lỗi tràn số nói trên. 

$$\begin{equation}
\dfrac{l + r}{2}
= \dfrac{2l + r - l}{2}
= \dfrac{l + (r - l)}{2}
\end{equation}$$

Một biến đổi khá đơn giản nhưng đã tránh hoàn toàn được vấn đề **overflow** nói trên. Chú ý rằng với giả thiết đầu vào là **l nhỏ hơn bằng r** ta luôn có **(r - l)** nằm trong range cho phép của kiểu mẫu, đơn giản là vì bạn đã **load được r vào bộ nhớ thì chẳng có lý do gì không load được (r - l) < r vào đó cả** :).

Tổng quát lên một chút ta có với giả thiết $X_{1} < X_{2} < ... < X_{n}$ cùng phía so với 0

$$\begin{equation}
\begin{aligned}
\dfrac{X_{1} + X_{2} + ... + X_{n}}{n} 
&= \dfrac{nX_{1} + (X_{2} - X_{1}) + ... + (X_{n} - X_{1})}{n} \\
&= X_{1} + \dfrac{(X_{2} - X_{1}) + ... + (X_{n} - X_{1})}{n} \\
&= X_{1} + \sum_{k=2}^n{\dfrac{X_{k} - X_{1}}{n}}
\end{aligned}
\end{equation}$$

Và với cách này thì bạn có thể thoải mái và yên tâm là không có chuyện tràn số nữa dù test dataset có lớn lên hay không :)).