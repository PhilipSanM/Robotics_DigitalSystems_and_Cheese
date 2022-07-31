"""rifando URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from miapp import views
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('',views.index,name="index"),
    path('index/',views.inicio,name="index"),
    path('providers/',views.providers, name="providers"),
    path('about/', views.about, name="about"),
    path('shop/',views.shop,name="shop"),
    path('cart/',views.cart,name="cart"),
    path('contact/',views.contact_page,name="contact"),
    path('register/',views.register_page,name="register"),
    path('success/',views.success,name ="success"),
    path('addProduct/',views.register_product, name= "addProduct"),
    path('login/',views.login_page,name="login"),
    path('homeseller/',views.homeseller,name="homeseller"),
    path('homebuyer/',views.homebuyer,name="homebuyer"),
    path('checkout/',views.checkout,name = "checkout"),
    path('thankyou/',views.thankyou, name ="thankyou"),
]
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root = settings.MEDIA_ROOT)
