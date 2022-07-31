from django.db import models

# Create your models here.
from django.db import models
# Create your models here.

class Contact(models.Model): 
    idMensaje = models.AutoField(primary_key=True, verbose_name = 'idMensaje')
    name = models.CharField(max_length=50, verbose_name='Nombre')
    surname = models.CharField(max_length=50, verbose_name='Apellido')
    email = models.EmailField(max_length=50, verbose_name= 'Email')
    subject = models.TextField(max_length=50, verbose_name='Asunto')
    message = models.TextField(max_length=1000, verbose_name='Mensaje')

    class Meta:
        verbose_name = 'Contacto'
        verbose_name_plural = 'Contactos'
    def __str__(self):
        return self.name

class Seller(models.Model):
    idseller  = models.AutoField(primary_key = True, verbose_name = 'idVendedor')
    name = models.CharField(max_length=50, verbose_name='Nombre')
    surname = models.CharField(max_length=50, verbose_name='Apellido')
    numBoleta = models.IntegerField(verbose_name='Boleta')
    age = models.IntegerField(verbose_name='Edad')
    email = models.EmailField(max_length=50, verbose_name= 'Email', unique = True )
    password = models.CharField(max_length=16,verbose_name='Password')
    image = models.ImageField(upload_to="media", default = 'null')

    class Meta:
        verbose_name = 'Vendedor'
        verbose_name_plural = 'Vendedores'
    def __str__(self):
        return self.name

class Product(models.Model):
    idproduct = models.AutoField(primary_key= True, verbose_name ='IdProducto')
    name = models.CharField(max_length=50,verbose_name='Nombre')
    price = models.IntegerField(verbose_name='Precio')
    description = models.TextField(max_length=500, verbose_name='Descripcion')
    quantity = models.IntegerField(verbose_name= 'Cantidad')
    image = models.ImageField(upload_to="media", default = 'null')

    class Meta:
        verbose_name = 'Producto'
        verbose_name_plural = 'Productos'
    def __str__(self):
        return self.name

class Sell(models.Model):
    idsell = models.AutoField(primary_key = True, verbose_name = 'IdVenta')
    totalProducts = models.IntegerField(verbose_name ='TotalProductos')
    total = models.IntegerField(verbose_name= 'Total')

    class Meta: 
        verbose_name = 'Venta'
        verbose_name_plural = 'Ventas'

class Shopper(models.Model):
    idshopper = models.AutoField(primary_key=True, verbose_name = 'IdComprador')
    name = models.CharField(max_length=50,verbose_name='Nombre')
    surname = models.CharField(max_length=50, verbose_name='Apellido')
    numBoleta = models.IntegerField(verbose_name='Boleta')
    age = models.IntegerField(verbose_name='Edad')
    email = models.EmailField(max_length=50, verbose_name= 'Email',unique= True)
    password = models.CharField(max_length=16,verbose_name='Password')
    image = models.ImageField(upload_to="media", default = 'null')

    class Meta: 
        verbose_name = 'Comprador'
        verbose_name_plural = 'Compradores'
    def __str__(self):
        return self.name

class SellProduct(models.Model):
    idproduct = models.ForeignKey('Product',on_delete=models.CASCADE,verbose_name='Idproducto')
    idseller = models.ForeignKey('Seller',on_delete=models.CASCADE,verbose_name='IdVendedor')

    class Meta:
        verbose_name = 'VendProducto'
        verbose_name_plural = 'VendProductos'
   

class Purchase(models.Model):
    idshopper = models.ForeignKey('Shopper',on_delete= models.CASCADE, verbose_name = 'IdComprador')
    idsell = models.ForeignKey('Sell', on_delete= models.CASCADE, verbose_name = 'IdVenta')

    class Meta:
        verbose_name = 'Compra'
        verbose_name_plural = 'Compras' 

    

