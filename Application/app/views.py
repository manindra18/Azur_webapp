"""
Definition of views.
"""
from django import forms
from django.shortcuts import render
from django.http import HttpRequest, HttpResponseRedirect
from django.contrib.auth import authenticate, login
from django.contrib.auth.models import User
from datetime import datetime
from .forms import UserRegistrationForm
from django.views.decorators.csrf import csrf_protect


def home(request):
    """Renders the home page."""
    assert isinstance(request, HttpRequest)
    return render(
        request,
        'app/index.html',
        {
            'title': 'Home Page',
            'year': datetime.now().year,
        }
    )


def contact(request):
    """Renders the contact page."""
    assert isinstance(request, HttpRequest)
    return render(
        request,
        'app/contact.html',
        {
            'title': 'Contact',
            'message': 'Your contact page.',
            'year': datetime.now().year,
        }
    )


def about(request):
    """Renders the about page."""
    assert isinstance(request, HttpRequest)
    return render(
        request,
        'app/about.html',
        {
            'title': 'About',
            'message': 'Your application description page.',
            'year': datetime.now().year,
        }
    )


@csrf_protect
def register(request, **kwargs):
    title = kwargs['title']
    year = kwargs['year']
    if request.method == 'POST':
        form = UserRegistrationForm(request.POST)
        if form.is_valid():
            userObj = form.cleaned_data
            username = userObj.get('username')
            email = userObj.get('email')
            password1 = userObj.get('password1')

            if not (User.objects.filter(username=username).exists() or User.objects.filter(email=email).exists()):
                print("creating user now.....")
                user = User.objects.create_user(username, email, password1)
                user = authenticate(username=username, password=password1)
                login(request, user, backend='django.contrib.auth.backends.ModelBackend')
                return HttpResponseRedirect('/')
            else:
                raise forms.ValidationError(
                    'Looks like a username with that email or password already exists')
    else:
        form = UserRegistrationForm()
        return render(request, 'app/register.html', {'form': form, 'title': title, 'year': year})
