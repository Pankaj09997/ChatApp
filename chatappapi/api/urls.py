from django.urls import path
from api.views import UserRegistrationView, UserLoginView, UserProfileView, UserChangePasswordView,ProfilePictureView,UserSearchView
from django.conf.urls.static import static
from django.conf import settings
from django.urls import path

urlpatterns=[
    path('signup/', UserRegistrationView.as_view(), name='signup'),
    path('login/', UserLoginView.as_view(), name='login'),
    path('profile/', UserProfileView.as_view(), name='profile'),
    path('changepassword/', UserChangePasswordView.as_view(), name='changepassword'),
    path('profilepicture/',ProfilePictureView.as_view(),name="profile picture"),
    path('user/search/',UserSearchView.as_view(),name="user search"),
]
