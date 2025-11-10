# -*- coding: utf-8 -*-
"""
crawler_pipeline.py
整合流程：
1️⃣ 從 ntpu_paper.sqlite 的 links 讀取網址
2️⃣ 用 Selenium 爬取文章標題、時間、內容與留言
3️⃣ 寫入同一個 DB 的 articles 表，並以 link_id 做關聯
"""

import sqlite3
import time
from datetime import datetime
from selenium import webdriver
from bson import ObjectId
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# === 資料庫設定 ===
DB_FILE = "/Users/lulutsai/Documents/NTPU_class/paper/code/mobile01_clawler/ntpu_paper.sqlite"

# === 控制今日爬取筆數 ===
LIMIT_COUNT = 50  # ← 想爬幾筆就改這裡

# === 建立資料表（若不存在） ===
def init_db():
    conn = sqlite3.connect(DB_FILE)
    cur = conn.cursor()

    # 建立 articles 表
    cur.execute("""
    CREATE TABLE IF NOT EXISTS articles (
        id TEXT PRIMARY KEY, 
        link_id TEXT NOT NULL,
        url TEXT,
        title TEXT,
        post_time TEXT,
        content TEXT,
        word_count INTEGER,
        replies TEXT,
        reply_count INTEGER,        -- 新增留言數欄位
        created_at TEXT,
        FOREIGN KEY (link_id) REFERENCES links(id)
    )
    """)

    # 檢查 links 表是否有 status 欄位
    cur.execute("PRAGMA table_info(links);")
    columns = [c[1] for c in cur.fetchall()]
    if "status" not in columns:
        print("🧱 新增 links.status 欄位...")
        cur.execute("ALTER TABLE links ADD COLUMN status TEXT DEFAULT 'pending';")

    conn.commit()
    conn.close()

# === 初始化 Chrome 設定 ===
def get_driver():
    options = Options()
    # options.add_argument("--headless")  # 若要看到瀏覽器可註解掉這行
    options.add_argument("--disable-gpu")
    options.add_argument("--no-sandbox")
    return webdriver.Chrome(options=options)

# === 主程式 ===
def crawl_and_store():
    conn = sqlite3.connect(DB_FILE)
    cur = conn.cursor()

    # 只取「還沒爬過」的 links
    cur.execute("""
        SELECT id, url FROM links
        WHERE status = 'pending'
        LIMIT ?;
    """, (LIMIT_COUNT,))
    links = cur.fetchall()

    print(f"📄 今日設定爬取 {LIMIT_COUNT} 筆，實際可爬 {len(links)} 筆網址。")

    for i, (link_id, url) in enumerate(links, start=1):
        driver = get_driver()
        try:
            print(f"\n🔗 正在爬取 link_id={link_id} URL={url}")
            driver.get(url)

            WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, "h1.t2"))
            )

            # 抓標題
            title = driver.find_element(By.CSS_SELECTOR, "h1.t2").text.strip()

            # 抓發文時間
            try:
                post_time = driver.find_element(By.CSS_SELECTOR, ".o-fNotes.o-fSubMini").text.strip()
            except:
                post_time = "[無時間]"

            # 若是第2頁以後，只抓留言不抓主文
            try:
                content = driver.find_element(By.CSS_SELECTOR, "div[itemprop='articleBody']").text.strip()
            except:
                print(f"找不到主文內容 link_id={link_id}")
                content = "[無主文]"

            # 抓留言
            all_articles = driver.find_elements(By.CSS_SELECTOR, "article.c-articleLimit")
            replies = []
            for a in all_articles[1:]:  # 跳過主文
                reply = a.text.strip()
                if reply.startswith("自") and "引用" in reply:
                    continue
                replies.append(reply)
            replies_joined = "\n\n---\n\n".join(replies)

            # 寫入資料
            conn.execute("""
                INSERT INTO articles (id, link_id, url, title, post_time, content, word_count, replies, reply_count, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                str(ObjectId()),
                link_id,
                url,
                title,
                post_time,
                content,
                len(content),        # ← 自動填字數
                replies_joined,
                len(replies),
                datetime.now().isoformat()
            ))
            conn.commit()

             # 成功 → 標記已完成
            cur.execute("UPDATE links SET status='done' WHERE id=?", (link_id,))
            conn.commit()

            print(f"✅ 成功寫入 link_id={link_id}（留言數：{len(replies)}）")
            time.sleep(10)

        except Exception as e:
            print(f"⚠️ 解析失敗 link_id={link_id}：{e}")
            # 失敗 → 標記 error，避免重複卡死
            cur.execute("UPDATE links SET status='error' WHERE id=?", (link_id,))
            conn.commit()
            time.sleep(10)
        finally:
            driver.quit()

        # 💤 每 10 筆休息一次（放在這裡比較合理）
        if i % 10 == 0:
            print("😴 連續爬了 10 筆，休息 60 秒中…")
            time.sleep(60)

    conn.close()
    print("\n🎉 今日任務完成！")


if __name__ == "__main__":
    init_db()
    crawl_and_store()
