from django.shortcuts import render

def hyrule(request):
     context = {}
     return render(request, 'hyrule/hyrule.html', context)

def checkout(request):
      context = {}
      return render(request, 'hyrule/checkout.html', context)

def HongGam(request):
      context = {}
      return render(request, 'hyrule/HongGam.html', context)