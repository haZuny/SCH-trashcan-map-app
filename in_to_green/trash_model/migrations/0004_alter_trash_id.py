# Generated by Django 3.2.16 on 2022-11-05 12:03

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('trash_model', '0003_auto_20221105_2024'),
    ]

    operations = [
        migrations.AlterField(
            model_name='trash',
            name='id',
            field=models.IntegerField(primary_key=True, serialize=False),
        ),
    ]
