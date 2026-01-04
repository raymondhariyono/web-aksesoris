FROM php:8.4-apache

# 1. Install library sistem yang dibutuhkan
RUN apt-get update && apt-get install -y \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Install ekstensi PHP yang wajib untuk CI4
RUN docker-php-ext-install intl mysqli

# 3. Aktifkan mod_rewrite (Fitur agar URL bersih tanpa index.php)
RUN a2enmod rewrite

# 4. Atur Document Root ke folder public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

# 5. [FIX UTAMA] Izinkan .htaccess (Ubah AllowOverride None menjadi All)
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf