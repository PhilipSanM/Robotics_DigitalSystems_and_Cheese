from django.shortcuts import render

# Create your views here.
from django.shortcuts import render,redirect
from django.contrib.auth.forms import UserCreationForm,  AuthenticationForm
from .forms import *
from .models import *
from .templates.users import *
from django.contrib.auth import authenticate, login, logout
# Create your views here.
def index(request):
    return render(request,'index.html')

def inicio(request):
    return render(request, 'index.html')

def contact(request):
    return render(request,'contact.html')

def providers(request):
    sellers = Seller.objects.all()

    return render(request, 'providers.html',{
        'sellers' : sellers
    })

def about(request):
    return render(request, 'about.html')

def thankyou(request):
    return render(request,'thankyou.html')

def cart(request):
    producto_1 = Product.objects.get(idproduct=9)
    producto_2 = Product.objects.get(idproduct=12)
    return render(request, 'cart.html',{
        'producto_1':producto_1,
        'producto_2':producto_2
    })

def checkout(request):
    return render(request,'checkout.html')

def success(request):
    return render(request, 'users/successfulRegister.html')

def homeseller(request):
    vendedor = Seller.objects.get(idseller=14)
    name = seller.name
    return render(request,'users/homeseller.html',{
        'seller' : seller,
        'name' : name 
    })

def homebuyer(request):
    comprador = Shopper.objects.get(idshopper=11)
    return render(request,'users/homebuyer.html',{
        'shopper' : shopper
    })



def register_page(request):
    register_form = RegForm(request.POST or None)
    if register_form.is_valid():
        form_data = register_form.cleaned_data
        name = form_data.get("nombre")
        surname = form_data.get("apellido")
        numBoleta = form_data.get("boleta")
        age = form_data.get("edad")
        email = form_data.get("email")
        password = form_data.get("password")     
        tipo = form_data.get("tipo")   

        if tipo == 0:
            obj = Seller.objects.create(name=name,surname=surname,numBoleta=numBoleta,
        age=age,email=email,password=password)
            
            return render(request,'users/successfulRegister.html',{
                'name' : name
            })
        else: 
            obj = Shopper.objects.create(name=name,surname=surname,numBoleta=numBoleta,
        age=age,email=email,password=password)
            return render(request,'users/successfulRegister.html',{
                'name': name
            })

    return render(request,'users/register.html',{
    'register_form': register_form
    })


def contact_page(request):
    contact_page = ContactForm(request.POST or None)
    if contact_page.is_valid():
        form_data = contact_page.cleaned_data
        name = form_data.get("nombre")
        surname = form_data.get("apellido")
        email = form_data.get("email")
        subject = form_data.get("asunto")
        message = form_data.get("mensaje") 

        obj = Contact.objects.create(name=name,surname=surname,email=email,subject=subject,
        message=message)
        return render(request,'index.html')
    return render(request,'contact.html',{
        'contact_page' : contact_page
    })

def register_product(request):
    register_product = addProductForm(request.POST, request.FILES)
    if register_product.is_valid():
        form_data=register_product.cleaned_data
        name = form_data.get("nombre")
        price = form_data.get("precio")
        description = form_data.get("descripcion")
        quantity = form_data.get("cantidad")
        image = form_data.get('imagen')
        obj = Product.objects.create(name=name,price=price,description=description,quantity=quantity, image=image)
        return render(request,'index.html')
    return render(request,'addProduct.html',{
        'register_product' : register_product
    })


def login_page(request):
    login_page = LoginForm(request.POST or None)
    if login_page.is_valid():
        form_data = login_page.cleaned_data
        email = form_data.get("email")
        password = form_data.get("password")
        tipo = form_data.get("tipo")
        products = shop(request)
        if tipo == 0: 
            user = Seller.objects.filter(email = email, password = password)
            #obj = Seller.authenticate(email=email, password=password)
            if user is not None:
                return render(request,'users/homeseller.html')
        if tipo ==  1: 
             user = Shopper.objects.filter(email = email, password = password)
             if user is not None:
                return render(request,'users/homebuyer.html')

    return render(request,'users/login.html',{
        'login_page' : login_page
    })

def shop(request):
    products = Product.objects.all()
    
    return render(request,'shop.html',{
        'products' : products
    })


