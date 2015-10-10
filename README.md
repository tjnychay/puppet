a) Created a custom cloudformation JSON using a template provided by AWS (stack name should be provided by the user):

	https://s3-us-west-2.amazonaws.com/cloudformation-templates-us-west-2/VPC_Single_Instance_In_Subnet.template


b) Added AdminPassword parameter in the "Parameters" section of the cloudformation JSON:

    "AdminPassword" : {
      "Description" : "Administrative Password Required for Login",
      "Type" : "String",
      "MinLength" : "1",
      "MaxLength" : "25",
      "AllowedPattern" : "[a-zA-Z0-9]*",
      "ConstraintDescription" : "Must be a valid Administrative Password (1-25 Characters)."
    },
    
c) Updated Instance size default in the cloudformation JSON to default to a smaller version:

    "InstanceType" : {
      "Description" : "WebServer EC2 instance type",
      "Type" : "String",
      "Default" : "t1.micro",
      "AllowedValues" : [ "t1.micro", "t2.micro", "t2.small", "t2.medium", "m1.small", "m1.medium", "m1.large", "m1.xlarge", "m2.xlarge", "m2.2xlarge", "m2.4xlarge", "m3.medium", "m3.large", "m3.xlarge", "m3.2xlarge", "c1.medium", "c1.xlarge", "c3.large", "c3.xlarge", "c3.2xlarge", "c3.4xlarge", "c3.8xlarge", "c4.large", "c4.xlarge", "c4.2xlarge", "c4.4xlarge", "c4.8xlarge", "g2.2xlarge", "r3.large", "r3.xlarge", "r3.2xlarge", "r3.4xlarge", "r3.8xlarge", "i2.xlarge", "i2.2xlarge", "i2.4xlarge", "i2.8xlarge", "d2.xlarge", "d2.2xlarge", "d2.4xlarge", "d2.8xlarge", "hi1.4xlarge", "hs1.8xlarge", "cr1.8xlarge", "cc2.8xlarge", "cg1.4xlarge"],
      "ConstraintDescription" : "must be a valid EC2 instance type."
    },


d) Assumption is that the key has already been generated using the key/special key pairing and downloaded locally

e) Added DNS Support and Hostnames in the "Resources" section to allow public DNS access

    "VPC" : {
      "Type" : "AWS::EC2::VPC",
      "Properties" : {
        "CidrBlock" : "10.0.0.0/16",
        "Tags" : [ {"Key" : "Application", "Value" : { "Ref" : "AWS::StackId"} } ],
        "EnableDnsSupport" : "true",
        "EnableDnsHostnames" : "true"
      }
    },

f) Assumption that single subnet setup is sufficient

e) Assumption that all inbound and outbound access is allowed

g) Added the following to "UserData" section

             "yum -y install ruby","\n",  ### Install Ruby
             "yum -y install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel","\n",  ###Install Rubygems prereqs
             "yum -y install ruby-rdoc ruby-devel","\n", ### Install rubygems prereqs
             "yum -y install rubygems","\n", ### Install rubygems
             "yum -y install puppet","\n", ### Install Standalone Puppet
             "yum -y install git","\n", ### Install git
             "yum -y install php php-mysql","\n", ### Install PHP
             "yum -y install mysql-server","\n", ### Install mysql
             "git clone https://github.com/tjnychay/puppet.git -b master /etc/puppet/temp","\n", ### Download repository from tjnychay/puppet github repository
             "mv /etc/puppet/temp/modules/ /etc/puppet/","\n", ### move the puppet modules from downloaded github repo to installed puppet modulepath on AWS instance
             "mv /etc/puppet/temp/manifests/ /etc/puppet/","\n", ### move puppet manifests from downloaded github repo to the installed puppet manifests location on AWS instance
             "puppet apply /etc/puppet/manifests/init.pp","\n" ### apply the main puppet manifest

h) Created the puppet manifest init.pp, which is called in the cloudformation JSON to set up the server instance
	
	include php::restart ### Calls the /etc/puppet/modules/php/manifests/init.pp class that restarts httpd service after php was installed via yum
	include mysql::start ### Calls the /etc/puppet/modules/mysql/manifests/init.pp class that starts the mysqld service after mysql was installed via yum
	include mysql::database ### Calls the /etc/puppet/modules/mysql/manifests/init.pp class that creates the blog database
	include mysql::password ### Calls the /etc/puppet/modules/mysql/manifests/init.pp that sets the root password for the database to a default value 'test'
	include wordpress::wget ### Calls the /etc/puppet/modules/wordpress/manifests/init.pp that downloads the latest wordpress package from the wordpress website
	include wordpress::untar ### Calls the /etc/puppet/modules/wordpress/manifests/init.pp that untars and gunzips the lates package from wordpress
	include wordpress::move ### Calls the /etc/puppet/modules/wordpress/manifests/init.pp that moves the wordpress package to a directory named 'blog'
	include wordpress::config ### Calls the /etc/puppet/modules/wordpress/manifests/init.pp that replaces the wp-config.php file with the file from the downloaded github repository
	
i) Assumption that user will hit the public DNS name from a browser/blog after starting up the instance and they can then add their own siteurl, username and password for their blog
	ex: http://ec2-52-88-111-0.us-west-2.compute.amazonaws.com/blog
