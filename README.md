# packer-centos7


# packer template files
Although packer can run multiple builders in parallel, packer builders are separated by template file to lessen network connectivity requirements needed by ci/cd system runners.

#### aws-ami.json
This packer template creates an AWS EBS backed AMI.

#### vsphere-iso.json
This packer template creates a VMware OS  image using the vsphere-iso builder.


#### injecting boot secrets into the build?
- option:
  - variable list of environment variables
  - local shell provisioner
  - upload file
- option:
  - decrypt secret or fetch secret locally from makefile decrypt/secrets target
  - wire variable secret.env
  - variable to file upload



#### compliance step?
makefile inspec target vs packer inspec provisioner?

makefile inspec target can be a ci pipeline step or stage independently of packer run, but to run from separate stage/(agent runner) artifact would need to be created by packer and new instance launched

packer inspec provisioner
cannot be a ci pipeline step or stage. 





#### todo
* document pattern to add source control metadata labels to artifact
* in workflow document how specific component is used - or example, packer focuses in image build and executing os configuration mgmt. local privioner usage is minimal. Makefile would be used instead.
