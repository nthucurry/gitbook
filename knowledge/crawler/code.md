# XML
## cwb demo
```xml
<location>
    <lat>25.035950</lat>
    <lon>121.611456</lon>
    <lat_wgs84>25.0341638888889</lat_wgs84>
    <lon_wgs84>121.619680555556</lon_wgs84>
    <locationName>國三南深路交流道</locationName>
    <stationId>CM0010</stationId>
    <time>
        <obsTime>2020-06-26T22:00:00+08:00</obsTime>
    </time>
    <weatherElement>
        <elementName>TEMP</elementName>
        <elementValue>
            <value>31.5</value>
    </elementValue>
```

## python
```python
import requests
import datetime
import time
import re
from bs4 import BeautifulSoup

now = datetime.datetime.now()
domain = "https://www.ptt.cc"
topic = "/bbs/Tech_Job"
# keywords = ["友達", "戀人", "AUO"]
keywords = ["台積電"]
dirty_title = []
dirty_title.append("[公告] Tech_Job板板規 2014.03.01")
dirty_title.append("[情報] 律師為您解惑，免費勞動法問題諮詢服務")
dirty_title.append("[情報] 薪資查詢平台")
dirty_title.append("[公告] 置底 檢舉/推薦 文章")
dirty_title.append("[公告] 如何消除退文 轉自Ask板")

pages = ["", range(3797, 3700, -1)]
index_url = domain + topic

# print(time.strftime("%a %b %d %H:%M:%S %Y", time.localtime()))
# a = "Sat Mar 28 22:24:24 2016"
# print(time.strptime(a, "%a %b %d %H:%M:%S %Y"))
# t = datetime.datetime.strptime(a, "%a %b %d %H:%M:%S %Y")
# print(t)

# index
index_www = requests.get(index_url)
index_soup = BeautifulSoup(index_www.text, "html.parser")
rents = index_soup.find_all("div", "r-ent")
# for rent in rents:
#     popularity = rent.find("div", "nrec").string
#     title = rent.find("div", 'title').find("a")
#     meta = rent.find("div", "meta")
#     if title:
#         link = domain + title.get("href")
#         www = requests.get(link)
#         url = BeautifulSoup(www.text, "html.parser")
#         # print(url)
#         main_contents = url.find_all("div", "article-metaline")
#         main_content = main_contents[2]
#         date = main_content.find("span", "article-meta-value")
#         date = time.strptime(date.string, "%a %b %d %H:%M:%S %Y")
#         date = time.strftime("%Y-%m-%d %H:%M:%S", date)
#         title = title.string
#         if title not in dirty_title:
#             # for keyword in keywords:
#             # print(keyword, title)
#             # if re.search(keyword, title):
#             # if popularity is not None:
#             print(popularity, title, link, date)

# other pages
previou_pages = index_soup.find_all("a", "btn wide")
for previou_page in previou_pages:
    if previou_page.string == "‹ 上頁":
        previou_page_link = domain + previou_page.get("href")
        previou_page_number = int(re.search("\d{1,}", previou_page_link).group())
        for i in range(previou_page_number, 3700, -1):
            url = index_url + "/index%d.html" % i
            # print(url)
            www = requests.get(url)
            soup = BeautifulSoup(www.text, "html.parser")
            rents = soup.find_all("div", "r-ent")
            # break
            for rent in rents:
                popularity = rent.find("div", "nrec").string
                title = rent.find("div", 'title').find("a")
                meta = rent.find("div", "meta")
                if title:
                    link = domain + title.get("href")
                    # print(link)
                    sub_www = requests.get(link)
                    sub_url = BeautifulSoup(sub_www.text, "html.parser")
                    # 該篇文章全部內容
                    contents = sub_url.find("div", class_="bbs-screen bbs-content")
                    # 找特定公司關鍵字
                    if not re.match("戀人", contents.text):
                        main_contents = sub_url.find_all("div", class_="article-metaline")
                        if len(main_contents) == 3:  # 如果沒有日期
                            time_content = main_contents[2]
                            date = time_content.find("span", "article-meta-value")
                            if re.match("^.{3} .{3} \d* \d+:\d+:\d+ \d{4}$", date.string):
                                date = time.strptime(date.string, "%a %b %d %H:%M:%S %Y")
                                date = time.strftime("%Y-%m-%d %H:%M:%S", date)
                                title = title.string
                                if title not in dirty_title:  # 過濾髒訊息
                                    # for keyword in keywords:
                                    #     if re.search(keyword, title):
                                    if popularity is not None:
                                        print(popularity, title, link, date)
                        else:
                            continue
```