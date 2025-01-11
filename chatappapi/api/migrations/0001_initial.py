# Generated by Django 5.1.4 on 2024-12-08 14:08

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):
    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="MyUser",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("password", models.CharField(max_length=128, verbose_name="password")),
                (
                    "last_login",
                    models.DateTimeField(
                        blank=True, null=True, verbose_name="last login"
                    ),
                ),
                (
                    "email",
                    models.EmailField(
                        max_length=255, unique=True, verbose_name="email address"
                    ),
                ),
                ("name", models.TextField(default="Guest")),
                ("is_active", models.BooleanField(default=True)),
                ("is_admin", models.BooleanField(default=False)),
            ],
            options={
                "abstract": False,
            },
        ),
        migrations.CreateModel(
            name="Friendship",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("friend_request_sent", models.BooleanField(default=False)),
                ("is_accepted", models.BooleanField(default=False)),
                ("created_at", models.DateTimeField(auto_now_add=True)),
                (
                    "receiver",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="receiver_requests",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
                (
                    "sender",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="sent_requests",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
        ),
# Change from settings.AUTH_USER_MODEL to 'api.MyUser' (or the correct app name where MyUser is defined)
migrations.CreateModel(
    name="MyChats",
    fields=[
        (
            "id",
            models.BigAutoField(
                auto_created=True,
                primary_key=True,
                serialize=False,
                verbose_name="ID",
            ),
        ),
        ("chats", models.JSONField(default=list)),
        (
            "frnd",
            models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                related_name="chat_as_friend",
                to="api.MyUser",  # Change to "api.MyUser" instead of settings.AUTH_USER_MODEL
            ),
        ),
        (
            "me",
            models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                related_name="chats_as_me",
                to="api.MyUser",  # Change to "api.MyUser" instead of settings.AUTH_USER_MODEL
            ),
        ),
    ],
),

        migrations.CreateModel(
            name="ProfilePicture",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "image",
                    models.ImageField(blank=True, null=True, upload_to="post_image"),
                ),
                ("uploaded_at", models.DateTimeField(auto_now_add=True)),
                (
                    "user",
                    models.OneToOneField(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="profile_picture",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
        ),
    ]
