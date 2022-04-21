from django import forms
from .models import *

class RegForm(forms.Form):
    nombre  = forms.CharField(max_length=100)
    apellido = forms.CharField(max_length=100)
    boleta = forms.IntegerField()
    edad = forms.IntegerField() 
    email = forms.EmailField()
    password = forms.CharField(max_length=10,widget = forms.PasswordInput)
    tipo = forms.IntegerField()

class ContactForm(forms.Form):
    nombre  = forms.CharField(max_length=100)
    apellido = forms.CharField(max_length=100)
    email = forms.EmailField()
    asunto = forms.CharField(max_length=20)
    mensaje = forms.CharField(max_length=1000, widget = forms.Textarea)

class addProductForm(forms.Form):
    nombre = forms.CharField(max_length=50)
    precio = forms.IntegerField()
    descripcion = forms.CharField(max_length=500, widget = forms.Textarea)
    cantidad = forms.IntegerField()
    imagen = forms.ImageField()


class LoginForm(forms.Form):
    email = forms.EmailField()
    password = forms.CharField(max_length= 10,widget= forms.PasswordInput)
    tipo = forms.IntegerField()
