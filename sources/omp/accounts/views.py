from django.contrib.auth import authenticate,login as auth_login,logout as auth_logout
from django.contrib.auth.models import User
from django.shortcuts import render, get_object_or_404, HttpResponseRedirect
from django.views.decorators.csrf import csrf_exempt
import json
from . import forms
# Create your views here.

def login(request):
    if request.method == "POST":
        login_form = forms.UserForm(request.POST)
        message = "请检查填写的内容！"
        if login_form.is_valid():
            username = login_form.cleaned_data['username']
            password = login_form.cleaned_data['password']
            try:
                user = authenticate(username=username, password=password)
                if user is not None:
                    auth_login(request, user)
                    request.session['username'] = username
                    return HttpResponseRedirect('/assets/index/')
                else:
                    message = "用户登录错误！"
            except Exception as e:
                print('err:', e)
                message = "用户不存在！"
        return render(request, 'accounts/login.html', locals())

    login_form = forms.UserForm()
    return render(request, 'accounts/login.html', locals())

def logout(request):
    try:
        auth_logout(request)
        #return render(request, 'accounts/login.html', locals())
        return HttpResponseRedirect('/accounts/login/')
    except Exception as e:
        print('err', e)
