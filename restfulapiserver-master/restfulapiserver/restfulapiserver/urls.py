from django.urls import include, re_path, path
from django.contrib.auth.models import User
from rest_framework import routers, serializers, viewsets
from bins import views


# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path('bins/', views.bins_list),
    path('bins/<int:pk>/', views.bins),
    re_path('api-auth/', include('rest_framework.urls', namespace='rest_framework'))
]
