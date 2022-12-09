from django.urls import path
from . import views

urlpatterns = [
        #Leave as empty string for base url
    path('', views.hyrule, name="hyrule"),
	path('checkout/', views.checkout, name="checkout"),
    path('HongGam/', views.HongGam, name="HongGam")

]