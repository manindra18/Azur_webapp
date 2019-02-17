"""
Definition of forms.
"""

from django import forms
from django.contrib.auth.forms import AuthenticationForm, UserCreationForm
from django.utils.translation import ugettext_lazy as _


class BootstrapAuthenticationForm(AuthenticationForm):
    """Authentication form which uses boostrap CSS."""
    username = forms.CharField(max_length=254,
                               widget=forms.TextInput({
                                   'class': 'form-control',
                                   'placeholder': 'User name'}))
    password = forms.CharField(label=_("Password"),
                               widget=forms.PasswordInput({
                                   'class': 'form-control',
                                   'placeholder': 'Password'}))


class UserRegistrationForm(forms.Form):
    username = forms.CharField(
        required=True,
        label='Username',
        max_length=64,
        widget=forms.TextInput({
            'class': 'form-control',
            'placeholder': 'User name'})
    )
    email = forms.CharField(
        required=True,
        label='Email',
        max_length=64,
        widget=forms.TextInput({
            'class': 'form-control',
            'placeholder': 'Email'})
    )
    password1 = forms.CharField(
        required=True,
        label='Password',
        max_length=32,
        widget=forms.PasswordInput({
            'class': 'form-control',
            'placeholder': 'Password'})
    )
    password2 = forms.CharField(
        required=True,
        label='Retype-Password',
        max_length=32,
        widget=forms.PasswordInput({
            'class': 'form-control',
            'placeholder': 'Retype-Password'})
    )
