from dataclasses import fields
from rest_framework import serializers
from trash_model.models import Trash

class TrashSerializer(serializers.ModelSerializer):
    class Meta:
        model=Trash
        fields = ('__all__')