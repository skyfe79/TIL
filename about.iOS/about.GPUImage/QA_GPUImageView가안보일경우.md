# GPUImageView 가 안 보일 경우

* GPUImageView는 intrinsicContentSize가 없기 때문에 AutoLayout에 width와 height 제약을 추가하던가 아니면 상속하여 intrinsicContentSize를 재정의 해야 한다.
* 위의 방법을 사용하지 않으려면 코드로 GPUImageView를 생성해서 addSubView해주면 된다.

```
resultView = GPUImageView(frame: self.view.bounds)
        self.view.addSubview(resultView)
```
