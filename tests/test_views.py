from django.test import TestCase, Client
from django.contrib.auth.models import User
from django.urls import reverse

class UserTestCase(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.login_url = reverse('login')
        cls.home_url = reverse('home')
        
        # Create 5 users
        cls.users = []
        for i in range(5):
            user = User.objects.create_user(
                username=f'testuser{i}',
                password=f'password{i}',
                email=f'testuser{i}@example.com'
            )
            cls.users.append(user)

    def setUp(self):
        self.client = Client()

    @classmethod
    def tearDownClass(cls):
        # Clean up all created users
        User.objects.all().delete()
        super().tearDownClass()

    def test_login_success(self):
        response = self.client.post(self.login_url, {
            'username': 'testuser0',
            'password': 'password0'
        })
        self.assertRedirects(response, self.home_url)

    def test_login_failure(self):
        response = self.client.post(self.login_url, {
            'username': 'testuser0',
            'password': 'wrongpassword'
        })
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Invalid username or password")

    def test_user_count(self):
        self.assertEqual(User.objects.count(), 5)

    def test_user_emails(self):
        for i, user in enumerate(self.users):
            self.assertEqual(user.email, f'testuser{i}@example.com')

    def test_login_get(self):
        response = self.client.get(self.login_url)
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, 'login.html')