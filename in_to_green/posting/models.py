from django.db import models

# Create your models here.
class Posting(models.Model):
    id = models.AutoField(primary_key=True)
    registeredTime = models.DateTimeField(auto_now=True)
    title = models.CharField(max_length=500)
    content = models.CharField(max_length=50000)
    userDeviceId = models.CharField(max_length = 500)