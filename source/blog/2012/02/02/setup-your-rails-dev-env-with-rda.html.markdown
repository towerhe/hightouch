---
title: Setup your rails development environment with RDA
author: Tower He
categories: [programming]
tags: [ruby, rails, nginx, passenger, rvm]
date_created: 2012/02/02
keywords: ruby, rails
---

### Intro

I created a project [rda](https://github.com/towerhe/rda) to help us setup our rails dev env more quickly.
It is in the early dev stage. By now it only provides two major
features:

* Create a .rvmrc file for your rails app
* Setup Nginx + Passenger for your rails app

READMORE

### Requirements

  * *RVM*

    RVM is a command-line tool which allows you to easily install,
  manage, and work with multiple ruby environments from interpreters to
  sets of gems.

    You should install RVM first. You can follow the installation tips
  on [https://rvm.beginrescueend.com/rvm/install/#explained](https://rvm.beginrescueend.com/rvm/install/#explained) or just execute the following instructions:

  ```:::bash
    bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
  ```

  * *Nginx + Passenger*

    Nginx is an HTTP and reverse proxy server, as well as a
  mail proxy server, written by Igor Sysoev. For a long time, it has been
  running on many heavily loaded Russian sites including Yandex, Mail.Ru,
  VKontakte, and Rambler. According to Netcraft nginx served or proxied 8.49% busiest sites in January 2012. 

    Phusion Passenger™ — a.k.a. mod_rails or mod_rack — makes deployment
  of Ruby web applications, such as those built on the revolutionary Ruby
  on Rails web framework, a breeze. It follows the usual Ruby on Rails
  conventions, such as “Don’t-Repeat-Yourself”.

    As simple as posible, you can follow the installation instructions
  on [http://www.modrails.com/install.html](http://www.modrails.com/install.html) or:

    *Note:* In the process of installing nginx, you will get an error when downloading
  pcre. For passenger 3.0.11, it tries to download pcre 8.12 which is
  removed when installing nginx. To fix this error, you should modify
  phusion_passenger.rb of the installed passenger gem directory and set the version of pcre to 8.21.

  ```:::bash
    # 1. Install passenger
    gem install passenger
    # 2. Install nginx
    passenger-install-nginx-module
  ```

### Install RDA

```:::bash
  gem install rda
```

Or simply add rda to the Gemfile

```:::ruby
  gem 'rda'
```

### Setup RVM

```:::bash
  rake rda:rvm:setup
```

First of all, this task will check whether the RVM is installed. If RVM
is installed, it will create a .rvmrc for the application with the
content which looks like:

```:::bash
  if [[ -s "/path/to/rvm/environments/ruby-1.9.3-p0@app_name" ]]; then
    . "/path/to/rvm/environments/ruby-1.9.3-p0@app_name"
  else
    rvm use ruby-1.9.3-p0@app_name --create
  fi
```

After RVM setup, you need to trust the rvmrc by:

```:::bash
  rvm rvmrc trust
```

Or you can set rvm_trust_rvmrcs_flag=1 in ~/.rvmrc or /etc/rvmrc.

If RVM is not installed this task will do nothing but exit.

### Setup Nginx + Passenger

```:::bash
  rake rda:nginx:setup
```

First this task will try to find the config files of Nginx which you
have installed from the following paths:

* /etc/nginx
* /usr/local/nginx/conf
* /opt/nginx/conf
  
You can change the default searching paths by:

```:::ruby
  Rda.configure { nginx_conf_paths ['/path/to/nginx/conf'] }
```

Please make sure that you have the write permission of the directory you
choosed, or you can run:

```:::bash
  sudo rake rda:nginx:setup
```

If there are more than one paths found, it will give you a choice to
decide which one will be used. After choosing a proper path, it will try
to create two directories sites-available and sites-enabled to save the
configs of rails applications.

* sites-available saves the configs of the rails applications.
* sites-enabled saves the link to the rails applications.

Next it will set Nginx to include the configs under sites-enabled. It
means that only the applications under sites-enabled will be loaded. And
than it will create a config file for your application under
sites-available and create a link to the config file under
sites-enabled. After all, it will create a local hostname for your
application in /etc/hosts.

Now You need to start Nginx: 

```:::bash
  /path/to/nginx/sbin/nginx
```

and then visit http://your_app_name.local.
