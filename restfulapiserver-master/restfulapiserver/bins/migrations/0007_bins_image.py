# Generated by Django 4.1.3 on 2022-11-03 03:02

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('bins', '0006_alter_bins_posdescription'),
    ]

    operations = [
        migrations.AddField(
            model_name='bins',
            name='image',
            field=models.FileField(default='', upload_to='image'),
        ),
    ]