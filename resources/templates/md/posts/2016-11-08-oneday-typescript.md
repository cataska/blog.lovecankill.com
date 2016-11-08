{:title "TypeScript 一日課"
 :layout :post
 :tags  ["typescript"]}


## 緣起

上週六 (11/5) 參加了由 [Skilltree](https://skilltree.my/) 舉辦的 [TypeScript 新手入門班](https://skilltree.my/events/6kafn) 付費課程，希望藉由這個課程快速地了解 TypeScript 的大致面貌。

上完課程後，覺得是一門可以投資的語言，它並不像它的前輩 CoffeeScript 或 LiveScript，讓寫程式的人因爲歧義性而不易掌握，不僅有簡單易懂的語法可以與 JavaScript 相對應，更增加了型別的宣告與檢查，不會因爲型別的問題而在運行程式時，出現非預期的錯誤；還有友善的物件導向支援語法。

以下介紹 TypeScript 的特性與語法，也算是自己的課後回顧。

***

## TypeScript 的特性與語法

### 轉譯

TypeScript 寫成的程式經由工具會轉譯成 JavaScript，與一般的 JavaScript 並無二致。因此可以在各個瀏覽器與平臺間使用

### 強型別

JavaScript 中雖然有幾種型別，但是由於變數的型別是可以動態變換的，因此若是在撰寫時不注意，就可能會發生不同型別之間誤用的可能。而 TypeScript 支援強型別，會阻止不同型別之間誤用而發生悲劇。

如以下的函數就宣告了兩個參數爲數字，返回值亦爲數字。使用此函數若是丟進非數字型態的參數，IDE 或是轉譯 TypeScript 成 JavaScript 的工具便會報錯。

```typescript
function plus(a: number, b: number): number {
  return a + b;
}

var r1 = plus(1, 2);
var r2 = plus(1, '2'); // 錯誤
```

除了支援 JavaScript 的型別之外 (Boolean, String, Number, Array, Enum, Any)，TypeScript 也可以制定自己的類型。

### 常數與限定範圍變數

常數是使用 `const` 關鍵字來定義不會更改的變數，限定範圍變數則是使用 `let` 關鍵字來定義，使用限定範圍變數會防止程式在變數的作用域外，還能夠存取的問題。`let` 關鍵字能夠將變數限定在某個範圍內。

```typescript
const RETRY = 3;

var count = 1;
for (var i = 0; i < 10; i++) {
  let count = i;
}
```

### 函數

如前面範例所提供，TypeScript 的函數參數與返回值可以寫上型態，若使用時型態不符，則會出現錯誤訊息告知。

```typescript
function GetDiscountPrice(price: number): number {
  if (price > 200) {    return price * 0.8;  }  return price;
}
```

#### 箭頭函數

JavaScript 中的 this 總是讓人一不小心就着了道，如果神智不夠清楚。使用箭頭函數則會自動將函數中的 this 變數綁定到此函數所在的物件，不會因爲 this 變數在不同狀況下的不同值而中箭了。

```typescript
function Person(){
  this.age = 0;

  setInterval(() => {
    this.age++; // this 代表的是 Person 物件
  }, 1000);
}
```

### 友好的物件導向語法

TypeScript 支援與 Java, C# 等主流物件導向語言相似的語法，物件的屬性還可以定義是否准許公開存取。以下範例展示如何定義建構式與物件屬性：

```typescript
class Student {
  private gender: string;
  age: number; // 預設是 public

  constructor(gender: string, age: number) {
    this.gender = gender;
    this.age = age;
  }
}
```

#### 繼承

物件導向其中一個優點就是能夠利用繼承，將父類別已經提供的功能直接搬過來再利用，或是覆蓋原有的功能，提供另一種功能。TypeScript 利用 `extends` 關鍵字來支援繼承。

```typescript
class Shape {
  draw() {
    console.log("Draw shape");
  }
}

class Circle extends Shape {
  draw() {
    console.log("Draw circle");
  }
}
```

#### 介面

介面提供了比繼承更彈性的作法，它只定義了一組協議或合約而不提供實作，只要實作了這個介面就符合了合約，使用此介面的人並不需要知道實作此介面的物件究竟爲何。TypeScript 提供了 `interface` 關鍵字。

```typescript
interface Calculator {
  add(a: number, b: number): number;
  subtract(a: number, b: number): number;
}

class SimpleCalculator implements Calculator {
    add(a: number, b: number): number { return a + b; }
    subtract(a: number, b: number): number { return a - b; }
}
```

#### 泛型

泛型是一種在撰寫程式時，將型態視爲參數的設計方法，直到使用這些程式才決定要使用哪些型態。例如在 C++ 中會定義一些通用的資料結構或演算法，這些程式能夠適用大多數的型態。

在 TypeScript 中泛型函數的寫法：

```typescript
function identity<T>(arg: T): T {
  return arg;
}
```

在 TypeScript 中泛型類別的寫法：

```typescript
class GenericNumber<T> {
    zeroValue: T;
    add: (x: T, y: T) => T;
}
```

根據前面的例子可以看到，定義泛型型態是利用角括號 (`<>`) 將型態包起來。

### 模組

TypeScript 提供了 `module` 關鍵字可以將程式碼分門別類，相同名稱的兩個函數可以分類在不同的模組底下，就不會有衝突發生，將程式碼以功能分類也可以增加對程式的理解。

```typescript
module Product {  export function Validate(data) {    //// 一些程式    return true;  }}

// 在其他程式中如此使用
Product.Validate(data);
```

### 與其它 JavaScript 函式庫協作

在 TypeScript 還沒有發明以前，就已經有非常多好用的 JavaScript 函式庫，例如 jQuery。這些 JavaScript 並沒有明確指出函數的型態，要怎麼在 TypeScript 使用呢？

TypeScript 提供引入定義檔的方式，其中寫了第三方函式庫的型態定義，TypeScript 便可以藉助這些定義與第三方函式庫協作。

引入定義檔的寫法如下：

```typescript
/// <reference path="./node_modules/@types/jquery/index.d.ts" />
$('#product').on('click', function() {
   //// 更多程式
});
```

至於如何安裝需要的定義檔，請參考 [DefinitelyTyped](http://definitelytyped.org/)。

***

## 後記

當天的課程除了介紹 TypeScript 之外，也講解了 TypeScript 與 C# 之間前後端的快速整合，由於這些快速整合與 Visual Studio 有關，而目前我的工作機器是 Mac 和使用 Visual Studio Code，因此無法使用這些祕技，在此就不再贅述。

## 結論

如開頭所述，TypeScript 是個值得投資的語言，不僅可以與 JavaScript 整合，還提供了型別檢查，友善類別語法等等，藉由 IDE 或轉譯工具的幫助，在撰寫時就可以知道錯誤，不至於要等到程式運行時才出現非預期的錯誤。

除了前面介紹的語法與特性之外，TypeScript 還提供了其它好用的功能，有興趣的朋友可以到官網與閱讀其它文件來瞭解。

## 參考資料

- [TypeScript 官網](http://www.typescriptlang.org/index.html)
- [TypeScript Handbook 中文版](https://www.gitbook.com/book/zhongsp/typescript-handbook)
- c9s 寫的 [TypeScript 導盲與踩雷文](https://medium.com/@c9s/%E5%B0%8F%E7%B7%A8%E5%B9%AB%E4%BD%A0%E8%B8%A9%E5%9C%B0%E9%9B%B7%E7%B3%BB%E5%88%97-typescript-%E9%81%A9%E5%90%88%E6%88%91%E5%97%8E-e15b5a0607d7#.eos7ixx50)，幫助你瞭解 TypeScript 究竟適不適合你