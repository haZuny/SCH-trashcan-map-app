from distutils.command.upload import upload
from email.policy import default
from django.db import models

# Create your models here.
class Trash(models.Model):
    id = models.AutoField(primary_key=True)
    latitude = models.FloatField()
    longitude = models.FloatField()
    registeredTime = models.DateTimeField(auto_now=True)
    posDescription = models.CharField(max_length=500)
    image = models.ImageField(upload_to="", null=True)
        
