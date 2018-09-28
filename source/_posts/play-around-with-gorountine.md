---
title: Play around with goroutine
date: 2018-07-21 18:59:07
tags:
- tree
- golang
---

Hôm nay trong lúc lượn lờ [go tour](https://tour.golang.org/list) - một guide khá đầy đủ và thú vị giới thiệu về golang, mình bắt gặp một đoạn khá thú vị :))
<!-- more -->

Trong mục concurrency in golang, giới thiệu về goroutine - một điểm rất mạnh của golang dùng thay thế cho thread trong các ngôn ngữ lập trình khác - item 7 có nhắc lại kiến thức về tree. Trong đó có đưa ra 1 quiz nhỏ như sau:

> There can be many different binary trees with the same sequence of values stored at the leaves. For example, here are two binary trees storing the sequence 1, 1, 2, 3, 5, 8, 13.

![](https://tour.golang.org/content/img/tree.png)

> A function to check whether two binary trees store the same sequence is quite complex in most languages. We'll use Go's concurrency and channels to write a simple solution.

Một quiz nghe có vẻ đơn giản nhưng khi implement bằng một ngôn ngữ mới với công cụ mới nó cũng đem đến nhiều góc nhìn khá thú vị :))

Để giải quiz này, công cụ chúng ta cần là một phép duyệt tree, rất tự nhiên, phép duyệt được chọn để dùng trong trường hợp này là **duyệt thứ tự trước** hay `LNR` (một lý do khác để chọn phép duyệt này là hint của quiz cũng gợi ý dùng phép này :)) )

Theo suy nghĩ thông thường, ta có implement của phép duyệt LNR đơn giản như sau

```C
void LNR(Tree T) {
	if (T!=NULL) {
		LNR(T->Left);
		printf("%d ", T->value);
		LNR(T->Right);
	}
}
```

Do quiz yêu cầu sử dụng `goroutine` - kết quả trả về từ goroutine cho main (có thể coi cũng là 1 goroutine khác) thống qua `channel` (các khái niệm đã nhắc đến trên đều được giải thích rất chi tiết trong [go tour](https://tour.golang.org/list) do đó không được nhắc lại trong bài viết nữa). Từ đó ta có implement đơn giản như sau:

```golang
func WalkRecursion(t *tree.Tree, ch chan int) {
	if t != nil {
		WalkRecursion(t.Left, ch)
		ch <- t.Value
		WalkRecursion(t.Right, ch)
	}
}

func main() {
	ch := make(chan int)
	go WalkRecursion(tree.New(1), ch)

	for i := range ch {
		fmt.Printf("%d, ",i)
	}
}
```

Compile và chạy đoạn trên ta dính lỗi sau:

```bash
fatal error: all goroutines are asleep - deadlock!
```

Sở dĩ có lỗi trên là do vòng `for` đoạn in kết quả trong hàm main là infinite loop, nguyên nhân do `for i := range ch` chỉ dừng khi channel `ch` được đóng - trong khi trong đoạn implement trên mình chưa thực hiện `close(ch)` :v

Sử dụng `defer` để close là không hiệu quả, lý do chính vì defer trong scope của main sẽ đợi for loop kết thúc :)) (một trick khác cũng liên quan chút ít đến vấn đề này có thể tìm thấy trong post [này](https://kipalog.com/posts/2-cach-de-lam-memory-leak-trong-golang) )

Nghĩ một cách đơn giản hơn, ta chỉ cần close channel tại thời điểm `WalkRecursion` đã chạy xong là được! Hay nói cách khác - đóng channel trả về dữ liệu tại thời điểm hàm push dữ liệu (supplier) đã chạy xong. Và để làm được điều đó, tất nhiên ta sẽ làm ở goroutine có supplier đang chạy :D

```golang
func main() {
	ch := make(chan int)
	go func() {
		WalkRecursion(tree.New(1), ch)
		close(ch)
	}()

	for i := range ch {
		fmt.Printf("%d, ",i)
	}
}
```

Đoạn code trên đã chạy ngon :)) tuy nhiên nhìn hơi...nặng nề, có lẽ do trong hint của quiz cũng chỉ ghi dùng `go Walk(tree.New(1), ch)` để `kick off` hàm duyệt cây. Để đạt được yêu cầu đó, ta sẽ đi giấu phần close channel vào trong hàm duyệt! Ta có thể viết lại hàm duyệt tree như sau:

```golang
func WalkEmbedded(t *tree.Tree, ch chan int) {
	defer close(ch)
	var walk func(t *tree.Tree)
	walk = func(t *tree.Tree) {
		if t == nil { return }
		walk(t.Left)
		ch <- t.Value
		walk(t.Right)
	}
	walk(t)
}

func main() {
	ch := make(chan int)
	go WalkEmbedded(tree.New(1), ch)
	...
}
```

P/S: Sau khi ngó nghía chán đống quiz rồi mình mới phát hiện ra có public solutions của golang team trên github :'( . Tham khảo thêm solutions của golang team tại [đây](https://github.com/golang/tour/tree/master/solutions).
