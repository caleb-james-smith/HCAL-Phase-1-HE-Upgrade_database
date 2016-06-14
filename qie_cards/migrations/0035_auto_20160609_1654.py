# -*- coding: utf-8 -*-
# Generated by Django 1.9.6 on 2016-06-09 21:54
from __future__ import unicode_literals

from django.db import migrations, models
import qie_cards.models


class Migration(migrations.Migration):

    dependencies = [
        ('qie_cards', '0034_auto_20160609_1652'),
    ]

    operations = [
        migrations.AlterField(
            model_name='qiecard',
            name='card_id',
            field=models.CharField(blank=True, default='NULL', max_length=7, validators=[qie_cards.models.validate_id]),
        ),
    ]
