# Giving alias (builder) to process
FROM php:7.4-cli as builder

WORKDIR /var/www

RUN apt-get update && \
    apt-get install zip -y

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');"

RUN mv composer.phar /usr/local/bin/composer && \
    composer global require laravel/installer

RUN composer create-project --prefer-dist laravel/laravel laravel


# Multistaging build
FROM php:7.4-fpm-alpine

WORKDIR /var/www

RUN rm -rf /var/www/html

# Using the builder process as reference to copy files
COPY --from=builder /var/www/laravel .
RUN chown -R www-data:www-data /var/www

EXPOSE 9000

ENTRYPOINT [ "php","laravel/artisan","serve" ]
CMD [ "--host=0.0.0.0" ]