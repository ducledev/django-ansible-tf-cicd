from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser

class CustomUserAdmin(UserAdmin):
    model = CustomUser
    list_display = ['username', 'email', 'first_name', 'last_name', 'is_staff', 'is_customer']
    fieldsets = UserAdmin.fieldsets + (
        ('Custom Fields', {'fields': ('age', 'address', 'is_customer')}),
    )
    add_fieldsets = UserAdmin.add_fieldsets + (
        ('Custom Fields', {'fields': ('age', 'address', 'is_customer')}),
    )

admin.site.register(CustomUser, CustomUserAdmin)