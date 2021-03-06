"""Main routing settings."""

__author__ = "arcadiy@google.com (Arkadii Yakovets)"

import session_csrf
# As per https://github.com/mozilla/django-session-csrf, make sure the patch
# is applied before views are imported.
session_csrf.monkeypatch()

from . import auth
from django.conf import settings
from django.conf.urls import include
from django.conf.urls import url
from django.conf.urls.static import static
from django.contrib import admin
from django.contrib.auth import views as auth_views
from django.views.i18n import javascript_catalog

admin.autodiscover()
admin.site.login = session_csrf.anonymous_csrf(admin.site.login)
auth_views.login = session_csrf.anonymous_csrf(auth_views.login)

# See https://docs.djangoproject.com/en/dev/topics/http/urls/
# and https://docs.djangoproject.com/en/dev/ref/contrib/admin/#adding-a-password-reset-feature
urlpatterns = [
    url(r"", include("core.urls")),
    url(r"^login/$", auth_views.login, {"template_name": "login.html.tmpl"}, name="login"),
    url(r"^logout/$", auth_views.logout),
    url(r"^password_change/$", auth_views.password_change, {"password_change_form": auth.ValidatingPasswordChangeForm}, name="password_change"),
    url(r"^password_change/done/$", auth_views.password_change_done, name="password_change_done"),
    url(r"^password_reset/$", auth_views.password_reset, name="password_reset"),
    url(r"^password_reset/done/$", auth_views.password_reset_done, name="password_reset_done"),
    url(r"^reset/(?P<uidb64>[0-9A-Za-z_\-]+)/(?P<token>.+)/$", auth_views.password_reset_confirm, {"set_password_form": auth.ValidatingSetPasswordForm}, name="password_reset_confirm"),
    url(r"^reset/done/$", auth_views.password_reset_complete, name="password_reset_complete"),
    url(r"^admin/", include(admin.site.urls)),
    url(r"^i18n/", include("django.conf.urls.i18n")),
    url(r"^jsi18n/$", javascript_catalog, name="js_catalog"),
]


# static() is a helper function to return a URL pattern for serving files in
# debug mode. If not in debug mode, this is a no-op.
urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
