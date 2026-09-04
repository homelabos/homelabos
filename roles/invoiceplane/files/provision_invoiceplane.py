#!/usr/bin/env python3
"""Drive the InvoicePlane first-run setup wizard over HTTP.

InvoicePlane has no headless installer; its setup wizard is driven through the
web UI. It is session-gated (each step records progress in the PHP session) and
CSRF-protected (CodeIgniter 3), so we replay it with a persistent cookie jar
and pull the CSRF token from the csrf cookie before every POST.

The database is already configured by the role's seeded ipconfig.php, so the
wizard only needs to create the schema and the admin user. We run it to
completion, which writes SETUP_COMPLETED=true back into the (bind-mounted)
ipconfig.php.

Usage: provision_invoiceplane.py <base_url> <admin_email> <admin_name> <admin_password>
"""

import http.cookiejar
import sys
import urllib.error
import urllib.parse
import urllib.request

BASE = sys.argv[1].rstrip('/')
ADMIN_EMAIL = sys.argv[2]
ADMIN_NAME = sys.argv[3]
ADMIN_PASSWORD = sys.argv[4]

JAR = http.cookiejar.CookieJar()
OPENER = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(JAR))


def csrf_token():
    for cookie in JAR:
        if cookie.name == 'ip_csrf_cookie':
            return cookie.value
    raise RuntimeError('no CSRF cookie received; wizard unreachable')


def request(path, fields=None):
    if fields is None:
        req = urllib.request.Request(BASE + path)
    else:
        fields = dict(fields)
        fields['_ip_csrf'] = csrf_token()
        body = urllib.parse.urlencode(fields).encode('utf-8')
        req = urllib.request.Request(BASE + path, data=body)
        req.add_header('Content-Type', 'application/x-www-form-urlencoded')
    try:
        # urllib follows the wizard's 302 redirects automatically (to GET), and
        # its cookie jar keeps the session + regenerated CSRF cookie in sync.
        return OPENER.open(req, timeout=60)
    except urllib.error.HTTPError as exc:
        if exc.code in (301, 302, 303):
            return exc
        raise


def main():
    # Start a fresh session at the wizard root (sets the CSRF cookie).
    request('/index.php/setup')

    # 1. Choose language
    request('/index.php/setup/language', {'ip_lang': 'english', 'btn_continue': '1'})
    # 2. Prerequisites
    request('/index.php/setup/prerequisites', {'btn_continue': '1'})
    # 3. Database (already configured in ipconfig.php -> just continue)
    request('/index.php/setup/configure_database', {'btn_continue': '1'})
    # 4. Install tables
    request('/index.php/setup/install_tables', {'btn_continue': '1'})
    # 5. Upgrade tables (no-op on a fresh install)
    request('/index.php/setup/upgrade_tables', {'btn_continue': '1'})
    # 6. Create the admin user
    request('/index.php/setup/create_user', {
        'user_type': '1',
        'user_email': ADMIN_EMAIL,
        'user_name': ADMIN_NAME,
        'user_password': ADMIN_PASSWORD,
        'user_passwordv': ADMIN_PASSWORD,
        'user_language': 'system',
        'user_country': '',
        'btn_continue': '1',
    })
    # 7. Calculation info: LEGACY_CALCULATION=false in ipconfig.php makes the
    #    wizard skip straight to complete; if a form is shown, agree to it.
    response = request('/index.php/setup/calculation_info')
    body = response.read().decode('utf-8', 'replace')
    if 'btn_agree' in body:
        request('/index.php/setup/calculation_info', {'btn_agree': '1'})
    # 8. Complete (runs post_setup_tasks -> SETUP_COMPLETED=true)
    request('/index.php/setup/complete')

    print('invoiceplane setup wizard completed')


if __name__ == '__main__':
    main()
