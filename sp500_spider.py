from sp500.items import Sp500Item
from scrapy import Spider

class Sp500Spider(Spider):
    name = 'sp500_spider'
    
    allowed_urls = ['https://en.wikipedia.org/']
    start_urls = ['https://en.wikipedia.org/wiki/List_of_S%26P_500_companies']
    
    def parse(self, response):
        rows = response.xpath('//*[@id="mw-content-text"]/div/table[1]//tr')
        
        rowNums = len(rows)
        for i in range(1, rowNums):
            tds = rows[i].xpath('.//td')
            ticker = tds[0].xpath('./a/text()').extract_first()
            name = tds[1].xpath('./a/text()').extract_first()
            sector = tds[3].xpath('./text()').extract_first()
            industry = tds[4].xpath('./text()').extract_first()
            cik = tds[7].xpath('./text()').extract_first()

            item = Sp500Item()
            item['name'] = name.encode('ascii','ignore')
            item['ticker'] = ticker.encode('ascii','ignore')
            item['sector'] = sector.encode('ascii','ignore')
            item['industry'] = industry.encode('ascii','ignore')
            item['cik'] = cik.encode('ascii','ignore')

            yield item

                
                
                


