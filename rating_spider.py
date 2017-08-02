from scrapy import Spider, Request
#from scrapy.selector import Selector
from stockRating.items import StockratingItem

from datetime import date, timedelta


class RatingSpider(Spider):
    name = 'rating_spider'
    
    startDate = date(2016, 7, 28)
    endDate = date(2017, 7, 28)
    daysNum = (endDate - startDate).days
    
    dateList = [date(2016, 7, 28) + timedelta(days = d) for d in range(daysNum)]
    #dateList = [ startDate + timedelta(days = d) for d in range(daysNum)]
    
    
    dateList = map(str, dateList)
    dateList = map(lambda x: x.replace('-', '/'), dateList)
    scrapingUrls = ['https://www.briefing.com/investor/calendars/upgrades-downgrades/' + d for d in dateList]
    
    allowed_urls = ['https://www.briefing.com/investor/calendars/upgrades-downgrades/']
    #start_urls = ['https://www.briefing.com/investor/calendars/upgrades-downgrades/']
    #start_urls = ['https://www.briefing.com/Investor/Calendars/Upgrades-Downgrades/Upgrades/2017/05/05']
    
    # use list comprehension to make list of urls with adding yyy/mm/dd at the end
    start_urls = scrapingUrls
    #['https://www.briefing.com/Investor/Calendars/Upgrades-Downgrades/2017/05/05']

    def verify(self, content):
        if isinstance(content, list):
             if len(content) > 0:
                 content = content[0]
                 # convert unicode to str
                 return content.encode('ascii','ignore')
             else:
                 return ""
        else:
            # convert unicode to str
            return content.encode('ascii','ignore')


    def parse(self, response):
        #ratingType = ['Upgrade', 'Downgrade', '', 'Reiterate']
        #tables = response.xpath('//table[@class="calendar-table"]')
        
        url_list = response.xpath('//a[@class="row-title white"]/@href').extract()
        ratingDate = url_list[0].split('/')[-4:-1]
        ratingDate = '-'.join(ratingDate)
        
        tableUrl = ['https://www.briefing.com/' + l.strip() for l in url_list]
        #ratingDate = tableUrl[0].split('/')[-4:-1]
        #ratingDate = '-'.join(ratingDate)
        
        #url = 'https://www.briefing.com/Investor/Calendars/Upgrades-Downgrades/Initiated/2017/05/05/'
        
        for url in tableUrl:
            yield Request(url, callback=self.parse_tables, meta = {'ratingDate': ratingDate})
        
    def parse_tables(self, response):
        ratingDate = response.meta['ratingDate']
        ratingClass = response.xpath('//div[@class="page-title"]/text()').extract_first().split(' ')[0]
        rows = response.xpath('//table[@class="calendar-table"]//tr')
        
        for i in range(1, len(rows)):
            ratingInfo = rows[i].xpath('.//td/text()').extract()
            company = ratingInfo[0]
            brokerageFirm = ratingInfo[1]
            
            if ratingClass in ['Upgrades', 'Downgrades']:
                rating_from = ratingInfo[2]
                rating = rows[i].xpath('.//td/b/text()').extract_first().split(' ')[2]
                target_from = -1
                target = -1
            elif ratingClass == 'Reiterated':
                rating = ratingInfo[2]
                rating_from = '-1'
                                
                price = ratingInfo[3].split()
                target_from = float(price[0].replace('$', ''))
                target = float(price[2].replace('$', ''))
            else:
                rating = ratingInfo[2]
                rating_from = '-1'
                target_from = -1
                target = -1
            
            ticker = rows[i].xpath('.//td//a/text()').extract_first()
           
            item = StockratingItem()
            item['ratingDate'] = self.verify(ratingDate)
            item['company'] = self.verify(company)
            item['brokerageFirm'] = self.verify(brokerageFirm)
            item['rating_from'] = self.verify(rating_from)
            item['rating'] = self.verify(rating)
            item['ticker'] = self.verify(ticker)
            item['ratingClass'] = self.verify(ratingClass)
            item['target'] = target
            item['target_from'] = target_from
            
            yield item
            
       