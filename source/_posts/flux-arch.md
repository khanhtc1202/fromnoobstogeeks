---
title: A Sample App for Flux Architecture
date: 2018-04-15 20:20:57
tags:
- architecture
- react
---

Mình được tuyển về làm java dev nhưng do số nhọ, từ khi đi làm đến giờ số ngày dev java của mình chắc ít hơn đầu ngón tay. Bị quăng qua lại làm từ python, ruby, clojure, golang,...đến giờ thì cái gì đến cũng phải đến, mình bị dí sang làm react trong một dự án mới. Mình vốn cực kì noob frontend app, nên khi nhận được cụm `flux architecture` trong một buổi họp nọ, mình nhận ra ngay đấy là cứu cánh duy nhất của mình ( ngoài architecture ra thì mình không đặc biệt quan tâm cái gì lắm :)) ). Sau vài giờ google thì dù tìm lòi mắt mình cũng `không thấy cái sample nào tử tế hoặc đủ để noobs như mình hiểu` nên quyết định tự làm 1 cái, dù sao thì từ hướng architecture, flux cũng khá là thú vị.

<!-- more -->

Như tiêu đề, bài viết không có mục đích viết lại flux là gì, chỉ đơn giản là cung cấp source code một sample app thiết kế theo flux ( sử dụng react-redux ) cùng với một số note cá nhân rút ra được. Nếu không có đủ thời gian để tiêu phí, source code được public tại [đây](https://github.com/khanhtc1202/flux-arch-sample).

## Khái quát về flux

Cái này thì mình thấy trên mạng sau vài phút googling thì có rất nhiều rồi, ví dụ như ở [đây](https://scotch.io/tutorials/creating-a-simple-shopping-cart-with-react-js-and-flux), [đây](https://viblo.asia/p/flux-under-the-hood-NznmMd34Rr69) và cả ở [đây](https://blog.mimacom.com/introduction-to-react-and-flux/) nữa. Phần này khá nhiều bài và đầy đủ rồi, mình xin phép tập trung vào implement và lưu note :))

Ngoài những bài bên trên ra mình thấy có 1 bài dịch trên kipalog khá hay về flux, có thể tìm thấy tại [đây](https://kipalog.com/posts/Huong-dan-va-giai-thich-Flux-bang-hinh-ve).

## Implement Flux

Chúng ta đi implement một sample app bao gồm 1 search box nhập từ khoá, kết quả tìm được in lên trang như sau. ( mình noob application nên nó chỉ `đẹp` được đến vậy là hết sức rồi :)) )

![giphy](https://media.giphy.com/media/RkN5nA5O00StGGwXVQ/giphy.gif)

Một vài điểm chú ý mình muốn nhắc lại trước khi bắt tay vào design 

1. View là tập hợp của các components!!!
2. Các component được define tuỳ ý bạn, tuy nhiên tuyệt đối không nên define 1 component lớn nhiều logic ( nếu lo lắng về việc view bị vụn nhiều component thì đọc 3. )
3. Dữ liệu của cả trang define thông qua State của trang đó. Sau mỗi action, State của trang được cập nhật đến trạng thái mới ( điều này đảm bảo view đồng nhất tránh bị thay đổi do trigger ở nhiều model khác nhau | lưu ý tránh nhầm lẫn với State của component )
4. Chỉ có các Action nắm biết cách thay đổi dữ liệu trên view, không được thay đổi bằng bất cứ phương pháp nào khác, kết quả sau mỗi action đều là State mới của trang ( điều này bổ sung cho 3. )

Xem hình dưới để có hình dung tổng quát của cấu trúc khi đảm bảo những chú ý trên:

![Imgur](https://i.imgur.com/om44nEa.png)

Dựa theo tư tưởng bên trên, ta thiết kế một project structure như sau:

Các `Component` phát sinh event, được xử lý bằng các method ( đã được khai báo như là props (properties) của component ). 

Các `Action` ( có vai trò như các callback ) định nghĩa phương thức thay đổi dữ liệu trên trang, kết quả trả về là state mới.

Các `Container` có 2 nhiện vụ chính là: `Bind data từ State của trang sang props của Component` và `Tuỳ theo method đã declare trong props của Component, ném (dispatch) các Action thích hợp`. Nhiệm vụ này thực hiện thông qua 2 method chính là `mapStateToProps` và `mapDispatchToProps`.

Các `Reducer` là nơi kiểm soát giá trị `input cho State mới`. Method `combineReducers` merge output của các reducer gán làm giá trị mới cho State.

`state.js` define State struct của page app & `store.js` là nơi gom đống reducers bên trên lại, quản lý State của toàn bộ page đó.

> Những điều trên được đảm bảo bởi `redux` và các method của libs này. Trong ví dụ minh hoạ mình dùng libs `react-redux` để implement.

Project's struct

```bash
.src
├── actions/
├── components/
├── containers/
├── reducers/
├── index.tsx
├── state.ts
└── store.ts
```

Ngoài ra thì có thể chia thêm `types/` để define types hoặc action sử dụng.

OK bắt tay vào viết chắc nhanh ngấm hơn :))

Để implement sample app này mình chia nó ra thành 2 components là: `SearchBox` và `SearchResults` tương ứng như sau:

1. Component: SearchBox | Action: Type, Search | StoreToState: queryString, queryResults
2. Component: SearchResults | Action: non ! StoreToState: non :))) ( thằng ku này chỉ bind data từ state và show ra thôi :)) )

Lý do mình chia ra như bên trên thành 2 component đơn giản chỉ là mình `thích` như vậy :)) hơn nữa, do kiến trúc đã flex nên việc define thêm bớt các component rất dễ dàng, miễn là đảm bảo đúng các chú ý đã nêu bên trên :)))

Ta có trình tự implement.

![Imgur](https://i.imgur.com/Hw7PGiw.jpg?1)

### Define state

```typescript
export type State = {
  queryString: string;
  results: Array<Result>;
};
```

### Implement component

```typescript
type Props = {
    queryString: string;
    type: (text: string) => void;
    search: () => void;
}

export default class SearchBox extends React.Component<Props, any> {
    constructor(props: Props) {
        super(props);
    }
    
    render() { ... }
}
```

### Implement action

```typescript
export type SearchAction = {
    type: "SEARCH";
    results: Array<Result>;
};

export const search = (): SearchAction => {
    // TODO do http request for query results from api here
    const results: Array<Result> = [];

    return {
        type: "SEARCH",
        results: results
    };
};
```

Chú ý 1 Action bắt buộc có trường type như sau ( lý do thì ở [đây](https://fromnoobstogeeks.com/2018/04/15/flux-arch/#Implement-reducer) ) 
```typescript
type SearchAction = {
    type: "SEARCH";
    ...
};
```

### Implement container

```typescript
type DispatchProps = {
    type: (text: string) => void;
    search: () => void;
};

const mapStateToProps: MapStateToProps<any, any, State> = (state) => {
    const queryString = state.queryString;
    return { queryString };
};

const mapDispatchToProps: MapDispatchToProps<DispatchProps, any> = (
    dispatch: Dispatch<any>
) => {
    return {
        type: (text: string) => { dispatch(type(text)); },
        search: () => { dispatch(search()); }
    };
};

export default connect(mapStateToProps, mapDispatchToProps)(SearchBox);
```

`State` bên trên là state của page app.

`queryString` props của `component SearchBox` được map với `queryString` strong `State`.

`type` và `search` props của `component SearchBox` được `trigger để dispatch action` phù hợp.

### Implement reducer

```typescript
const initialState: Array<Result> = [];

export default (state: Array<Result> = initialState, action: SearchAction): Array<Result> => {
    switch (action.type) {
        case "SEARCH": {
            return action.results
        }
        default: {
            return state;
        }
    }
};
```

Chú ý `action.type` đã define bên trên được dùng ở đây.

Giá trị trả về của các reducer được merge lại tại `reducer/index.js`

```typescript
import { combineReducers } from 'redux';

export default combineReducers({
    queryString: Type,
    results: Search,
});
```

Chú ý State struct được map với kết quả trả về của `combieReducers`.

### Store và Index.tsx

./store.ts
```typescript
import { applyMiddleware, createStore } from 'redux';
import { createLogger } from 'redux-logger';

import reducers from "./reducers";

const store = createStore(
  reducers,
  applyMiddleware(createLogger())
);

export default store;
```
./index.tsx
```javascript
import { Provider } from 'react-redux';

import store from "./store";
import SearchBox from "./containers/SearchBox";
import SearchResults from "./containers/SearchResults";

ReactDOM.render(
  <Provider store={store}>
    ...
  </Provider>,
  document.getElementById("app")
);

```

Chú ý module được import vào tại đây là `containers` và `store`.

Về `Provider` có thể tìm thấy giải thích chi tiết tại [đây](https://github.com/reactjs/react-redux/blob/master/docs/api.md#provider-store) hoặc một câu hỏi khá hay để hiểu thêm về provider có thể tìm thấy tại [đây](https://github.com/reactjs/react-redux/issues/719).

Ok DONE! Mục tiêu lúc đầu do cay cú vì không tìm được cái sample nào chi tiết cho flux nên mình viết bài này với mode noobs như mình đọc xong cũng làm được :)). Nhưng nghĩ lại thì tut với sample thì vẫn chỉ là sample thôi, muốn hiểu thì cứ clone về nghịch là nhanh nhất :))

P/s:
- Project struct trên là thành quả 2 ngày cãi nhau với thanh niên ngồi cạnh mình ở công ty, thanks to him :))
- Sếp :v anh có vô tình đọc được cái đống này thì xin tha cho em, chỉ làm frontend app nốt tháng này không em xin quit sớm :'( .
