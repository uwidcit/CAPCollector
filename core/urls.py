"""URL mapping for core module."""

__author__ = "Arkadii Yakovets (arcadiy@google.com)"

from core import views
from django.conf.urls import url
from django.views.decorators.csrf import csrf_exempt

urlpatterns = [
    url(r"^$", views.IndexView.as_view()),
    url(r"^feed.(?P<feed_type>(html|json|xml))$", views.FeedView.as_view(),
        name="feed"),
    url(r"^feed/(?P<alert_id>.*).(?P<feed_type>(html|xml|json))$",
        views.FeedView.as_view(), name="alert"),
    url(r"^post/$", csrf_exempt(views.PostView.as_view()), name="post"),
    url(r"^template/(?P<template_type>(area|message))/$",
        csrf_exempt(views.AlertTemplateView.as_view()), name="template"),
    url(r"^preview/polygons$",
        views.GeocodePolygonPreviewView.as_view(),
        name="geocodepreviewpolygons"),
]
