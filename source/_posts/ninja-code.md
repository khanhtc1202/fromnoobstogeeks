---
title: Ninja Code
date: 2018-06-05 17:10:45
tags:
- code
- javascript
---

Bài viết lược dịch từ [đây](https://javascript.info/ninja-code). Đối với tôi, không có từ nào nhận xét tốt hơn cho bản gốc của bài viết này ngoài 2 chữ `tuyệt vời` :)).

<!-- more -->

Nếu coding giống như một trận chiến giữa programer và problem cần giải quyết thì giống như những chiến binh thực thự, chúng ta tìm kiếm đạo (phương pháp chiến đấu) phù hợp cho chính mình. Trong bạt ngàn những đạo (những nguyên lý), kinh dịch (article trên blog của những blogger nổi tiếng), chú thích kinh nghiệm (những note, post được đông đảo dev `kip` lại),...đâu đó quanh đây vẫn tồn tại một đạo mà không mấy ai để ý đến nhưng số người theo thì đếm không kể hết. Có người đắc đạo hoàn toàn, có người một phần, tuy theo nhiều mức độ khác nhau nhưng tựu chung có thể coi đều là đồng đạo trong môn phái này :))

Trong khuôn khổ bài viết, đạo này được naming là `ninja đạo` - người theo đạo được naming là các ninja (ninja đắc đạo là những ninja tuân thủ nghiêm ngặt theo những đạo lý được liệt kê trong bài viết này).

[Imgur](https://i.imgur.com/9gCBJvO.jpg)

Chúng ta sẽ cùng điểm qua những giáo lý chủ đạo của đạo phái này. (chú ý, source code sử dụng trong bài viết là javascript, tuy nhiên mở rộng ra nó có thể là bất cứ ngôn ngữ nào, bởi môn sinh theo học ninja đạo là vô biên)

> Rất nhiều môn sinh theo ninja đạo. Chỉ một số ít thành công.

## Ngắn gọn là đích đến của sự thông tuệ

Code của bạn càng ngắn gọn, bạn càng thông minh hơn thằng ngồi ở block bên cạnh.

Lấy ví dụ, tất cả chúng ta từ khi bắt đầu học lập tình đều biết đến phép toán `?` và cách nó biến đổi một biểu thức điều kiện if về dạng oneline function kì diệu như thế nào.

Xem ví dụ bên dưới:

```java
// taken from a well-known javascript library
i = i ? i < 0 ? Math.max(0, len + i) : i : 0;
```

Một ninja đạt cảnh giới cao viết những block code tuyệt vời như vậy! Sẽ chẳng có vấn đề gì nếu nó nằm sâu ngàn lớp trong một thư viện high performance nào đó, nhưng điều gì sẽ xảy ra nếu người động đến đoạn code này là một môn sinh trẻ tuổi? Hẳn là môn sinh non nớt đó sẽ phải bỏ ra kha khá thời gian để bắt được giá trị của `i` khi muốn debug đoạn code này. 

Và rồi đến khi không thể tìm ra lời giải thích thoả đáng cho cái lỗi hắn đang phải debug, hắn sẽ tìm đến bạn (một ninja cảnh giới cao hơn) để hỏi về nó, hãy nói với hắn `Ngắn hơn luôn tốt hơn`, mở cho anh ta con đường đến với ninja đạo.

## Biến số một chữ cái

> Người Dao ẩn mình bằng sự im lặng. Cái gì người Dao đã bắt đầu, chỉ người Dao biết cách kết thúc nó.
> -- <cite>Laozi (Tao Te Ching)</cite>

Đối với một ninja, không gì quan trọng hơn là kĩ năng ẩn mình. Vậy kĩ năng ẩn mình của một ninja đắc đạo thể hiện ở đâu? Nó thể hiện từ những thứ nhỏ nhất như là tên biến...

Đặt tên biến `một-chữ-cái` (như là `a`, `b` hay `c`) giúp các ninja thượng đẳng tăng tốc độ code một cách đáng kể!

Tên biến một chữ cái trong 1 block code giống như những ninja ẩn trốn trong rừng cây. Không ai có thể tìm ra họ! Kể cả những công cụ search của editor (`ctrl+F` hoặc `cmd+F`) cũng phải đầu hàng trước biến này. Mặt khác kể cả khi tìm ra, không ai (trừ gã `người Dao` bên trên) biết được ý nghĩa của biến `a` hay `b` đó là gì.

...Tuy nhiên vẫn có một ngoại lệ. Một ninja đắc đạo sẽ không bao giờ dùng biến một-chữ-cái như `i` để làm biến đếm trong vòng `for`. Lý do tại sao à, đơn giản là vì còn rất nhiều lựa chọn khác ngoài `i`, như `x` hay `y` chẳng hạn. 

Một ninja thực thụ sẽ không bao giờ để biến của anh ta dễ dàng bị bắt chỉ bởi dùng một chữ cái ai cũng biết như `i` được. Và đặc biệt, khi độ dài của vòng `loop` đó lên đến 1-2 trang (trang ở đây chỉ độ dài hiển thị source code trên một màn hình - nếu có thể, hãy cố gắng làm cho vòng for của bạn dài đến 3 trang, điều này giúp biến của bạn ẩn mình tốt hơn), khi đó không bạn đã ngộ được nguyên lý để ẩn mình thực sự.

## Rút....gọn

Nếu team của bạn có quy định về cấm sử dụng biến một-chữ-cái hoặc tên-vô-nghĩa, hãy lách luật bằng cách rút gọn chúng.

Một số ví dụ như:
- list → lst.
- userAgent → ua.
- browser → brsr.
- …etc

Phải là một ninja đắc đạo hoặc là có trực giác tốt mới có thể hiểu được ý nghĩa ẩn giấu dưới những cái tên này. Hãy cố gắng rút gọn mọi thứ, nó là một lớp lọc rất tốt. Chỉ những người thực sự có năng lực mới có thể hiểu và có quyền động vào source code của bạn.

## Trừu tượng là mục tiêu

> The great square is cornerless </br>
> The great vessel is last complete, </br>
> The great note is rarified sound, </br>
> The great image has no form.
>
> -- <cite>Laozi (Tao Te Ching)</cite>

Khi đặt tên biến, trong hàng trăm lựa chọn, hay chọn cái tên trừu tượng nhất. Giống như obj, data, value, item, elem,...etc.

+ Cái tên lý tưởng để đặt cho bất cứ biến nào là `data`, lý do đơn giản vì nó là từ chính xác nhất để miêu tả nhiệm vụ của biến - lưu trữ data!

Nhưng làm thế nào khi cái tên `data` đã bị một ninja khác trong team dùng mất? Hãy thử `value`! Sau cùng thì mọi biến đều sẽ nhận một giá trị nào đó, nên cái tên value là hoàn toàn có thể chấp nhận được.

+ Mặt khác, bạn hoàn toàn có thể đặt tên cho biến bằng loại giá trị mà biến đó lưu. Ví dụ như: str, num,...

Một môn sinh trẻ tuổi có thể ban đầu cảm thấy lạc lõng và tự hỏi kĩ năng đặt tên biến như trên có thực sự giúp ích cho một ninja? Hãy tự tin và nói với anh ta "chắc chắn rồi!".

Thật vậy, những cái tên trên thực sự vẫn mang trong nó ý nghĩa: `str` thể hiện biến đó đang lưu một chuỗi gì đó,...Nhưng khi có ai đó bên ngoài thử cố gắng hiểu đoạn code của bạn, họ sẽ bất ngờ nhận ra cái tên đó chẳng mang một ý nghĩa cụ thể nào cả :)) họ sẽ phải từ bỏ việc đào bới đoạn code và như vậy biến cùng với logic của bạn được `an toàn` là của bạn.

Không có cách nào để thực sự hiểu được đoạn code của bạn - một ninja thượng đẳng - ngoại trừ việc dành nhiều thời gian cho nó và phải thực sự tĩnh tâm :)) Bạn sẽ bất ngờ về khả năng đọc code của môn sinh mới sau vài tháng luyện tập.

+ Vậy phải làm gì khi hầu hết những cái tên phía trên đều rất dễ bị một ninja khác trước bạn dùng mất? Đơn giản, chỉ cần `THÊM SỐ VÀO` : data1, data2, value3, str4,...etc.

## Kiên định

Sự tập trung cũng là một trong những yếu tố phân định đẳng cấp của một ninja! Chỉ những ninja đã thực sự tập trung và kiên nhẫn mới đủ tư cách đi cùng những ninja thượng đẳng khác. Vậy làm cách nào để thử thách họ - những môn sinh non trẻ?

Như đã nói bên trên, một cách đơn giản, hãy `sử dụng những cái tên phổ biến để đặt tên biến` như là `data` & `date`. Sau đó mix chúng lại với nhau! Sẽ không ai có thể nhanh chóng đọc được source code của bạn, và rồi khi có lỗi typo (lỗi đánh máy) Uhm...chúng ra sẽ còn kẹt ở đây khá lâu, một tách trà trước khi tiếp tục không phải một ý tưởng tồi...