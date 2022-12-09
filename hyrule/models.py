from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class Branch(models.Model):
    code = models.CharField(primary_key=True, max_length=10)
    province = models.CharField(max_length=10)
    address = models.CharField(unique=True, max_length=30)
    phone = models.CharField(unique=True, max_length=10, blank=True, null=True)
    email = models.CharField(unique=True, max_length=30, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'branch'

class Picture(models.Model):
    branch_code = models.OneToOneField(Branch, models.DO_NOTHING, db_column='branch_code', primary_key=True)
    picture = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'picture'
        unique_together = (('branch_code', 'picture'),)

class Zone(models.Model):
    branch_code = models.OneToOneField(Branch, models.DO_NOTHING, db_column='branch_code', primary_key=True)
    name_zone = models.CharField(max_length=30, unique=True)

    class Meta:
        managed = False
        db_table = 'zone'
        unique_together = (('branch_code', 'name_zone'),)

class Roomtype(models.Model):
    code = models.AutoField(primary_key=True)
    name_rtype = models.CharField(max_length=30, blank=True, null=True)
    space_rtype = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    nocustomers = models.BigIntegerField()
    other = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'roomtype'

class Bed(models.Model):
    roomtype_code = models.OneToOneField('Roomtype', models.DO_NOTHING, db_column='roomtype_code', primary_key=True)
    space_bed = models.DecimalField(max_digits=2, decimal_places=1)
    number_bed = models.BigIntegerField()

    class Meta:
        managed = False
        db_table = 'bed'
        unique_together = (('roomtype_code', 'space_bed'),)

class RBranchRoomtype(models.Model):
    roomtype_code = models.OneToOneField('Roomtype', models.DO_NOTHING, db_column='roomtype_code', primary_key=True)
    branch_code = models.ForeignKey(Branch, models.DO_NOTHING, db_column='branch_code', related_name="RBranch_branch_code")
    price = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'r_branch_roomtype'
        unique_together = (('roomtype_code', 'branch_code'),)


class Room(models.Model):
    branch_code = models.OneToOneField('Zone', models.DO_NOTHING, db_column='branch_code', primary_key=True)
    number_room = models.CharField(max_length=3, unique=True)
    roomtype_code = models.ForeignKey('Roomtype', models.DO_NOTHING, db_column='roomtype_code', blank=True, null=True, related_name="Room_roomtype_code")
    zone_name = models.ForeignKey('Zone', models.DO_NOTHING, db_column='zone_name', to_field='name_zone', blank=True, null=True, related_name="Room_zone_name")

    class Meta:
        managed = False
        db_table = 'room'
        unique_together = (('branch_code', 'number_room'),)

class Supplytype(models.Model):
    code = models.CharField(primary_key=True, max_length=6)
    name_suptype = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'supplytype'


class RRoomtypeSupplytype(models.Model):
    roomtype_code = models.OneToOneField('Roomtype', models.DO_NOTHING, db_column='roomtype_code', primary_key=True)
    supplytype_code = models.ForeignKey('Supplytype', models.DO_NOTHING, db_column='supplytype_code', related_name="RRoomSup_Suptype_code")
    number_rrstype = models.BigIntegerField()

    class Meta:
        managed = False
        db_table = 'r_roomtype_supplytype'
        unique_together = (('roomtype_code', 'supplytype_code'),)


class Supply(models.Model):
    branch_code = models.OneToOneField(Room, models.DO_NOTHING, db_column='branch_code', primary_key=True)
    supplytype_code = models.ForeignKey('Supplytype', models.DO_NOTHING, db_column='supplytype_code', related_name="supply_type_code")
    ssn = models.BigIntegerField()
    situation = models.CharField(max_length=10, blank=True, null=True)
    room_number = models.ForeignKey(Room, models.DO_NOTHING, db_column='room_number', to_field='number_room', blank=True, null=True, related_name="supply_rnum")

    class Meta:
        managed = False
        db_table = 'supply'
        unique_together = (('branch_code', 'supplytype_code', 'ssn'),)


class Provider(models.Model):
    code = models.CharField(primary_key=True, max_length=7)
    name_provider = models.CharField(unique=True, max_length=30)
    email = models.CharField(unique=True, max_length=30, blank=True, null=True)
    address = models.CharField(max_length=30, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'provider'


class RProvide(models.Model):
    provider_code = models.ForeignKey(Provider, models.DO_NOTHING, db_column='provider_code', blank=True, null=True, related_name="RProvide_provider_code")
    supplytype_code = models.OneToOneField('Supplytype', models.DO_NOTHING, db_column='supplytype_code', primary_key=True)
    branch_code = models.ForeignKey(Branch, models.DO_NOTHING, db_column='branch_code', related_name="RProvide_branch_code")

    class Meta:
        managed = False
        db_table = 'r_provide'
        unique_together = (('supplytype_code', 'branch_code'),)

class Customer(models.Model):
    code = models.CharField(primary_key=True, max_length=8)
    id_cus = models.CharField(unique=True, max_length=12)
    name_cus = models.CharField(max_length=30)
    phone = models.CharField(unique=True, max_length=10, blank=True, null=True)
    email = models.CharField(unique=True, max_length=30, blank=True, null=True)
    address = models.CharField(max_length=30, blank=True, null=True)
    username = models.CharField(unique=True, max_length=30, blank=True, null=True)
    password_cus = models.CharField(max_length=30, blank=True, null=True)
    point_cus = models.BigIntegerField()
    type_cus = models.BigIntegerField()

    class Meta:
        managed = False
        db_table = 'customer'


class Servicetype(models.Model):
    name_sertype = models.CharField(primary_key=True, max_length=30)
    nodate = models.IntegerField()
    nocustomer = models.IntegerField()
    price = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'servicetype'

class Billservice(models.Model):
    customer_code = models.OneToOneField('Customer', models.DO_NOTHING, db_column='customer_code', primary_key=True)
    servicetype_name = models.ForeignKey('Servicetype', models.DO_NOTHING, db_column='servicetype_name', related_name="billser_typeser_name")
    timebooking = models.DateTimeField()
    startingdate = models.DateField(blank=True, null=True)
    sum_bser = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'billservice'
        unique_together = (('customer_code', 'servicetype_name', 'timebooking'),)


class Booking(models.Model):
    code = models.CharField(primary_key=True, max_length=16)
    timebooking = models.DateTimeField(blank=True, null=True)
    nocustumer = models.IntegerField(blank=True, null=True)
    datereciving = models.DateField(blank=True, null=True)
    datereturning = models.DateField(blank=True, null=True)
    situation = models.BigIntegerField(blank=True, null=True)
    sum_booking = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    customer_code = models.ForeignKey('Customer', models.DO_NOTHING, db_column='customer_code', blank=True, null=True, related_name= "booking_cus_code")
    servicetype_name = models.ForeignKey('Servicetype', models.DO_NOTHING, db_column='servicetype_name', blank=True, null=True, related_name="booking_sertype_name")

    class Meta:
        managed = False
        db_table = 'booking'



class Renting(models.Model):
    booking_code = models.OneToOneField(Booking, models.DO_NOTHING, db_column='booking_code', primary_key=True)
    branch_code = models.ForeignKey('Room', models.DO_NOTHING, db_column='branch_code', related_name="Renting_branch_code")
    room_number = models.ForeignKey('Room', models.DO_NOTHING, db_column='room_number', to_field='number_room', related_name="Renting_room_number")

    class Meta:
        managed = False
        db_table = 'renting'
        unique_together = (('booking_code', 'branch_code', 'room_number'),)



class Bill(models.Model):
    code = models.CharField(primary_key=True, max_length=16)
    timereciving = models.CharField(max_length=5, blank=True, null=True)
    timeturning = models.CharField(max_length=5, blank=True, null=True)
    booking_code = models.OneToOneField('Booking', models.DO_NOTHING, db_column='booking_code')

    class Meta:
        managed = False
        db_table = 'bill'


class Lessee(models.Model):
    code = models.CharField(primary_key=True, max_length=6)
    name_les = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'lessee'


class Service(models.Model):
    code = models.CharField(primary_key=True, max_length=6)
    type_service = models.CharField(max_length=1)
    nocustomer = models.IntegerField(blank=True, null=True)
    style_service = models.CharField(max_length=30, blank=True, null=True)
    lessee_code = models.ForeignKey(Lessee, models.DO_NOTHING, db_column='lessee_code', blank=True, null=True, related_name="Service_lessecode")

    class Meta:
        managed = False
        db_table = 'service'


class Spa(models.Model):
    service_code = models.OneToOneField(Service, models.DO_NOTHING, db_column='service_code', primary_key=True)
    spa_spa = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'spa'
        unique_together = (('service_code', 'spa_spa'),)

class Sourvenirtype(models.Model):
    service_code = models.OneToOneField(Service, models.DO_NOTHING, db_column='service_code', primary_key=True)
    type_sour = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'sourvenirtype'
        unique_together = (('service_code', 'type_sour'),)


class Sourvenirbranch(models.Model):
    service_code = models.OneToOneField(Service, models.DO_NOTHING, db_column='service_code', primary_key=True)
    brand = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'sourvenirbranch'
        unique_together = (('service_code', 'brand'),)



class Space(models.Model):
    branch_code = models.OneToOneField(Branch, models.DO_NOTHING, db_column='branch_code', primary_key=True)
    ssn = models.BigIntegerField(unique=True)
    length_space = models.IntegerField(blank=True, null=True)
    width = models.IntegerField(blank=True, null=True)
    price = models.IntegerField()
    description_space = models.CharField(max_length=30, blank=True, null=True)
    service_code = models.ForeignKey(Service, models.DO_NOTHING, db_column='service_code', blank=True, null=True, related_name="Space_sercode")
    storename = models.CharField(max_length=30, blank=True, null=True)
    logo = models.CharField(max_length=30, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'space'
        unique_together = (('branch_code', 'ssn'),)



class StorePicture(models.Model):
    branch_code = models.OneToOneField(Space, models.DO_NOTHING, db_column='branch_code', primary_key=True)
    space_ssn = models.ForeignKey(Space, models.DO_NOTHING, db_column='space_ssn', to_field='ssn', related_name="StorePic_space_ssn")
    picture = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'store_picture'
        unique_together = (('branch_code', 'space_ssn', 'picture'),)



class Openningtime(models.Model):
    branch_code = models.OneToOneField('Space', models.DO_NOTHING, db_column='branch_code', primary_key=True)
    space_ssn = models.ForeignKey('Space', models.DO_NOTHING, db_column='space_ssn', to_field='ssn', related_name="openning_space_ssn")
    openningtime = models.CharField(max_length=5)
    closingtime = models.CharField(max_length=5, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'openningtime'
        unique_together = (('branch_code', 'space_ssn', 'openningtime'),)


# Create your models here.
