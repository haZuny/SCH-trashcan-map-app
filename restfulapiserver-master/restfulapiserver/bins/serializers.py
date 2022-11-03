from rest_framework import serializers
from .models import Bins


class BinsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Bins
        fields = ['id', 'latitude', 'longitude', 'registeredTime', 'posDescription', 'image']


