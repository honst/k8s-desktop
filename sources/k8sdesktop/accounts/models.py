from django.db import models

class Autor(models.Model):
    name = models.CharField(max_length=30)
    address = models.CharField(max_length=50)
    city = models.CharField(max_length=60)
    state_province = models.CharField(max_length=30,blank=True)
    country = models.CharField(max_length=50)
    website = models.URLField()
    publication_date = models.DateField(blank=True,null=True)

    def __str__(self):
        return('%s-%s' % (self.name, self.city))
