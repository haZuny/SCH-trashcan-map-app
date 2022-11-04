from django.urls import include, path
from . import views
# from rest_framework import routers
# from trash_model.views import TrashViewSet

# router = routers.DefaultRouter()
# router.register('trash', TrashViewSet)

urlpatterns = [
   path('', views.TrashList.as_view()),
   path('<int:pk>', views.TrashDetail.as_view()),
]