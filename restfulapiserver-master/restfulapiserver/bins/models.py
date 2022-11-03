from django.db import models

# Create your models here.


class Bins(models.Model):
    id = models.AutoField(primary_key=True)
    latitude = models.FloatField(max_length=100)
    longitude = models.FloatField(max_length=100)
    registeredTime = models.DateTimeField(auto_now=True)
    posDescription = models.CharField(max_length=300, default="")
    image = models.FileField(upload_to="image", default="")

    class Meta:
        ordering = ['id']