name 'linux_base'
maintainer 'Chef'
maintainer_email 'davin@chef.io'
license 'All Rights Reserved'
description 'Installs/Configures linux_base'
long_description 'Installs/Configures linux_base'
version '2.5.0'
chef_version '>= 14.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/linux_base/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/linux_base'

# dependencies:
depends 'apache2', '>= 7.1.1'
