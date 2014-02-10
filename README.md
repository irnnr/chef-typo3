# TYPO3 Cookbook

An Opscode Chef cookbook to set up TYPO3.

## Usage

### typo3::default

Installs TYPO3 in a given version. However, does not configure the installation (yet). The install tool will be enabled after the recipe finished and you need to configure TYPO3 yourself.

A database and database user for the TYPO3 installation will be set up. 

The TYPO3 source is downloaded as a package from <http://get.typo3.org> and put into `/usr/src`.

Make sure to configure the `['typo3']['site_name']` attribute as it is used when configuring the Apache virtual host. The installation will live in `/var/www/site-['typo3']['site_name']`.

## Requirements

### Platform

Tested on Ubuntu / Debian

### Chef

Tested with Chef 10.14.2 

### Cookbooks

* apache2
* mysql
* database
* php
* cron


## Attributes

#### typo3::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['typo3']['version']</tt></td>
    <td>String</td>
    <td>Which version to install.</td>
    <td><tt>6.1.0</tt></td>
  </tr>
  <tr>
    <td><tt>['typo3']['package']</tt></td>
    <td>String</td>
    <td>Which site package to install. Tested with 'introduction' and 'government'.</td>
    <td><tt>introduction</tt></td>
  </tr>
  <tr>
    <td><tt>['typo3']['site_name']</tt></td>
    <td>String</td>
    <td>The site's name. Used for example in determining the folder in /var/www/.</td>
    <td><tt>typo3</tt></td>
  </tr>  
  <tr>
    <td><tt>['typo3']['use_typo3_htaccess']</tt></td>
    <td>Boolean</td>
    <td>By default the core's .htaccess file will be used. If you need to do custom modifications, you can turn that behavior off by setting this attribute to false. Is ignored when installing a site package.</td>
    <td><tt>true</tt></td>
  </tr>  
  <tr>
    <td><tt>['typo3']['server_name']</tt></td>
    <td>String</td>
    <td>Server name for the Apache vhost configuration.</td>
    <td><tt>node['fqdn']</tt></td>
  </tr>
  <tr>
    <td><tt>['typo3']['server_aliases']</tt></td>
    <td>String</td>
    <td>Server aliases for the vhost configuration.</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>['typo3']['db']['database']</tt></td>
    <td>String</td>
    <td>Database name.</td>
    <td><tt>typo3db</tt></td>
  </tr>
  <tr>
    <td><tt>['typo3']['db']['user']</tt></td>
    <td>String</td>
    <td>Database user</td>
    <td><tt>typo3user</tt></td>
  </tr>
  <tr>
    <td><tt>['typo3']['db']['password']</tt></td>
    <td>String</td>
    <td>Database password.</td>
    <td><tt>typo3password</tt></td>
  </tr>
</table>


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `feature_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Authors: [Ingo Renner](http://github.com/ingorenner) [(@irnnr)](http://twitter.com/irnnr)

Copyright: 2013, Ingo Renner

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.