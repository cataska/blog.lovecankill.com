{:title "使用 Clojure 打造簡易的 LINE Bot - 起手式"
 :layout :post
 :tags  ["clojure" "linebot"]}


## 前言

今年是對話式介面 (Conversational UI) 的一年，各家即時通訊廠商紛紛推出自家的機器人平臺 (Bot Platform)，如 Facebook、LINE、Microsoft 與 Telegram 等等。

使用者可以透過機器人 (Bot)，以對話方式來取得需要的資訊，或是完成想做的事，而目前在臺灣最流行的通訊軟體就是 LINE。之後將會以一系列的文章來打造簡易的 LINE 機器人，使用的程式語言是 Clojure。

## 前置作業

由於 Clojure 是一門建立在 JVM 之上的程式語言，因此 JDK/JRE 是不可免的，在 [Java 下載頁面](http://www.oracle.com/technetwork/java/javase/downloads/index.html)可以下載到最新的版本。

另外需要的工具是在 Clojure 生態系被廣泛使用的 [Leiningen](http://leiningen.org)。它可以建立專案、執行測試、編譯程式碼、取得專案需要的相依函式庫與打包專案等等功能。最簡單的下載方法就是從[這裡](https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein)下載檔案之後，執行它便完成初始化了。

## 建立專案

在這一系列的文章裡，我們不會使用任何一個 Clojure 的網站框架 (web framework)，而是使用個別的函式庫來完成工作。首先使用 Compojure 提供的專案範本 (project template) 來建立專案：

```sh
$ lein new compojure webapp
```

[Compojure](https://github.com/weavejester/compojure) 是一個架構在 Ring 之上的路由函式庫，它將處理各方發送過來的請求予以簡化，如網站各路徑的資源要求。而 [Ring](https://github.com/ring-clojure/ring) 則是一個類似 Python 的 WSGI 或 Ruby 下 Rack 的函式庫，將 HTTP 的規則簡化成統一的 API，並能夠以元件的方式建構大型的網站應用程式。

接着在命令列裡輸入：

```sh
$ cd webapp; lein run server-headless
```

再開啓你常用的瀏覽器並在網址列裡輸入 `http://localhost:3000` 後按下 Enter，你應該會看到寫着 `Hello World` 網頁出現，這表示第一步已經成功了！值得注意的是第一次輸入 `lein run server-headless` 的時候，可能因爲要下載其他需要用到的函式庫，所以還無法在網頁中看到內容，最好等到命令列中出現 `Started server on port 3000` 後再開啓瀏覽器。

## 新增路由

依據 LINE 官方開發文件 ([英文版](https://devdocs.line.me/en/)/[日文版](https://devdocs.line.me/ja/))，使用 Messaging API 的開發者必須提供 Webhook 給 LINE，當使用者將機器人加入好友或傳訊息給機器人時，LINE 會透過 Webhook 提供的網址傳遞訊息給機器人，機器人再根據收到的訊息作出回應。

要添加 Webhook 讓 LINE 傳訊息過來，除了必須在 LINE 開發者網站上填寫之外 (之後的文章會提到)，還必須修改 `src/webapp/handler.clj`，在還未修改之前 `handler.clj` 內容如下：

```clojure
(ns webapp.handler
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.middleware.defaults :refer [wrap-defaults site-defaults]]))

(defroutes app-routes
  (GET "/" [] "Hello World")
  (route/not-found "Not Found"))

(def app
  (wrap-defaults app-routes site-defaults))
```

以下加入一個名爲 `callback` 的網址路徑，接受 LINE 傳送過來的訊息：

```clojure
(ns webapp.handler
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.middleware.defaults :refer [wrap-defaults site-defaults]]))

(defroutes app-routes
  (GET "/" [] "Hello World")
  (GET "/callback" [] "Hello LINE Messaging API")
  (route/not-found "Not Found"))

(def app
  (wrap-defaults app-routes site-defaults))
```

根據以上的程式可以看到新增了一個名爲 `callback` 的路由，當有人造訪這個路由，將會顯示 **Hello LINE Messaging API**。我們可以打開瀏覽器看看內容是否正確，在瀏覽器輸入 `http://localhost:3000/callback` 後便會看到訊息出現在網頁上。

## 回顧

在第一篇系列文章裡我們使用了 Ring 與 Compojure 建立了網站的雛形，並新增了接受 LINE 訊息的網址路徑。詳細的程式碼，請參閱[這裡](https://github.com/clojure-tw/line-bot-sdk-clojure/tree/0402187bd5c2c891a2bd48cdc45ee726f24a42fc)。