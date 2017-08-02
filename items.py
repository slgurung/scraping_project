# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

from scrapy import Item, Field


class StockratingItem(Item):
    ratingDate = Field()
    company = Field()
    ticker = Field()
    brokerageFirm = Field()
    rating_from = Field()
    rating = Field()
    ratingClass = Field()
    target = Field()
    target_from = Field()
