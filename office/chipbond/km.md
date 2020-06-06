# 以工廠方法模式設計EDA系統
## 一、摘要
頎邦科技產品線製程分為金/錫鉛凸塊(Bumping)、晶圓測試(CP)測試和研磨切割封裝(Backend)封裝這三段，各段製程在進行作業時均須將晶圓進行檢測以確保產品良率，而檢測結果則匯入工程資料分析系統(EDA)作為後續分析、統計報表的資料來源。因此有效整合三段晶圓製程的測試結果乃是達成自動化生產的重要環節，其中系統整合便是重要任務之一。

相較於目前系統開發模式的維運困境，光復廠要導入的New MES，其軟體架構模式是採用MVC架構，透過前後端分離、資料處理物件化、規範開發架構...等物件導向的開發特色，為使系統開發人員能遵從開發規範，另導入設計模式-工廠模式進行開發，透過需求分析彙整三段製程的共通特性。

## 二、關鍵字
MVC模式(Model-view-controller)、工廠方法模式(Factory method principle)

## 三、前言
過往開發時，由於EDA各段製程是獨立開發，且開發方式是屬於程序導向開發，長期下來在維護系統時會因為需求的增加使單一系統架構過於龐大，出現維運上的困難。另外在整合各段系統時，可能因為使用套件的不相容、版本不一致…等各種因素，出現系統間相衝的可能性。因此，不同開發系統要如何整合為單一大系統是非常重要的任務。

## 四、內容
### 舊系統開發模式
舊系統是採用VB6為開發語言的視窗程式，屬於程序導向開發，無物件導向的功能。當需求提出時，若要新增功能勢必得複製貼上改一下(Copy-Paste-Update)，新建出另一個程式，程序上較麻煩，光是複製貼上就要花一些時間，更何況還有可能會貼錯位置的可能性...等等。這對小專案還好，但大專案動輒幾千行程式，維運起來會相當吃力，因此，提升維運容易度便是New MES的重要目標之一。

舊系統開發架構是採用Client-Server雙層架構，資料流向是由前端畫面(ex: 頎邦專案)輸入，直接透過後端程式邏輯與資料庫溝通，將結果回傳到前端畫面顯示出(如圖 1)。這種資料流將前後端綁定，當系統功能繁雜時(ex：頎邦專案再分成Bumping、CP、Backend，而每一塊製程就再細分許多子功能)，由於缺乏物件導向的特性，所以各功能之間彼此的關係耦合程度可能很高(違反單一功能原則)，彼此之間的修改都會牽動到其他功能(違反開閉原則)，使得後續維護人員的負擔相當大。

#### MVC架構
為了解決此衝突，New MES採用MVC架構(如圖 2)，透過前後端分離、資料處理物件化、規範開發架構...等物件導向的開發特色，使系統開發人員開發能夠遵從開發規範，另導入設計模式-工廠模式訂出框架，經由需求分析彙整三段製程的共通特性，進而開發出完整的系統。MVC將系統分為Model、Controller、View三大塊，個別功能如下說明：
- Model：資料的管理(ex：與資料庫的溝通)、演算法邏輯(商業邏輯)與物件結構定義
- Controller：依據傳入的資料該怎麼運作、程式流程的控制、該回傳給使用者什麼資料等
- View：呈現給使用者看、操作的介面

當Controller收到View的請求後會負責分派工作給Model，而Model主要負責與資料相關的處理過程，所以Model會去幫忙問資料庫使用者輸入的條件(ex: 查詢xxx Map)。最後Controller負責將查詢並處理完的資料包裝成Response再丟給View去呈現。

透過MVC可使每個區塊只專注本身的功能(降低耦合度)，例如：想要從資料庫撈不同欄位的資料，就只要針對Model去修改；若前端要新增輸入方框，就去改View；想修改程序，就改Controller。這樣看似不錯，把邏輯分得很清楚，但還是不夠的，因為目前只定義系統框架，而細部功能的框架尚未定義出來。

#### 工廠方法模式
根據維基百科定義：『工廠方法模式是一種實現了「工廠」概念的物件導向設計模式。』藉由不指定物件的具體型態來建立物件的架構，此設計守則就是實作抽象類別(或介面)，不依賴具體類別，將物件的建立過程封裝起來，讓子類別決定該建立的物件為何，據此達到將物件建立過程封裝的目的。

為了要完整定義出工廠模式，首先找出共通特性與會改變的東西即是重要任務。以EDA處理各段製程的Map為例，處理Map的動作均會有以下特性：
1. 判斷讀進來的檔案是屬於何種來源Map
2. 依據該來源Map去實作各種檔案格式的解析方法(ex: csv、txt、excel及binary file)
3. 解析出的Map所具有的必有特性(ex: 計算gross die…等等)
4. 備份來源Map、匯入資料庫。其中共通點是(3)、(4)，會改變的東西是(2)，(1)則是在撰寫程式時就會知道來源Map。

當分析完畢後，利用抽象類別制定出工廠模式的框架(如圖 3統整1~4)，由於來源Map格式變化性大，因此制定抽象方法(ExecuteParsers)來使子類別實作屬於自己的檔案解析方法(如圖 4)。共同特性部分，則由子類別直接使用父類別方法(ExecuteBuilder)。如此一來，即使是不同的開發人員都會在同一個規範框架下實作程式，無形中提升系統內聚程度。

整體資料流程如圖 5所示，Builder是工廠模式最核心的地基，各段製程的Map僅需繼承Builder便會取得該工廠的基本特性。因此，程式撰寫者建立各種Map的類別時，不需要知道實際建立的產品是何者，而是使用哪個次類別時，自然就決定建立的產品為何。

##### 圖3
```csharp
//抽象類別(父類別)
public abstract class BaseBuilder
{
    //框架：控制處理Map的共同流程
    protected virtual ABaseMap ExecuteBuilder(params string[] filePaths)
    {
        //實作解析資料
        ABaseMap map = this.ExecuteParsers(filePaths);

        //實作匯入資料庫與歸檔
        if (_dbTool != null)
        {
          MapInfo mapInfo = this.MapFileToBackup(_dbTool, map.GetMapInfo().GetAllMapFiles());
          map.SetMapInfo(mapInfo);
        }

        return map;
    }

    //框架：定義Parse框架
    protected abstract ABaseMap ExecuteParsers(string filePath);
}
```

##### 圖4
```csharp
//衍生類別(子類別)
public class ReadMapBaseBuilder : BaseBuilder
{
    protected virtual ReadMap MapBuild(string filePath)
    {
        base.SetDbConnection(dbTool);

        //執行抽象類別方法
        ReadMap map = base.ExecuteBuilder(filePath);

        return map;
    }

    //定義Parse框架(override)
    protected override ABaseMap ExecuteParsers(string filePath)
    {
        //實作Parser
        ReadMap map = Parse(filePath);
        return map;
    }
}
```