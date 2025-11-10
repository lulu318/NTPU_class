from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import sqlite3
from datetime import datetime
from bson import ObjectId
from datetime import datetime

# === 資料庫設定 ===
DB_FILE = "/Users/lulutsai/Documents/NTPU_class/paper/code/mobile01_clawler/ntpu_paper.sqlite"

def get_conn():
    conn = sqlite3.connect(DB_FILE)
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn

def create_table_links(conn):
    conn.execute("""
        CREATE TABLE IF NOT EXISTS links (
            id TEXT PRIMARY KEY,          -- MongoDB ObjectId 字串
            url TEXT,
            title TEXT,
            description TEXT,
            crawl_time TEXT,              -- ISO 格式字串
            keyword TEXT,                 -- 搜尋關鍵字
            has_emotional_abuse INTEGER   -- 是否含有「情緒勒索」：1 或 0
        );
    """)
    conn.execute("CREATE INDEX IF NOT EXISTS idx_links_url ON links(url);")
    conn.execute("CREATE INDEX IF NOT EXISTS idx_links_crawl_time ON links(crawl_time);")
    conn.execute("CREATE INDEX IF NOT EXISTS idx_links_keyword ON links(keyword);")


def insert_new_links(conn, id=None, url=None, title=None, description=None, crawl_time=None, keyword=None, has_emotional_abuse=None):
    id = id or str(ObjectId())
    crawl_time = crawl_time or datetime.now().isoformat()
    conn.execute("""
        INSERT OR IGNORE INTO links (id, url, title, description, crawl_time, keyword, has_emotional_abuse)
        VALUES (?, ?, ?, ?, ?, ?, ?);
    """, (id, url, title, description, crawl_time, keyword, has_emotional_abuse))



def get_existing_urls(conn):
    cursor = conn.execute("SELECT url FROM links;")
    return set(row[0] for row in cursor.fetchall())

def jump_to_page(driver, page_number):
    WebDriverWait(driver, 10).until(
        EC.presence_of_all_elements_located((By.CSS_SELECTOR, ".gsc-cursor-page"))
    )
    page_buttons = driver.find_elements(By.CSS_SELECTOR, ".gsc-cursor-page")
    for btn in page_buttons:
        if btn.text.strip() == str(page_number):
            driver.execute_script("arguments[0].scrollIntoView(true);", btn)
            WebDriverWait(driver, 5).until(
                EC.element_to_be_clickable((By.XPATH, f"//div[text()='{page_number}']"))
            )
            btn.click()
            print(f"🚀 已跳轉至第 {page_number} 頁")
            time.sleep(2)
            return True
    print(f"❌ 找不到第 {page_number} 頁的按鈕")
    return False


# === 抓取 Mobile01 搜尋結果 ===
def scrape_mobile01(keyword, max_pages=5, start_page=1):
    from selenium import webdriver
    from selenium.webdriver.common.by import By
    from selenium.webdriver.support.ui import WebDriverWait
    from selenium.webdriver.support import expected_conditions as EC
    from selenium.webdriver.chrome.options import Options
    import time

    options = Options()
    options.add_argument('--disable-blink-features=AutomationControlled')
    options.add_argument("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120 Safari/537.36")
    driver = webdriver.Chrome(options=options)

    url = f"https://www.mobile01.com/googlesearch.php?query={keyword}"
    driver.get(url)

    # ✅ 跳轉到起始頁
    if start_page > 1:
        success = jump_to_page(driver, start_page)
        if not success:
            driver.quit()
            return []

    seen_links = set()
    unique_articles = []
    page = start_page
    pages_crawled = 0

    while True:
        print(f"📄 抓取第 {page} 頁…")

        try:
            WebDriverWait(driver, 10).until(
                EC.presence_of_all_elements_located((By.CSS_SELECTOR, ".gs-title a"))
            )
            time.sleep(4)
            results = driver.find_elements(By.CSS_SELECTOR, ".gs-title a")
            for r in results:
                title = r.text.strip()
                link = r.get_attribute("href")
                if link and "topicdetail.php" in link and link not in seen_links:
                    seen_links.add(link)
                    unique_articles.append((title, link))
        except Exception as e:
            print(f"⚠️ 抓取失敗：{e}")
            break

        pages_crawled += 1
        if pages_crawled >= max_pages:
            print(f"🚫 已達最大抓取頁數 {max_pages}，停止。")
            break

        try:
            driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
            time.sleep(1.5)

            WebDriverWait(driver, 10).until(
                EC.presence_of_all_elements_located((By.CSS_SELECTOR, ".gsc-cursor-page"))
            )
            pages = driver.find_elements(By.CSS_SELECTOR, ".gsc-cursor-page")
            current_page_elements = driver.find_elements(By.CSS_SELECTOR, ".gsc-cursor-page.gsc-cursor-current-page")

            if not current_page_elements or not pages:
                print("⚠️ 無法取得頁碼資訊，停止翻頁。")
                break

            current_page = current_page_elements[0]
            page_texts = [p.text.strip() for p in pages if p.text.strip()]
            try:
                current_index = page_texts.index(current_page.text.strip())
            except ValueError:
                print("⚠️ 頁碼索引錯誤，停止翻頁。")
                break

            if current_index + 1 >= len(pages):
                print("🚫 沒有更多頁面，停止翻頁。")
                break

            next_button = pages[current_index + 1]
            driver.execute_script("arguments[0].scrollIntoView(true);", next_button)
            WebDriverWait(driver, 5).until(
                EC.element_to_be_clickable((By.XPATH, f"//div[text()='{next_button.text}']"))
            )
            next_button.click()
            page += 1
            time.sleep(2)

        except Exception as e:
            print(f"🚫 找不到下一頁按鈕，停止翻頁。（{e}）")
            break

    driver.quit()
    return unique_articles

keywords = [
    "情緒勒索",
    "情緒控制",
    "情緒綁架",
    "冷暴力",
    "PUA",
    "精神控制",
    "操控關係",
    "道德綁架",
    "控制慾",
    "有毒關係",
    "操控型人格",
    "情感勒索",
    "情勒"
]

# === 主程式 ===
if __name__ == "__main__":
    keyword = keywords[12]
    has_emotional_abuse = 1 # 這個要記得input 看他的關鍵字是否跟情緒勒索有關
    articles = scrape_mobile01(keyword, max_pages=10)

    print(f"✅ 共抓到 {len(articles)} 篇文章，準備寫入資料庫...")

    conn = get_conn()
    create_table_links(conn)
    existing_urls = get_existing_urls(conn)

    for title, link in articles:
        if link in existing_urls:
            print(f"⏭️ 已存在於資料庫，略過：{link}")
            continue

        doc_id = str(ObjectId())
        insert_new_links(conn,
                        id=doc_id,
                        url=link,
                        title=title,
                        description=f"來源：Mobile01 搜尋關鍵字「{keyword}」",
                        keyword=keyword, 
                        has_emotional_abuse=has_emotional_abuse)
    conn.commit()
    conn.close()

    print(f"✅ 已寫入 SQLite：{DB_FILE}")
