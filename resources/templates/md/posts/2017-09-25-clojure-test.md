{:title "Clojure 測試入門"
 :layout :post
 :tags  ["clojure" "test"]}


你是否有這樣的經驗：本來只是修改了 A 部分的程式，結果改完之後 B 部分的程式竟然動作不正常；或者是以前早就改好的問題，在這次改版之後又出現了呢？當有這些情形的出現，你需要的是透過測試來提早檢查可能出錯的地方，並找出會導致出錯的條件。

除了人工測試之外，最應該加入的就是有一組編寫好用來測試程式的程式。有了這些測試程式，你可以在正式上線或提交程式碼之前，利用這些測試程式檢查新修改的程式是否符合規定，也可以保證過往的問題不再出現。

本文就跟大家介紹在 Clojure 專案中撰寫測試的方法。使用的工具是內建於 clojure 當中的 clojure.test。

## 預備

要使用 clojure.test 之前，要記得將 clojure.test 的命名空間在測試程式中引入，如下所示：

```clojure
(ns clj-test.core-test
  (:require [clojure.test :refer :all]))
```

如果使用 leiningen 建立專案，專案中就會有一個 test 目錄，其中有產生出來的空白測試程式碼範本，把測試程式寫在那裏就對了。

## 斷言

### is

Clojure.test 也像其他的測試框架一樣，提供了斷言 (Assertion) 用來判斷一段程式的結果是否符合預期。它提供了 `is` 這個巨集用來判斷結果是否爲真，以下是它的使用範例：

```clojure
(is (= 4 (+ 2 2))
(is (.startsWith "abcde" "ab")
(is (instance? Integer 256))
```

### are

除了 `is` 之外，clojure.test 還提供了 `are` 這個巨集，幫助你將許多相似的判斷整理起來，使用方法如下：

```clojure
(are [x y] (= x y)
  4 (+ 2 2)
  2 (+ 1 1)
```

上面的範例跟以下的範例是一樣的，但是透過 `are` 就可以將類似的衆多 `is` 程式整理起來：

```clojure
(is (= 4 (+ 2 2))
(is (= 2 (+ 1 1))
```

### thrown?

因爲 clojure 是一個依靠 JVM 的語言，除了測試要執行的程式是不是符合預期，也會有需要測試是否會丟出預期例外的時候。Clojure.test 提供了 thrown? 巨集來完成這項工作：

```clojure
(is (thrown? ArithmeticException (/ 1 0)))
```

## 測試案例

### 撰寫

Clojure.test 提供 `deftest` 給使用者定義自己的測試案例，透過 `deftest` 中一個個寫好的判斷程式，來檢查欲執行的程式是否符合預期。

```clojure
(deftest addition
  (is (= 4 (+ 2 2)))
  (is (= 7 (+ 3 4))))
```

不同的測試案例也可以再由另一個 `deftest` 包覆起來成爲一個更高階的測試案例。

```clojure
(deftest arithmetic
  (addition)
  (subtraction))
```

### 說明文字

要清楚講明測試案例的功用，除了把命名儘量寫的容易理解之外，另一個方式就是在測試案例的說明註解中寫清楚。在 clojure.test 中，想利用文字來清楚說明測試的意圖，可以在 `is` 中再加上說明文字。當測試出錯時，該處的文字會出現在錯誤報告中：

```clojure
(is (= 5 (+ 2 2)) "Crazy arithmetic")
```

另外也提供了 `testing` 巨集，讓撰寫測試者可以將幾個斷言聚集在一起加上說明文字，不致於散亂而更有組織。同樣地，說明文字也會出現在錯誤報告中：

```clojure
(testing "Arithmetic"
  (testing "with positive integers"
    (is (= 4 (+ 2 2)))
    (is (= 7 (+ 3 4))))
  (testing "with negative integers"
    (is (= -4 (+ -2 -2)))
    (is (= -1 (+ 3 -4)))))
```

要注意的是，`testing` 巨集只能在 `deftest` 中使用。

### 執行

寫好測試案例之後，可以透過 clojure.test 提供的 `run-tests` 來執行寫好的測試範例：

```clojure
(run-tests 'your.namespace 'some.other.namespace)
```

如果在 `run-tests` 中沒有寫下命名空間，將會執行目前命名空間中的測試案例。

### Fixture

有時候一些相關的測試案例執行之前，需要先啓動某些資源，比如資料庫的測試案例，就必須在所有測試開始之前，先與資料庫做好連線。在測試完畢之後，妥善地恢復成之前的樣貌。這種在測試案例之中的準備，就稱爲 Fixture。

在 clojure.test 中，Fixture 只是一個簡單的函式，它只接受一個參數。這個參數就是待執行的測試案例，如果想要在執行測試案例前後做一些準備或善後作業，只要在測試案例前後執行即可，範例如下：

```clojure
(defn my-fixture [test-fn]
  ;; 在這裡設定或啓動必須事先準備好的事物
  (test-fn) ;; 呼叫測試案例
  ;; 在這裡做善後工作
 )
```

Fixture 分爲兩種，一種是只需要執行一次，另一種是針對每個測試案例都會執行一次。以下是使用範例：

```clojure
(use-fixtures :once load-data-fixture)   ;; 只執行一次
(use-fixtures :each add-test-id-fixture) ;; 每個測試案例都會執行一次
```

## 小結

Clojure.test 提供了一些簡單實用的功能，讓撰寫測試者可以不費力地開始撰寫測試案例，雖然陽春但是已經夠用了。如果你需要其他更進階的測試功能，不妨可以看看以下提供的其他測試框架或函式庫。如果你有更好的建議，歡迎留言分享討論。

## 資源

### 參考資料

* [clojure.test 官方文件](https://clojure.github.io/clojure/clojure.test-api.html)

* [clojure.test Introduction](http://blog.jayfields.com/2010/08/clojuretest-introduction.html)

* [Test-Driven Development in Clojure](http://www.diva-portal.org/smash/get/diva2:806620/FULLTEXT01.pdf)

* [30 天快速上手 TDD](https://dotblogs.com.tw/hatelove/2013/01/11/learning-tdd-in-30-days-catalog-and-reference)

### 其他測試框架/函式庫

* [Midje](https://github.com/marick/Midje)

* [Expectations](https://clojure-expectations.github.io/)

* [Speclj](http://speclj.com/)

* [smidjen](https://github.com/johncowie/smidjen)
