# -*- coding: utf-8 -*-
# Generated by Django 1.9.6 on 2016-06-06 17:05
from __future__ import unicode_literals

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('qie_cards', '0023_auto_20160606_1204'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='tester',
            name='email',
        ),
    ]
