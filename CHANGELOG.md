# linux_base CHANGELOG

Changes made as we progress along in adjusting this cookbook

## 2.5.0

- Updated for Task 2:
  - Updated InSpec to test for everything in version 2 and version 1
- Modified recipe layout to put different functions into different, distinct recipes
  - The default recipe now just calls sub-recipes so that a run-list doesn't need to list them all
- Updated the tests to run from an actual Inspec profile, because I wanted to get better at building Inspec profiles
  - There are separate controls for the different functions of Jeff's tasks
  - Possibly, this profile could be used to validate cookbooks from future PS folks who's cookbook ability is being assessed

## 2.0.0

- Updated for Task 2:
  - create an Apache2 service on the system and configure a site for https
  - Create a hello world web page with a timestamp for creation date
  - Added personal flair to the web page with a custom resource for applying CSS to the site
    - Also added a background image of my usual id picture when online

- Still to do:
  - inspec tests for all of this

## 1.0.1

- Updated for Task 1: add resolv.conf management for DNS

## 1.0.0

- Prepped for task 1

## 0.1.0

- Initial release. Generated cookbook
