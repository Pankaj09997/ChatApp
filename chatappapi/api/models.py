from typing import Iterable
from django.db import models
from django.contrib.auth.models import BaseUserManager, AbstractBaseUser
from django.core.exceptions import ValidationError
from django.utils import timezone


class MyUserManager(BaseUserManager):
    def create_user(self, email, name, password=None):
        """
        Creates and saves a User with the given email, date of
        birth and password.
        """
        if not email:
            raise ValueError("Users must have an email address")

        user = self.model(
            email=self.normalize_email(email),
            name=name,
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, name, password=None):
        """
        Creates and saves a superuser with the given email, date of
        birth and password.
        """
        user = self.create_user(
            email,
            password=password,
            name=name,
        )
        user.is_admin = True
        user.save(using=self._db)
        return user


class MyUser(AbstractBaseUser):
    email = models.EmailField(
        verbose_name="email address",
        max_length=255,
        unique=True,
    )
    name = models.TextField(default="Guest")
    is_active = models.BooleanField(default=True)
    is_admin = models.BooleanField(default=False)

    objects = MyUserManager()

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["name"]

    def __str__(self):
        return self.email

    def has_perm(self, perm, obj=None):
        "Does the user have a specific permission?"
        # Simplest possible answer: Yes, always
        return True

    def has_module_perms(self, app_label):
        "Does the user have permissions to view the app `app_label`?"
        # Simplest possible answer: Yes, always
        return True

    @property
    def is_staff(self):
        "Is the user a member of staff?"
        # Simplest possible answer: All admins are staff
        return self.is_admin
    
class ProfilePicture(models.Model):
    user=models.OneToOneField(MyUser,on_delete=models.CASCADE,related_name="profile_picture")
    image=models.ImageField(upload_to="post_image",blank=True,null=True)
    uploaded_at=models.DateTimeField(auto_now_add=True)
    def __str__(self) :
        return f"{self.user.email} profile picture"
    
class Friendship(models.Model):
    sender=models.ForeignKey(MyUser,on_delete=models.CASCADE,related_name="sent_requests")
    receiver=models.ForeignKey(MyUser,on_delete=models.CASCADE,related_name="receiver_requests")
    is_accepted=models.BooleanField(default=False)
    created_at=models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        status="Friends"if self.is_accepted else "Request Sent"
        return f"{self.sender.email}->{self.receiver.email} ({status})"
        
    
    


