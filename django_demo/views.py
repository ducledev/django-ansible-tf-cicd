from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages
from django.contrib.auth.decorators import login_required

def login_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('profile')  # Redirect to profile page after login
    return render(request, 'login.html')

# You'll need to create a home view as well
def home(request):
    return render(request, 'home.html')

@login_required
def profile_view(request):
    user = request.user
    user_data = {
        'Username': user.username,
        'Email': user.email,
        'First Name': user.first_name,
        'Last Name': user.last_name,
        'Date Joined': user.date_joined,
        'Last Login': user.last_login,
        'Is Active': user.is_active,
        'Is Staff': user.is_staff,
        'Is Customer': user.is_customer,
        'Age': user.age,
        'Address': user.address,
    }
    
    # Add custom user fields if they exist
    if hasattr(user, 'age'):
        user_data['Age'] = user.age
    if hasattr(user, 'address'):
        user_data['Address'] = user.address
    
    # You can add more custom fields here if your user model has them
    
    return render(request, 'profile.html', {'user_data': user_data})

def logout_view(request):
    logout(request)
    return redirect('home')  # This line is now redundant but can be kept for clarity