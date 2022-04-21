
# Register your models here.
from django.contrib import admin
from .models import *
#Configuracion extra 
class ShopperAdmin(admin.ModelAdmin):
    list_display = ('idshopper','name','surname','age','numBoleta','email')

class SellerAdmin(admin.ModelAdmin):
    list_display = ('idseller','name','surname','age','numBoleta','email')

class ProductAdmin(admin.ModelAdmin):
    list_display = ('idproduct','name','price','quantity')

class ContactAdmin(admin.ModelAdmin):
    list_display = ('name','surname','email','subject')

class ProductAdmin(admin.ModelAdmin):
    list_display = ('name','price','quantity','description')

class SellAdmin(admin.ModelAdmin):
    list_display = ('idsell','totalProducts','total')

class PurchaseAdmin(admin.ModelAdmin):
    list_display = ('idshopper','idsell')

class SellProductAdmin(admin.ModelAdmin):
    list_display = ('idproduct','idseller')
# Register your models here.
#admin.site.register(Contact,ContactAdmin)
#admin.site.register(Seller,SellerAdmin)
#admin.site.register(Product,ProductAdmin)
#admin.site.register(Sell,SellAdmin)
#admin.site.register(Shopper,ShopperAdmin)
#admin.site.register(SellProduct,SellProductAdmin)
#admin.site.register(Purchase,PurchaseAdmin)

#Configurando el titulo de admi
title = "El garnachero"
admin.site.site_header = title
admin.site.site_title = title
admin.site.index_title = "Panel de Gestion"

